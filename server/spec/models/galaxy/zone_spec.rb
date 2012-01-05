require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Galaxy::Zone do
  describe ".lookup" do
    [
      [0..4, -5..-1],
      [-5..-1, -5..-1],
      [-5..-1, 0..4],
      [0..4, 0..4],
    ].each do |x_range, y_range|
      x_range.each do |x|
        y_range.each do |y|
          it "should look up zone correctly for (#{x},#{y})" do
            looked_up = Galaxy::Zone.lookup(x, y)
            [looked_up.x, looked_up.y].should == [x, y]
          end
        end
      end
    end
  end
end