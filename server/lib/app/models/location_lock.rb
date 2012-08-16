# Allows you to "lock" a LocationPoint so only one thread could access it.
class LocationLock < ActiveRecord::Base
  class << self
    def with_lock(location_point)
      acquire(location_point)
      yield
      # Not in ensure, because transaction will roll the insert back anyway if
      # anything fails.
      cleanup(location_point)
    end

  private

    def acquire(location_point)
      sql = sanitize_sql_for_assignment(point_conditions(location_point))
      connection.execute(
        "INSERT INTO `#{table_name}` SET #{sql}"
      )
    end

    def cleanup(location_point)
      sql = sanitize_sql_for_conditions(point_conditions(location_point))
      connection.execute(
        "DELETE FROM `#{table_name}` WHERE #{sql}"
      )
    end

    def point_conditions(location_point)
      case location_point.type
      when Location::GALAXY
        {
          location_galaxy_id: location_point.id,
          location_x: location_point.x, location_y: location_point.y
        }
      when Location::SOLAR_SYSTEM
        {
          location_solar_system_id: location_point.id,
          location_x: location_point.x, location_y: location_point.y
        }
      when Location::SS_OBJECT
        {location_ss_object_id: location_point.id}
      else
        raise "Unsupported #{location_point} type #{location_point.type}!"
      end
    end
  end
end