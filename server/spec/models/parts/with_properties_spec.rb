require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module Test
  class WithProperties
    include Parts::WithProperties

    def level
      3
    end
  end
end

describe Parts::WithProperties do
  describe "#evalproperty" do
    before(:all) do
      @model = Test::WithProperties.new
      @key = "some.key"
      @config_key = "#{@model.class.config_name}.#{@key}"
      @value = "3 * level"
    end

    it "should call GameConfig.safe_eval with params" do
      with_config_values(@config_key => @value) do
        GameConfig.should_receive(:safe_eval).with(
          @model.send(:property, @key),
          'level' => @model.level,
          'speed' => CONFIG['speed']
        )
        @model.evalproperty(@key)
      end
    end

    it "should take custom params" do
      with_config_values(@config_key => @value) do
        params = {'foo' => 'bar'}
        GameConfig.should_receive(:safe_eval).with(
          @model.send(:property, @key),
          params
        )
        @model.send :evalproperty, @key, nil, params
      end
    end

    it "should raise ArgumentError if key not found" do
      lambda do
        @model.send :evalproperty, "non.existant"
      end.should raise_error(ArgumentError)
    end

    it "should return 0 if level is 0" do
      with_config_values(@config_key => @value) do
        params = {'level' => 0}
        @model.send(:evalproperty, @key, nil, params).should == 0
      end
    end
  end
end

