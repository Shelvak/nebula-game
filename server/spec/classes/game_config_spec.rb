require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe GameConfig do
  before(:each) do
    @object = GameConfig.new
  end

  it "should support simple keys" do
    @object['foo'] = 'bar'
    @object['foo'].should == 'bar'
  end

  describe "sets" do
    before(:all) do
      @key = 'foo'
      @val1 = 'default_value'
      @set2 = 'turbo'
      @val2 = 'turbo_value'
    end

    it "should support different sets of config" do
      @object.add_set(@set2)

      @object[@key] = @val1
      @object[@key, @set2] = @val2

      @object[@key].should == @val1
      @object[@key, @set2].should == @val2
    end

    it "should support fallbacks" do
      @object.add_set(@set2, GameConfig::DEFAULT_SET)

      @object[@key] = @val1
      @object[@key, @set2].should == @val1
    end

    it "should support chaining fallbacks" do
      set3 = 'hyper'

      @object.add_set(@set2, GameConfig::DEFAULT_SET)
      @object.add_set(set3, @set2)

      @object[@key] = @val1
      @object[@key, set3].should == @val1
    end

    it "should support scoping" do
      @object.add_set(@set2)

      @object[@key] = @val1
      @object[@key, @set2] = @val2

      @object.with_set_scope(@set2) do |config|
        config[@key].should == @val2
      end
    end
  end

  describe "#with_scope" do
    it "should allow scoped get" do
      scope = "foo.bar"
      @key = "baz"
      value = 200
      
      @object["#{scope}.#{@key}"] = value

      @object.with_scope(scope) do |config|
        config[@key].should == value
      end
    end

    it "should allow scoped write" do
      scope = "foo.bar"
      @key = "baz"
      value = 200

      @object.with_scope(scope) do |config|
        config[@key] = value
      end

      @object["#{scope}.#{@key}"].should == value
    end

    it "should work with #hashrand" do
      scope = "foo.bar"
      @key = "baz"
      from = 200
      to = 300

      @object["#{scope}.#{@key}"] = [from, to]

      @object.with_scope(scope) do |config|
        config.hashrand(@key).should be_included_in(from..to)
      end
    end
  end

  describe "#hashrand" do
    it "should call self.class.hashrand" do
      @object = GameConfig.new
      @object['hash.rand'] = [100, 200]
      Kernel.should_receive(:rangerand).with(100, 200 + 1)
      @object.hashrand 'hash.rand'
    end

    it "should support sets" do
      set = 'turbo'
      @object.add_set(set)
      @object.merge!({'hash.rand' => [100, 200]}, set)
      @object.merge!({'hash.rand' => [0, 50]})
      @object.hashrand('hash.rand', set).should be_included_in(100..200)
      @object.hashrand('hash.rand').should be_included_in(0..50)
    end
  end

  describe "#each_matching" do
    it "should return matching keys with values" do
      set = 'turbo'
      @object.add_set(set, GameConfig::DEFAULT_SET)

      keys = ['key0', 'key1', 'nonmatching']
      values = ['value0', 'value1', 'nonmatching value']
      @object[keys[0]] = values[0]
      @object[keys[1], set] = values[1]
      @object[keys[2]] = values[2]

      result = {}
      @object.each_matching(/^key/, set) do |key, value|
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