require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Chat::Control do
  include ControllerSpecHelper

  describe ".parse_args" do
    it "should support mixed notation" do
      Chat::Control.parse_args(%Q{foo "buz bar"   foo  "Dan Mc'Niel" lol'}).
        should == ["foo", "buz bar", "foo", "Dan Mc'Niel", "lol'"]
    end
  end

  describe "instance" do
    let(:dispatcher) { mock_dispatcher }
    let(:antiflood) { Chat::AntiFlood.new(dispatcher) }
    let(:control) { Chat::Control.new(dispatcher, antiflood) }
    let(:player) { Factory.create(:player, :chat_mod => true) }

    def should_transmit
      dispatcher.should_receive(:transmit).
        with(an_instance_of(Hash), player.id)
    end

    describe "#message" do
      let(:msg) { "/help" }

      describe "if player is not a chat moderator or admin" do
        before(:each) do
          player.admin = false
          player.chat_mod = false
        end

        it "should return false" do
          control.message(player, msg).should be_false
        end

        it "should not transmit anything to dispatcher" do
          dispatcher.should_not_receive(:transmit)
          control.message(player, msg)
        end
      end

      it "should return true on command" do
        control.message(player, "/help").should be_true
      end

      it "should return false on non-command" do
        control.message(player, "/lolololol").should be_false
      end

      describe "admin commands" do
        before(:each) do
          player.admin = true
          player.chat_mod = true
        end

        describe "/adminify" do
          let(:target) { Factory.create(:player, :galaxy => player.galaxy) }
          let(:msg) { %Q{/adminify "#{target.name}"} }

          it "should be ignored if invoked by chat mod" do
            player.admin = false
            dispatcher.should_not_receive(:transmit)
            control.message(player, msg).should be_false
          end

          it "should fail if wrong argument count is given" do
            lambda do
              control.message(player, msg + " lol")
              target.reload
            end.should_not change(target, :admin).to(true)
          end

          it "should not crash if player cannot be found" do
            target.destroy!
            control.message(player, msg)
          end

          it "should fail if player is in another galaxy" do
            target.galaxy = Factory.create(:galaxy)
            target.save!
            lambda do
              control.message(player, msg)
              target.reload
            end.should_not change(target, :admin).to(true)
          end

          it "should make player admin" do
            lambda do
              control.message(player, msg)
              target.reload
            end.should change(target, :admin).from(false).to(true)
          end
        end

        describe "/set_mod" do
          let(:target) { Factory.create(:player, :galaxy => player.galaxy) }
          def msg(value=true)
            %Q{/set_mod "#{target.name}" #{value.to_s}}
          end

          it "should be ignored if invoked by chat mod" do
            player.admin = false
            dispatcher.should_not_receive(:transmit)
            control.message(player, msg).should be_false
          end

          it "should fail if wrong argument count is given" do
            lambda do
              control.message(player, msg + " lol")
              target.reload
            end.should_not change(target, :chat_mod).to(true)
          end

          it "should not crash if player cannot be found" do
            target.destroy!
            control.message(player, msg)
          end

          it "should fail if player is in another galaxy" do
            target.galaxy = Factory.create(:galaxy)
            target.save!
            lambda do
              control.message(player, msg)
              target.reload
            end.should_not change(target, :chat_mod).to(true)
          end

          it "should be able to make player a chat moderator" do
            lambda do
              control.message(player, msg(true))
              target.reload
            end.should change(target, :chat_mod).from(false).to(true)
          end

          it "should be able to unmake player a chat moderator" do
            target.chat_mod = true
            target.save!
            lambda do
              control.message(player, msg(false))
              target.reload
            end.should change(target, :chat_mod).from(true).to(false)
          end
        end
      end

      describe "/help" do
        it "should support it" do
          should_transmit
          control.message(player, "/help")
        end
      end

      describe "/silence" do
        let(:target) { Factory.create(:player, :galaxy => player.galaxy) }
        let(:name) { %Q{"#{target.name}"} }
        let(:time) { %Q{"for 10 minutes"} }
        let(:msg) { %Q{/silence #{name} #{time}} }

        def should_not_silence
          antiflood.should_not_receive(:silence).
            with(target.id, an_instance_of(Time))
        end

        it "should not silence if wrong arg count" do
          should_not_silence
          control.message(player, "/silence lolol 1234 1234")
        end

        it "should not silence if it cannot find player" do
          target.destroy
          should_not_silence
          control.message(player, msg)
        end

        it "should not silence if player is in another galaxy" do
          target.galaxy = Factory.create(:galaxy)
          target.save!
          should_not_silence
          control.message(player, msg)
        end

        it "should not silence if player is another chat moderator" do
          target.chat_mod = true
          target.save!
          should_not_silence
          control.message(player, msg)
        end

        it "should not silence if it cannot parse time" do
          should_not_silence
          control.message(player, %Q{/silence #{name} "for x hours"})
        end

        it "should not silence if time is in the past" do
          should_not_silence
          control.message(player, %Q{/silence #{name} "5 minutes ago"})
        end

        it "should silence if everything is ok" do
          antiflood.should_receive(:silence).with(target.id, 5.minutes.from_now)
          control.message(player, %Q{/silence #{name} "for 5 minutes"})
        end

        it "should work" do
          control.message(player, msg)
        end
      end
    end
  end
end