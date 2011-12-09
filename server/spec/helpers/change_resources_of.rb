RSpec::Matchers.define :change_resources_of do 
  |planet, exp_metal_change, exp_energy_change, exp_zetium_change, change_delta|

  change_delta ||= 0

  change_range = lambda do |expected_change|
    expected_change ||= 0
    (expected_change - change_delta)..(expected_change + change_delta)
  end

  check_change = lambda do |actual_change, expected_change|
    if expected_change.nil?
      actual_change != 0
    elsif expected_change == 0 && change_delta == 0
      actual_change == 0
    else
      change_range.call(expected_change).cover?(actual_change)
    end
  end

  change_msg = lambda do |actual_change, expected_change|
    "expected: #{change_range.call(expected_change)}, actual: #{actual_change}"
  end

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
    check_change.call(@metal_change, exp_metal_change) &&
      check_change.call(@energy_change, exp_energy_change) &&
      check_change.call(@zetium_change, exp_zetium_change)
  end

  failure_message_for_should do
    %Q{#{planet} should have had its resources changed:
  [metal change] #{change_msg.call(@metal_change, exp_metal_change)}
  [energy change] #{change_msg.call(@energy_change, exp_energy_change)}
  [zetium change] #{change_msg.call(@zetium_change, exp_zetium_change)}
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