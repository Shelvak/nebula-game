require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

class Technology::NeedsTechnologyTraitMock < Technology
  # Needed technologies are written in config/sets/default/text.yml
end

Factory.define :t_needs_technology_trait, :parent => :t_trait_mock,
:class => Technology::NeedsTechnologyTraitMock do |m|; end

describe Parts::NeedsTechnology do
  describe "on create" do
    it "should be valid if technology is present" do      
      tech = Factory.create :technology, :level => 2      
      model = Factory.build :t_needs_technology_trait,
        :player => tech.player
      model.should be_valid
    end

    it "should not be valid if tech level is insuffient" do
      tech = Factory.create :technology, :level => 1
      model = Factory.build :t_needs_technology_trait,
        :player => tech.player
      model.should_not be_valid
    end

    it "should not be valid if tech is not present" do
      model = Factory.build :t_needs_technology_trait
      model.should_not be_valid
    end

    it "should not be valid if tech is present and invert is set" do    
      tech1 = Factory.create :technology, :level => 2
      # Level 0 because tech should lock as soon as it's started
      tech2 = Factory.create :technology_larger, :level => 0,
        :player => tech1.player
      model = Factory.build :t_needs_technology_trait,
        :player => tech1.player
      model.should_not be_valid
    end
  end

  describe "on save" do
    it "should not validate technologies" do
      tech = Factory.create :technology, :level => 2
      model = Factory.create :t_needs_technology_trait,
        :player => tech.player

      tech.destroy
      lambda do
        model.upgrade!
      end.should_not raise_error(ActiveRecord::RecordInvalid)
    end
  end
end