class Director
  class WorkerEntry < Struct.new(:name, :worker); end

  include NamedLogMessages
  include Celluloid

  def initialize(name, pool)
    @name = name

    syncer = Syncer.new(name)

    @workers = {}
    @free_workers = []
    pool.times do |i|
      worker_name = "#{name}_#{i}"
      worker = Worker.new(current_actor, syncer, worker_name)
      entry = WorkerEntry.new(worker_name, worker)

      @workers[worker_name] = entry
      @free_workers << entry
    end

    @jobs = Hash.new(0)
    @ids_tracker = IdsTracker.new

    @sync_token = 0
  end

  def to_s
    "Director-#{@name}"
  end

  def work(ids, klass, method, *args)
    typesig binding, Array, Class, Symbol, Array

    info "Got work for #{ids.inspect}: #{klass}.#{method}#{args.inspect}"
    worker = reserve_worker(ids)
    info "Reserved #{entry.name} for #{ids.inspect}."
    worker.work!(ids, klass, method, *args)
  end

  def done(name, ids)
    info "*** #{name} is done working for #{ids.inspect} ***"

    @ids_tracker.unregister_ids(ids, name)
    jobs_left = @jobs[name] -= 1
    @free_workers << @workers[name] if jobs_left == 0
  end

  def finished?
    @ids_tracker.empty?
  end

  private

  def reserve_worker(ids)
    currently_on = @ids_tracker.currently_working_on(ids).map do |name|
      @workers[name]
    end

    if currently_on.size == 0
      # No worker is working on any of the _player_ids_.
      entry = @free_workers.shift

      if entry.nil?
        info "No free workers left! Taking busy one."
        name, entry = @workers.first
      else
        info "Taking free worker."
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