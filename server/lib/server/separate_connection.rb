module SeparateConnection
  def finalize
    ActiveRecord::Base.connection_pool.checkin(@ar_connection) \
      unless @ar_connection.nil?
  end

  def set_ar_connection_id!
    ActiveRecord::Base.connection_id = ar_connection_id
  end

private

  def ar_connection_id
    # See "Fibers, Tasks and database connections" in GOTCHAS.md
    @ar_connection, @ar_connection_id =
      ActiveRecord::Base.connection_pool.checkout_with_id if @ar_connection.nil?
    @ar_connection_id
  end
end