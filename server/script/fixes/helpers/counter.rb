class Counter
  def initialize(scope, header)
    @scope = scope
    @header = header
  end

  def each
    total = @scope.count
    index = 1
    @scope.find_each do |obj|
      $stdout.write("\r#{@header} #{obj.id} (#{index}/#{total})")
      yield obj
      $stdout.write(".")
      index += 1
    end

    puts " Done."
  end
end