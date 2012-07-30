module Parts::WithLocking
  class LockEntry < Struct.new(:sql, :sql_comment, :backtrace)
  end

  def self.locking=(value)
    Thread.current[:with_locking] = value
  end
  def self.locking?
    value = Thread.current[:with_locking]
    value.nil? ? true : value
  end

  def self.track_locks=(value)
    Thread.current[:track_locks] = value
  end
  def self.track_locks?
    !! Thread.current[:track_locks]
  end

  def self.sql_comment=(value)
    Thread.current[:sql_comment] = value
  end
  def self.sql_comment
    Thread.current[:sql_comment]
  end

  def self.included(receiver)
    # Only lock records if we are in transaction.
    receiver.instance_eval do
      default_scope do
        if Parts::WithLocking.locking? && connection.open_transactions > 0
          thread_name = Logging::Logger.thread_name
          comment = "#{thread_name}: #{Parts::WithLocking.sql_comment || "nil"}"
          lock(true).where("?!=''", comment)
        end
      end
    end
  end

  LOCK_LIST = Class.new do
    include MonitorMixin

    def initialize
      super
      @locks = Hash.new { |hash, thread_name| hash[thread_name] = Set.new }
    end

    # Clears locks for current thread.
    def clear
      synchronize do
        @locks.delete(Logging::Logger.thread_name)
      end
    end

    def add(sql)
      synchronize do
        backtrace = caller.accept do |str|
          str.include?("server/lib/") &&
            !str.include?("`add_lock'") &&
            !str.include?("parts/with_locking.rb") &&
            !str.include?("lib/initializer.rb") &&
            !str.include?("server/monkey_squad.rb")
        end.map do |str|
          str.sub(%r{^.+?/server/lib/}, "")
        end

        unless backtrace.blank?
          lock = LockEntry.new(sql, Parts::WithLocking.sql_comment, backtrace)
          @locks[Logging::Logger.thread_name].add(lock)
        end
      end
    end

    def generate
      builder = Java::java.lang.StringBuilder.new
      synchronize do
        @locks.each_with_object({}) do |(thread_name, locks), hash|
          locks.each do |lock|
            first_backtrace_line = lock.backtrace[0]
            hash[first_backtrace_line] ||= {}
            hash[first_backtrace_line][thread_name] ||= []
            hash[first_backtrace_line][thread_name] << lock
          end
        end.to_a.sort_by { |k, v| k }.each do
          |first_backtrace_line, thread_locks|

          builder.append("### #{first_backtrace_line} ###\n\n")
          thread_locks.each do |thread_name, locks|
            builder.append("## Thread name: #{thread_name} ##\n\n")
            locks.each do |lock|
              builder.append("SQL: #{lock.sql}\n")
              builder.append("SQL comment: #{lock.sql_comment || "none"}\n")
              builder.append("Backtrace:\n#{lock.backtrace.join("\n")}\n\n")
            end
          end
          builder.append("\n")
        end
      end
      builder.to_s
    end

    def dump
      synchronize do
        File.open("#{ROOT_DIR}/locks.txt", "w") do |f|
          f.write("Generated @ #{Time.now.to_s}\n\n")
          f.write(generate)
        end
      end
    end
  end.new
end

# Disables SQL locking for this thread in given block. Only use this on
# read-only operations!
def without_locking
  old_value = Parts::WithLocking.locking?
  begin
    Parts::WithLocking.locking = false
    ret_value = yield
  ensure
    Parts::WithLocking.locking = old_value
  end
  ret_value
end

### Lock tracking - for finding deadlocks ###

module ActiveRecord::ConnectionAdapters::DatabaseStatements
  def select_all_with_lock_tracking(arel, *args)
    if Parts::WithLocking.track_locks?
      should_add_lock = sql = nil
      if arel.is_a?(String)
        if arel.include?("FOR UPDATE")
          should_add_lock = true
          sql = arel
        end
      else
        should_add_lock = arel.locked
        sql = arel.to_sql
      end

      Parts::WithLocking::LOCK_LIST.add(sql) if should_add_lock
    end
    select_all_without_lock_tracking(arel, *args)
  end

  alias_method_chain :select_all, :lock_tracking
end