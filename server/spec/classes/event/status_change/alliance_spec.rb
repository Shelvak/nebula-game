require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper.rb')
)

describe Event::StatusChange::Alliance do
  [
    [Event::StatusChange::Alliance::ACCEPT, StatusResolver::ALLY],
    [Event::StatusChange::Alliance::THROW_OUT, StatusResolver::ENEMY],
  ].each do |action, status|
    describe "#{action}" do
      before(:all) do
        owner = Factory.create(:player)
        @alliance = Factory.create(:alliance, :owner => owner)
        owner.alliance = @alliance
        owner.save!
        
        @allies = [
          owner,
          Factory.create(:player, :alliance => @alliance),
          Factory.create(:player, :alliance => @alliance)
        ]
        @player = Factory.create(:player, :alliance => @alliance)
        @event = Event::StatusChange::Alliance.new(
          @alliance,
          @player,
          action
        )
      end
      
      it "should change player status for allies" do
        @allies.each do |ally|
          @event.statuses[ally.id].should include([@player.id, status])
        end
      end
      
      it "should change ally statuses for player" do
        @allies.each do |ally|
          @event.statuses[@player.id].should include([ally.id, status])
        end
      end
      
      it "should not change status for self" do
        @event.statuses.each do |player_id, changes|
          changes.find { |pid, status| pid == player_id }.should be_nil
        end
      end
    end
  end
end