class Threading::Director
  class TaskInfo < Struct.new(:description, :start_time)
    def initialize(description)
      super(description, Time.now)
    end

    # Return elapsed time from task start in milliseconds.
    def elapsed(now=Time.now)
      ((now - start_time) * 1000).round
    end
  end

  include NamedLogMessages
  include Celluloid

  def initialize(name, pool)
    @name = name
    Actor[to_s] = current_actor
    java.lang.Thread.current_thread.name = "#{to_s}-main"

    @workers = {}
    # {name => TaskInfo}
    @worker_tasks = {}
    @free_workers = Java::java.util.LinkedList.new
    @task_queue = Java::java.util.LinkedList.new

    pool.times do |i|
      worker_name = "#{name}_#{i}"
      # If any of the workers die, director should die too or we would have
      # inconsistent state.
      worker = Threading::Worker.new_link(current_actor, worker_name)
      entry = WorkerEntry.new(worker_name, worker)

      @workers[worker_name] = entry
      @free_workers << entry
    end
  end

  def inspect
    "<#{self.class} workers=#{@workers.size} enqueued=#{enqueued_tasks}>"
  end

  def to_s
    "director_#{@name}"
  end

  def enqueued_tasks
    @task_queue.size
  end

  def work(task)
    typesig binding, Threading::Director::Task

    debug "Got work: #{task}"
    entry = reserve_worker
    if entry.nil?
      debug "No free workers, enqueueing: #{task}"
      @task_queue << task
    else
      debug "Dispatching to #{entry.name}: #{task}"
      @worker_tasks[entry.name] = TaskInfo.new(task.short_description)
      entry.worker.work!(task)
    end

    report
  end

  def done(name)
    debug "*** #{name} is done working ***"

    entry = @workers[name]

    unless @task_queue.blank?
      task = @task_queue.remove_first
      debug "Taking task from queue: #{task}"
      @worker_tasks[entry.name] = TaskInfo.new(task.short_description)
      entry.worker.work!(task)
    else
      debug "Returning #{name} to pool."
      @worker_tasks.delete entry.name
      @free_workers << entry
    end

    report
  end

  def finished?
    @workers.size == @free_workers.size
  end

  private

  def report
    now = Time.now
    current = @worker_tasks.map do |name, task_info|
      "#{name} => #{task_info.description} (#{task_info.elapsed(now)}ms)"
    end.join(", ")

    info "free workers: #{@free_workers.size}, enqueued tasks: #{
      @task_queue.size}, current: {#{current}}"
  end

  def reserve_worker
    return if @free_workers.blank?
    @free_workers.remove_first
  end
end