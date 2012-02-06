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

      describe "if player is not a chat moderator" do
        before(:each) { player.chat_mod = false }

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