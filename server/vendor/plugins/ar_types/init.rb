Boolean = [TrueClass, FalseClass]

def typesig(binding, *signatures)
  vars = binding.eval %Q{
    local_variables.map do |var_name|
      [var_name, eval(var_name)]
    end
  }

  errors = []

  signatures.each_with_index do |signature, index|
    name, value = vars[index]
    case signature
      when Array
        valid = false
        signature.each do |s|
          if value.is_a?(s)
            valid = true
            break
          end
        end
        errors.push "Expected variable '#{name}' to be one of the #{
          signature.join(", ")} but it was #{value.class} (#{value.inspect})" \
          unless valid
      else
        errors.push "Expected variable '#{name}' to be #{
          signature} but it was #{value.class} (#{value.inspect})" \
          unless value.is_a?(signature)
    end
  end

  unless errors.size == 0
    errors = errors.map { |e| "* #{e}" }.join("\n")
    raise ArgumentError.new("Type signature mismatch!\n\n#{errors}")
  end
end