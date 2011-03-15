require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe Repeat do
  describe ".while_at_most_times" do
    it "should throw exception when reached max_iterations" do
      lambda { Repeat.while_at_most_times(nil, 100) { nil } }.should raise_error(
        Repeat::MaxIterationsReached)
    end

    it "should run given block exatcly given number of times" do
      times = 30
      $stack = []
      begin
        Repeat.while_at_most_times(nil, times) do
          $stack.push true
          nil
        end
      rescue Repeat::MaxIterationsReached
      end

      $stack.size.should eql(times)
    end

    it "should return value" do
      Repeat.while_at_most_times(nil, 100) do |iteration|
        iteration == 25 ? 25 : nil
      end.should eql(25)
    end
  end
end