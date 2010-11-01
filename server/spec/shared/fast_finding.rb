describe "fast finding", :shared => true do
  before(:all) do
    @result = @klass.fast_find_all_for_planet(@planet)
  end

  it "should raise ArgumentError if passed anything but Planet/Fixnum" do
    lambda do
      @klass.fast_find_all_for_planet("@planet")
    end.should raise_error(ArgumentError)
  end

  it "should return array" do
    @result.should be_instance_of(Array)
  end

  it "should return array of hashes" do
    @result[0].should be_instance_of(Hash)
  end

  it "should cast attributes" do
    @klass.fast_find_columns.each do |attr, method|
      attr = attr.to_s
      @result[0][attr].should == @result[0][attr].send(method)
    end
  end
end