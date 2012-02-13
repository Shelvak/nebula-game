class Threading::Director
  include NamedLogMessages
  include Celluloid

  def initialize(name, pool)
    @name = name

    # Link to syncer, because if syncer dies then whole tracking goes down.
    syncer = Threading::Syncer.new_link(name)

    @workers = {}
    @free_workers = []
    pool.times do |i|
      worker_name = "#{name}_#{i}"
      # If any of the workers die, director should die too or we would have
      # inconsistent state.
      worker = Threading::Worker.new_link(current_actor, syncer, worker_name)
      entry = WorkerEntry.new(worker_name, worker)

      @workers[worker_name] = entry
      @free_workers << entry
    end

    @jobs = Hash.new(0)
    @ids_tracker = IdsTracker.new

    @sync_token = 0
  end

  def to_s
    "director-#{@name}"
  end

  def work(ids, task)
    typesig binding, Array, Threading::Director::Task

    info "Got work for #{ids.inspect}: #{task}"
    worker = reserve_worker(ids)
    worker.work!(ids, task)

    report
  end

  def done(name, ids)
    info "*** #{name} is done working for #{ids.inspect} ***"

    @ids_tracker.unregister_ids(ids, name)
    jobs_left = @jobs[name] -= 1
    @free_workers << @workers[name] if jobs_left == 0

    report
  end

  def finished?
    @ids_tracker.empty?
  end

  private

  def report
    info "free workers: #{@free_workers.size} jobs: #{@jobs.inspect}"
  end

  def reserve_worker(ids)
    currently_on = @ids_tracker.currently_working_on(ids).map do |name|
      @workers[name]
    end

    if currently_on.size == 0
      # No worker is working on any of the _player_ids_.
      entry = @free_workers.shift

      if entry.nil?
        name, entry = @workers.first
        info "No free workers left! Taking busy worker: #{name}."
      else
        info "Taking free worker #{entry.name}."
      end
    else
      entry = currently_on[0]
      info "Taking already working worker #{entry.name}."

      rest = currently_on[1..-1]
      unless rest.size == 0
        # We need to ensure that other workers have finished working on
        # player_ids before this worker starts working on them, therefore
        # we must issue sync requests.
        @sync_token += 1
        names = rest.map { |e| e.name }.join(",")
        info "Syncing #{entry.name} with token #{@sync_token} to #{names} (#{
          rest.size} workers)."
        entry.worker.request_sync!(@sync_token, rest.size)

        rest.each do |sync_entry|
          sync_entry.worker.sync!(@sync_token)
        end
      end
    end

    @ids_tracker.register_ids(ids, entry.name)
    @jobs[entry.name] += 1

    entry.worker
  end
end