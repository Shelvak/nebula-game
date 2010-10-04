require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

class Planet::MinableMock < Planet
  include Planet::Minable
end

Factory.define :p_minable, :parent => :planet,
:class => Planet::MinableMock do |m|; end

describe Planet::Minable do
  %w{metal energy zetium}.each do |resource|
    it "should have ##{resource}_rate" do
      Factory.build(:p_minable).should respond_to("#{resource}_rate")
    end

    it "should have .#{resource}_rate which accesses config" do
      CONFIG.should_receive(:hashrand).with("planet.minable_mock.rates.#{resource}")
      Planet::MinableMock.send("#{resource}_rate")
    end
  end
end