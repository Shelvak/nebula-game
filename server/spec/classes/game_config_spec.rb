require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe GameConfig do
  # Backend config class that is set up during initialization.
  let(:global_config) do
    config = GameConfig.new
    # Stub our #setup! method.
    config.instance_variable_set("@set_up", true)
    config
  end

  # This one is actually used by code.
  let(:config) { GameConfig::ThreadLocal.new(global_config) }

  before(:each) do
    config = config
  end

  it "should support simple keys" do
    config['foo'] = 'bar'
    config['foo'].should == 'bar'
  end

  describe "sets" do
    before(:all) do
      @key = 'foo'
      @val1 = 'default_value'
      @set2 = 'turbo'
      @val2 = 'turbo_value'
    end

    it "should support different sets of config" do
      global_config.add_set(@set2)

      config[@key] = @val1
      config.store(@key, @set2, @val2)

      config[@key].should == @val1
      config[@key, @set2].should == @val2
    end

    it "should support fallbacks" do
      global_config.add_set(@set2, GameConfig::DEFAULT_SET)

      config[@key] = @val1
      config[@key, @set2].should == @val1
    end

    it "should support chaining fallbacks" do
      set3 = 'hyper'

      global_config.add_set(@set2, GameConfig::DEFAULT_SET)
      global_config.add_set(set3, @set2)

      config[@key] = @val1
      config[@key, set3].should == @val1
    end

    it "should support scoping" do
      global_config.add_set(@set2)

      config[@key] = @val1
      config.store(@key, @set2, @val2)

      config.with_set_scope(@set2) do |config|
        config[@key].should == @val2
      end
    end
  end

  describe "#hashrand" do
    it "should call self.class.hashrand" do
      config['hash.rand'] = [100, 200]
      Kernel.should_receive(:rangerand).with(100, 200 + 1)
      config.hashrand 'hash.rand'
    end

    it "should support sets" do
      set = 'turbo'
      global_config.add_set(set)
      config.store('hash.rand', set, [100, 200])
      config['hash.rand'] = [0, 50]
      config.hashrand('hash.rand', set).should be_included_in(100..200)
      config.hashrand('hash.rand').should be_included_in(0..50)
    end
  end

  describe "#each_matching" do
    it "should return matching keys with values" do
      set = 'turbo'
      global_config.add_set(set, GameConfig::DEFAULT_SET)

      keys = ['key0', 'key1', 'nonmatching']
      values = ['value0', 'value1', 'nonmatching value']
      config[keys[0]] = values[0]
      config.store(keys[1], set, values[1])
      config[keys[2]] = values[2]

      result = {}
      config.each_matching(/^key/, set) do |key, value|
        result[key] = value
      end

      result.should == {
        keys[0] => values[0],
        keys[1] => values[1]
      }
    end
  end

  describe ".safe_eval" do
    let(:formula) { "bar * 3" }

    it "should call scala" do
      params = {'bar' => 3.5}
      GameConfig::FormulaCalc.should_receive(:calc).
        with(formula, params.to_scala)
      GameConfig.safe_eval(formula, params)
    end

    it "should work with non-float params" do
      GameConfig.safe_eval(formula, {"bar" => 10}).should == 30.0
    end

    it "should work with ActiveSupport::Duration" do
      GameConfig.safe_eval(formula, {"bar" => 1.minute}).should == (60 * 3).to_f
    end

    it "should work with fixnum 'formulas'" do
      GameConfig.safe_eval(3).should == 3.0
    end

    it "should work with float 'formulas'" do
      GameConfig.safe_eval(3.5).should == 3.5
    end

    it "should work with ActiveSupport::Duration 'formulas'" do
      GameConfig.safe_eval(10.seconds).should == 10.0
    end
  end

  describe "#constantize_speed" do
    before(:all) do
      CONFIG["test.with_speed"] = "10 * a * speed"
      CONFIG["test.with_speed_no_vars"] = "10 * speed"
      @result = CONFIG.constantize_speed(CONFIG.filter(/^test\./))
    end

    it "should replace speed with value" do
      @result["test.with_speed"].should == "10 * a * #{CONFIG['speed']}"
    end

    it "should eval formulas without other variables" do
      @result["test.with_speed_no_vars"].should == 10 * CONFIG['speed']
    end
  end
end