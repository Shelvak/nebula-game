require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

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

  it "should support initial params" do
    @object = GameConfig.new 'foo.bar.baz' => '123'
    @object['foo.bar.baz'].should == '123'
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

      @object["#{scope}.#{@key}.from"] = from
      @object["#{scope}.#{@key}.to"] = to

      @object.with_scope(scope) do |config|
        config.hashrand(@key).should be_included_in(from..to)
      end
    end
  end

  describe "#hashrand" do
    it "should call self.class.hashrand" do
      @object = GameConfig.new 'hash.rand.from' => 100, 'hash.rand.to' => 200
      Kernel.should_receive(:rangerand).with(100, 200 + 1)
      @object.hashrand 'hash.rand'
    end

    it "should support sets" do
      set = 'turbo'
      @object.add_set(set)
      @object.merge!({'hash.rand.from' => 100, 'hash.rand.to' => 200}, set)
      @object.merge!({'hash.rand.from' => 0, 'hash.rand.to' => 50})
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

  describe ".filter_for_eval" do
    it "should only leave formulas" do
      GameConfig.filter_for_eval("(1 + 2 - 3 * 4 / 5 ** level)").should == \
        "(1 + 2 - 3 * 4 / 5 ** )"
    end

    it "should substitute params" do
      level = 30
      GameConfig.filter_for_eval(
        "(1 + 2 - 3 * 4 / 5 ** level)",
        :level => level
      ).should == "(1 + 2 - 3 * 4 / 5 ** #{level})"
    end

    it "should substitute multiple params with same beginnings" do
      xp_with_dead = 10
      xp = 20
      GameConfig.filter_for_eval(
        "(xp_with_dead + xp)",
        :xp_with_dead => xp_with_dead,
        :xp => xp
      ).should == "(#{xp_with_dead} + #{xp})"
    end
  end

  describe ".safe_eval" do
    it "should call .filter_for_eval" do
      string = "foo"
      params = {'bar' => 'baz'}
      GameConfig.should_receive(:filter_for_eval).with(string, params).and_return("")
      GameConfig.safe_eval(string, params)
    end
  end
end