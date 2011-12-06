RSpec::Matchers.define :change_resources_of do 
  |planet, exp_metal_change, exp_energy_change, exp_zetium_change|
  
  match do |block|
    old_metal, old_energy, old_zetium = planet.metal, planet.energy,
      planet.zetium

    block.call

    new_metal, new_energy, new_zetium = planet.metal, planet.energy,
      planet.zetium
    
    @metal_change = new_metal - old_metal
    @energy_change = new_energy - old_energy
    @zetium_change = new_zetium - old_zetium

    # If resource is not specified check if it has changed at all.
    # If resource is specified check if exact amount has changed.
    (exp_metal_change.nil? \
        ? @metal_change != 0 : @metal_change == exp_metal_change) &&
      (exp_energy_change.nil? \
        ? @energy_change != 0 : @energy_change == exp_energy_change) &&
      (exp_zetium_change.nil? \
        ? @zetium_change != 0 : @zetium_change == exp_zetium_change)
  end

  failure_message_for_should do
    %Q{#{planet} should have had its resources changed but it did not:
  [metal change] expected: #{exp_metal_change || "any amount"}, actual: #{
    @metal_change}
  [energy change] expected: #{exp_energy_change || "any amount"}, actual: #{
    @energy_change}
  [zetium change] expected: #{exp_zetium_change || "any amount"}, actual: #{
    @zetium_change}
}
  end

  failure_message_for_should_not do
    %Q{#{planet} should not have had its resources changed but it did:
  [metal change] expected: none, actual: #{@metal_change}
  [energy change] expected: none, actual: #{@energy_change}
  [zetium change] expected: none, actual: #{@zetium_change}
}
  end
end