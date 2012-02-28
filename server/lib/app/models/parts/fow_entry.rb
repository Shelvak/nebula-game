# Common features of fog of war classes.
module Parts::FowEntry
  def self.included(receiver)
    # FK :dependent => :destroy_all
    receiver.send :belongs_to, :player
    # FK :dependent => :destroy_all
    receiver.send :belongs_to, :alliance

    # TODO: outfactor spec to shared from FowSsEntry spec.
    receiver.send(:scope, :for, lambda { |player|
      conditions = [
        [
          "`#{receiver.table_name}`.player_id=?",
          player.alliance_id ? "`#{receiver.table_name}`.alliance_id=?" : nil
        ].compact.join(" OR "),
        player.id,
        player.alliance_id
      ].compact

      {:conditions => conditions}
    })

    receiver.extend ClassMethods
  end

  module ClassMethods
    # Return player ids that observe given point.
    def observer_player_ids(conditions, join="")
      alliance_ids = connection.select_values(
        "SELECT `alliance_id` FROM `#{table_name}` #{join} WHERE #{conditions}"
      ).map(&:to_i)

      # Return player ids that see this spot.
      connection.select_values(
        "
        SELECT `#{table_name}`.`player_id` FROM `#{table_name}` #{join}
          WHERE #{conditions}
        UNION
        SELECT `id` FROM `#{Player.table_name}` WHERE #{
          Player.sanitize_sql_hash_for_conditions(
            :alliance_id => alliance_ids
          )
        }
        "
      ).map(&:to_i)
    end

    # Updates records found with _check_params_ Hash counter
    # by _incrementation_.
    #
    # Calls _before_destroy_ with |kind_id| before
    # actually erasing records from database if provided.
    #
    # Returns :created if record was created.
    # Returns :updated if record was updated.
    # Returns :destroyed if record was destroyed.
    # Returns false if nothing was done.
    #
    def update_record(check_params, create_params, incrementation)
      incrementation = incrementation.to_i
      count = connection.select_value(
        "SELECT `counter` FROM `#{table_name}` WHERE #{
          sanitize_sql_for_conditions(check_params)}"
      )

      if count.nil?
        return false if incrementation < 0

        # Record does not exist, create it
        create_params["counter"] = incrementation
        connection.execute("INSERT INTO `#{table_name}` SET #{
          sanitize_sql_for_assignment(create_params)}")

        return :created
      else
        value = count.to_i + incrementation
        if value > 0
          # Just update value
          connection.execute("UPDATE `#{table_name}` SET `counter`=#{
            value} WHERE #{sanitize_sql_for_conditions(check_params)}")

          return :updated
        else
          # Destroy record
          conditions = sanitize_sql_for_conditions(check_params)
          connection.execute("DELETE FROM `#{table_name}` WHERE #{conditions}")
          return :destroyed
        end
      end
    end
  end
end
