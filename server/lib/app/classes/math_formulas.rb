SpaceMule

class MathFormulas
  # Returns a lambda which can be used to calculate points in given line (which
  # is calculated from two points).
  def self.line(x1, y1, x2, y2)
    formula = Java::spacemule.helpers.MathFormulas.
      line(x1.to_f, y1.to_f, x2.to_f, y2.to_f)
    lambda { |x| formula.apply(x.to_f) }
  end
end