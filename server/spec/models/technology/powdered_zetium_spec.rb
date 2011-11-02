require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe Technology::PowderedZetium do
  it_behaves_like "resource increasing technology",
                  Factory.create!(:t_powdered_zetium)
end
