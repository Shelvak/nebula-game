require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe Visibility do
  describe ".track_location_changes" do
    let(:wrapper) { Struct.new(:block_executed).new(false) }
    let(:block) do
      wrapper = self.wrapper
      lambda do
        wrapper.block_executed = true
      end
    end
    let(:player) { Factory.create(:player) }

    shared_examples_for "calling block" do
      it "should call the block" do
        Visibility.track_location_changes(location_point, &block)
        wrapper.block_executed.should be_true
      end
    end

    shared_examples_for "tracking ss metadata" do
      describe "solar system created" do
        it "should dispatch event if solar system was created" do
          SPEC_EVENT_HANDLER.clear_events!

          Visibility.track_location_changes(location_point) do
            Factory.create(:u_crow, location: location_point, player: player)
          end

          event = Event::FowChange::SsCreated.new(
            solar_system.id, solar_system.x, solar_system.y, solar_system.kind,
            Player.minimal(solar_system.player_id), [player],
            SolarSystem::Metadatas.new(solar_system.id)
          )
          SPEC_EVENT_HANDLER.events.should include([
            event, EventBroker::FOW_CHANGE, EventBroker::REASON_SS_ENTRY
          ])
        end

        it "should not dispatch event if ss was not created" do
          Factory.create(:u_crow, location: location_point, player: player)
          should_not_fire_event(
            an_instance_of(Event::FowChange::SsCreated),
            EventBroker::FOW_CHANGE, EventBroker::REASON_SS_ENTRY
          ) do
            Visibility.track_location_changes(location_point) do
              Factory.create(:u_crow, location: location_point, player: player)
            end
          end
        end

        it "should not dispatch event if it happened in battleground" do
          should_not_fire_event(
            an_instance_of(Event::FowChange::SsCreated),
            EventBroker::FOW_CHANGE, EventBroker::REASON_SS_ENTRY
          ) do
            Visibility.track_location_changes(bg_location_point) do
              Factory.create(:u_crow, location: bg_location_point,
                player: player)
            end
          end
        end
      end

      describe "solar system destroyed" do
        let(:unit) do
          Factory.create(:u_crow, location: location_point, player: player)
        end
        let(:delete) do
          lambda do
            Visibility.track_location_changes(location_point) do
              # #destroy wraps it in #track_location_changes.
              Unit.where(id: unit.id).delete_all
            end
          end
        end

        before(:each) do
          unit
        end

        it "should dispatch event if solar system was destroyed" do
          SPEC_EVENT_HANDLER.clear_events!

          delete.call

          event = Event::FowChange::SsDestroyed.new(
            solar_system.id, [player.id]
          )
          SPEC_EVENT_HANDLER.events.should include([
            event, EventBroker::FOW_CHANGE, EventBroker::REASON_SS_ENTRY
          ])
        end

        it "should not dispatch event if metadata was not updated" do
          Factory.create(:u_crow, location: location_point, player: player)
          should_not_fire_event(
            an_instance_of(Event::FowChange::SsDestroyed),
            EventBroker::FOW_CHANGE, EventBroker::REASON_SS_ENTRY
          ) do
            delete.call
          end
        end

        describe "if it happened in battleground" do
          let(:unit) do
            Factory.create(:u_crow, location: bg_location_point, player: player)
          end
          let(:delete) do
            lambda do
              Visibility.track_location_changes(bg_location_point) do
                # #destroy wraps it in #track_location_changes.
                Unit.where(id: unit.id).delete_all
              end
            end
          end

          it "should not dispatch event" do
            should_not_fire_event(
              an_instance_of(Event::FowChange::SsDestroyed),
              EventBroker::FOW_CHANGE, EventBroker::REASON_SS_ENTRY
            ) do
              delete.call
            end
          end
        end
      end
    end

    describe "tracking galaxy point" do
      let(:location_point) { GalaxyPoint.new(1, 0, 0) }

      it_should_behave_like "calling block"
    end

    describe "tracking solar system point" do
      let(:solar_system) { Factory.create(:solar_system) }
      let(:location_point) { SolarSystemPoint.new(solar_system.id, 0, 0) }
      let(:battleground) { Factory.create(:battleground) }
      let(:bg_location_point) { SolarSystemPoint.new(battleground.id, 0, 0) }

      it_should_behave_like "calling block"
      it_should_behave_like "tracking ss metadata"

      describe "solar system updated" do
        it "should dispatch event if metadata was updated" do
          SPEC_EVENT_HANDLER.clear_events!

          Factory.create(:u_crow, location: location_point, player: player)
          Visibility.track_location_changes(location_point) do
            Factory.create(:u_crow, location: location_point)
          end

          event = Event::FowChange::SsUpdated.new(
            solar_system.id, [player],
            SolarSystem::Metadatas.new(solar_system.id)
          )
          SPEC_EVENT_HANDLER.events.should include([
            event, EventBroker::FOW_CHANGE, EventBroker::REASON_SS_ENTRY
          ])
        end

        it "should not dispatch event if metadata was not updated" do
          Factory.create(:u_crow, location: location_point, player: player)
          should_not_fire_event(
            an_instance_of(Event::FowChange::SsUpdated),
            EventBroker::FOW_CHANGE, EventBroker::REASON_SS_ENTRY
          ) do
            Visibility.track_location_changes(location_point) do
              Factory.create(:u_crow, location: location_point, player: player)
            end
          end
        end

        describe "in battleground" do
          it "should dispatch updated even if metadata was created" do
            SPEC_EVENT_HANDLER.clear_events!

            Visibility.track_location_changes(bg_location_point) do
              Factory.create(:u_crow, location: bg_location_point,
                player: player)
            end

            event = Event::FowChange::SsUpdated.new(
              battleground.id, [player],
              SolarSystem::Metadatas.new(battleground.id)
            )
            SPEC_EVENT_HANDLER.events.should include([
              event, EventBroker::FOW_CHANGE, EventBroker::REASON_SS_ENTRY
            ])
          end

          it "should dispatch updated even if metadata was destroyed" do
            SPEC_EVENT_HANDLER.clear_events!

            unit = Factory.create(:u_crow, location: bg_location_point,
              player: player)
            Visibility.track_location_changes(bg_location_point) do
              Unit.where(id: unit.id).delete_all
            end

            event = Event::FowChange::SsUpdated.new(
              battleground.id, [player],
              SolarSystem::Metadatas.new(battleground.id)
            )
            SPEC_EVENT_HANDLER.events.should include([
              event, EventBroker::FOW_CHANGE, EventBroker::REASON_SS_ENTRY
            ])
          end
        end
      end
    end

    describe "tracking planet" do
      let(:planet) { Factory.create(:planet) }
      let(:solar_system) { planet.solar_system }
      let(:location_point) { LocationPoint.planet(planet.id) }
      let(:battleground) { Factory.create(:battleground) }
      let(:bg_planet) { Factory.create(:planet, solar_system: battleground) }
      let(:bg_location_point) { LocationPoint.planet(bg_planet.id) }

      it_should_behave_like "calling block"
      it_should_behave_like "tracking ss metadata"

      describe "solar system updated" do
        def gain_visibility
          planet
          Factory.create(:u_crow, location: location_point, player: player)
        end

        it "should dispatch event if metadata was updated" do
          gain_visibility

          SPEC_EVENT_HANDLER.clear_events!
          # Actual update.
          Visibility.track_location_changes(location_point) do
            planet.update_row! player_id: player.id
          end

          event = Event::FowChange::SsUpdated.new(
            solar_system.id, [player],
            SolarSystem::Metadatas.new(solar_system.id)
          )
          SPEC_EVENT_HANDLER.events.should include([
            event, EventBroker::FOW_CHANGE, EventBroker::REASON_SS_ENTRY
          ])
        end

        it "should not dispatch event if metadata was not updated" do
          should_not_fire_event(
            an_instance_of(Event::FowChange::SsUpdated),
            EventBroker::FOW_CHANGE, EventBroker::REASON_SS_ENTRY
          ) do
            Visibility.track_location_changes(location_point) do
              Factory.create(:u_crow, location: location_point, player: player)
            end
          end
        end

        describe "in battleground" do
          it "should dispatch updated even if metadata was created" do
            bg_planet

            SPEC_EVENT_HANDLER.clear_events!
            Visibility.track_location_changes(bg_location_point) do
              bg_planet.update_row! player_id: player.id
            end

            event = Event::FowChange::SsUpdated.new(
              battleground.id, [player],
              SolarSystem::Metadatas.new(battleground.id)
            )
            SPEC_EVENT_HANDLER.events.should include([
              event, EventBroker::FOW_CHANGE, EventBroker::REASON_SS_ENTRY
            ])
          end

          it "should dispatch updated even if metadata was destroyed" do
            bg_planet.update_row! player_id: player.id
            SPEC_EVENT_HANDLER.clear_events!

            Visibility.track_location_changes(bg_location_point) do
              bg_planet.update_row! player_id: nil
            end

            event = Event::FowChange::SsUpdated.new(
              battleground.id, [player],
              SolarSystem::Metadatas.new(battleground.id)
            )
            SPEC_EVENT_HANDLER.events.should include([
              event, EventBroker::FOW_CHANGE, EventBroker::REASON_SS_ENTRY
            ])
          end
        end
      end

      describe "planet updated" do
        shared_examples_for "dispatching changed for planet" do
          it "should dispatch changed for planet" do
            should_fire_event(planet, EventBroker::CHANGED) do
              block.call
            end
          end
        end

        shared_examples_for "not dispatching planet observers change" do
          it "should not dispatch planet observers change" do
            should_not_fire_event(
              an_instance_of(Event::PlanetObserversChange),
              EventBroker::CREATED
            ) { block.call }
          end
        end

        describe "observer gained" do
          let(:block) do
            lambda do
              Visibility.track_location_changes(location_point) do
                Factory.create(:u_crow, location: planet)
              end
            end
          end

          it_should_behave_like "dispatching changed for planet"
          it_should_behave_like "not dispatching planet observers change"
        end

        describe "observer lost" do
          let(:unit) { Factory.create(:u_crow, location: planet) }
          let(:block) do
            lambda do
              Visibility.track_location_changes(location_point) do
                # #destroy wraps it in #track_location_changes.
                Unit.where(id: unit.id).delete_all
              end
            end
          end

          before(:each) do
            unit
          end

          it_should_behave_like "dispatching changed for planet"

          it "should dispatch planet observers change" do
            should_fire_event(
              Event::PlanetObserversChange.new(planet.id, [unit.player_id]),
              EventBroker::CREATED
            ) do
              block.call
            end
          end
        end

        describe "observers didn't change'" do
          let(:block) do
            lambda do
              Visibility.track_location_changes(location_point) do
                Factory.create(:u_crow, location: planet, player: player)
              end
            end
          end

          before(:each) do
            Factory.create(:u_crow, location: planet, player: player)
          end

          it_should_behave_like "not dispatching planet observers change"

          it "should not dispatch changed for planet" do
            should_not_fire_event(planet, EventBroker::CHANGED) { block.call }
          end
        end
      end
    end
  end

  describe ".track_movement_changes" do
    galaxy_location1 = GalaxyPoint.new(1, 0, 0)
    galaxy_location2 = GalaxyPoint.new(1, 1, 0)
    ss_location1 = SolarSystemPoint.new(10, 0, 0)
    ss_location2 = SolarSystemPoint.new(15, 0, 0)
    planet_location = LocationPoint.planet(20)

    [
      [galaxy_location1, galaxy_location2, nil],
      [galaxy_location1, ss_location1, ss_location1],
      [ss_location1, planet_location, planet_location],
      [planet_location, ss_location1, planet_location],
      [ss_location1, ss_location2, ss_location1],
    ].each do |source, target, expected|
      describe "when going from #{source} to #{target}" do
        if expected.nil?
          it "should just call block" do
            executed = false
            Visibility.track_movement_changes(source, target) do
              executed = true
            end
            executed.should be_true
          end
        else
          it "should pass #{expected} to .track_location_changes" do
            block = proc { }
            Visibility.should_receive(:track_location_changes).
              with(expected, &block)
            Visibility.track_movement_changes(source, target, &block)
          end
        end
      end
    end
  end
end