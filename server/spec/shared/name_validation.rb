# encoding: UTF-8

shared_examples_for "name validation" do
  it "should not allow setting name shorter than min symbols" do
    @model.name = "a" * (@min - 1)
    @model.should_not be_valid
  end

  it "should not allow setting name longer than max symbols" do
    @model.name = "a" * (@max + 1)
    @model.should_not be_valid
  end

  it "should not allow setting blank name" do
    @model.name = " " * @min
    @model.should_not be_valid
  end

  it "should strip name" do
    name = "a" * @min
    @model.name = " #{name} "
    @model.save!
    @model.name.should == name
  end

  it "should replace double spaces with single ones" do
    name = "a" * @min
    @model.name = " #{name}  #{name} "
    @model.save!
    @model.name.should == "#{name} #{name}"
  end

  it "should support utf" do
    @model.name = "Ų" * @max
    @model.save!
    @model.should be_valid
  end
end