module Parts::WithLocking
  def self.locking=(value)
    Thread.current[:with_locking] = value
  end
  def self.locking?
    value = Thread.current[:with_locking]
    value.nil? ? true : value
  end

  def self.comment=(value)
    Thread.current[:comment] = value
  end

  def self.included(receiver)
    # Only lock records if we are in transaction.
    receiver.instance_eval do
      default_scope do
        if Parts::WithLocking.locking? && connection.open_transactions > 0
          thread_name = Logging::Logger.thread_name
          comment = "#{thread_name}: #{Thread.current[:sql_comment] || "nil"}"

          lock(true).where("?!=''", comment)
        end
      end
    end
  end
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

### Lock tracking - for finding deadlocks in development ###

#raise "This should be commented out if in production!" if App.in_production?
#
#module ActiveRecord::ConnectionAdapters::DatabaseStatements
#  def select_all_with_lock_tracking(arel, *args)
#    should_add_lock = arel.is_a?(String) \
#      ? arel.include?("FOR UPDATE") : arel.locked
#    Parts::WithLocking::LOCK_LIST.add if should_add_lock
#    select_all_without_lock_tracking(arel, *args)
#  end
#
#  alias_method_chain :select_all, :lock_tracking
#end
#
#module Parts::WithLocking
#  LOCK_LIST = Class.new do
#    include MonitorMixin
#
#    def initialize
#      @locks = Set.new
#      super
#    end
#
#    def add
#      synchronize do
#        lock = caller.accept do |str|
#          str.include?("server/lib/") &&
#            !str.include?("`add_lock'") &&
#            !str.include?("parts/with_locking.rb") &&
#            !str.include?("lib/initializer.rb") &&
#            !str.include?("server/monkey_squad.rb")
#        end.map do |str|
#          str.sub(%r{^.+?/server/lib/}, "")
#        end
#
#        @locks.add(lock) unless lock.blank?
#      end
#    end
#
#    def dump
#      synchronize do
#        File.open("#{ROOT_DIR}/locks.txt", "w") do |f|
#          @locks.each_with_object({}) do |lock, hash|
#            hash[lock[0]] ||= []
#            hash[lock[0]] << lock
#          end.to_a.sort_by { |k, v| k }.each do |key, locks|
#            f.write("### #{key} ###\n\n")
#            locks.each do |lock|
#              f.write(lock.join("\n") + "\n\n")
#            end
#            f.write("\n")
#          end
#        end
#      end
#    end
#  end.new
#end
#
#RSpec.configure do |config|
#  config.after(:each) { Parts::WithLocking::LOCK_LIST.dump }
#end