class Counter
  def initialize(scope, header, name_func=nil)
    @scope = scope
    @header = header
    @name_func = name_func || lambda { |obj| obj.id }
  end

  def each
    total = @scope.count
    if total == 0
      puts "Nothing to do for #{@header}."
      return
    end

    index = 1
    @scope.find_each do |obj|
      $stdout.write("\r#{@header} #{@name_func[obj]} (#{index}/#{total})")
      yield obj
      $stdout.write(".")
      index += 1
    end

    puts " Done."
  end
end