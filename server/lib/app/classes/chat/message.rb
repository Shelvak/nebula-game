# DB-persistent chat message. Please only use #store! and #retrieve methods
# and do not use this class directly as an ActiveRecord.
class Chat::Message < ActiveRecord::Base
  def self.table_name; "chat_messages"; end

  # Stores message for later retrieval.
  def self.store!(source_id, target_id, message)
    sql = {
      :source_id => source_id,
      :target_id => target_id,
      :message => message,
      :created_at => Time.now.to_s(:db)
    }
    connection.execute("INSERT INTO `#{table_name}` SET #{
      sanitize_sql_for_assignment(sql)}")
  end

  # Retrieves messages for player with _player_id_.
  #
  # Returns +Array+ of +Hash+es:
  # [
  #   {'source_id' => Fixnum, 'message' => String, 'created_at' => Time},
  #   ...
  # ]
  #
  def self.retrieve(player_id)
    ActiveRecord::Base.connection.select_all(
      "SELECT source_id, message, created_at FROM `#{
        table_name}` WHERE target_id=#{player_id.to_i
        } ORDER BY created_at"
    )
  end
end