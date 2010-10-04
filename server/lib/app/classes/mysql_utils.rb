class MysqlUtils
  # Slice size when mass-inserting records
  SLICE_SIZE = 1024 * 32

  class << self
    def mass_insert(table_name, fields, values)
      0.step(values.size - 1, SLICE_SIZE) do |range_start|
        range = range_start...(range_start + SLICE_SIZE)
        ActiveRecord::Base.connection.execute(
          "INSERT INTO `#{table_name}` (#{fields}) " +
          "VALUES #{values[range].join(",")}"
        )
      end
    end
  end
end
