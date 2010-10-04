class Repeat
  class << self
    def while_at_most_times(value, max_iterations)
      iteration = 1
      current = value
      while current == value
        raise self::MaxIterationsReached if iteration > max_iterations

        current = yield(iteration)
        iteration += 1
      end

      current
    end
  end
end