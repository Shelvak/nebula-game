class Counter
  def initialize(scope, header, finder=nil, namer=nil)
    @scope = scope
    @header = header
    @finder = finder || lambda { |s, &block| s.find_each(&block) }
    @namer = namer || lambda { |obj| obj.id }
  end

  def each
    total = @scope.count
    if total == 0
      puts "Nothing to do for #{@header}."
      return
    end

    index = 1
    @finder.call(@scope) do |obj|
      $stdout.write("\r#{@header} #{@namer[obj]} (#{index}/#{total})")
      yield obj
      $stdout.write(".")
      index += 1
    end

    puts " Done."
  end
end