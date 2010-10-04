module FastFind
  module ClassMethods
    def fast_find_all_for_planet(planet)
      planet = planet.id if planet.is_a? Planet
      raise ArgumentError.new("planet should only be Planet/Fixnum, not #{
        planet.class}") unless planet.is_a? Fixnum

      columns = fast_find_columns
      connection.select_all(
        "SELECT #{columns.keys.join(',')} FROM `#{table_name
          }` WHERE `planet_id`=#{planet}"
      ).map do |row|
        columns.each do |attr, method|
          attr = attr.to_s
          row[attr] = row[attr].send(method)
        end
        row
      end
    end
  end

  def self.included(receiver)
    receiver.extend ClassMethods
  end
end
