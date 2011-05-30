require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

class Building::RequiringTileTraitMock < Building
  include Trait::RequiringTile
end

Factory.define :b_requiring_tile_trait, :parent => :b_trait_mock,
:class => Building::RequiringTileTraitMock do |m|; end

describe Building::RequiringTileTraitMock do
  
end