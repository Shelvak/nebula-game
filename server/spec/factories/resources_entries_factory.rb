Factory.define :resources_entry do |m|
  m.association :planet, :skip_resources_entry => true

  # Order is important here, storage must be increased first.
  m.metal_storage 10000
  m.metal 9000

  m.energy_storage 10000
  m.energy 9000

  m.zetium_storage 10000
  m.zetium 9000
end