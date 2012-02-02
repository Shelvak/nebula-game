class Director
  class WorkerEntry < Struct.new(:name, :worker); end

  include Log
  include Celluloid

  def initialize(pool=10)
    @name = "director"

    syncer = Syncer.new

    @workers = {}
    @free_workers = []
    pool.times do |i|
      name = :"worker_#{i}"
      worker = Worker.new(current_actor, syncer, name)
      entry = WorkerEntry.new(name, worker)

      @workers[name] = entry
      @free_workers << entry
    end

    @jobs = Hash.new(0)
    @pids = PidsTracker.new

    @sync_token = 0
  end

  def work(player_ids, message)
    #log "*** Got work for #{player_ids.inspect}! ***"
    worker = reserve_worker(player_ids)
    worker.work!(player_ids, message)
    #report
  end

  def done(name, player_ids)
    #log "*** #{name} is done working for #{player_ids.inspect} ***"
    #report

    #log "Processing."
    @pids.unregister_pids(player_ids, name)
    jobs_left = @jobs[name] -= 1
    @free_workers << @workers[name] if jobs_left == 0

    report
  end

  def report
    #log "Free: #{@free_workers.size}, @pids: #{@pids}, @jobs: #{@jobs.inspect}"
    log "Free: #{@free_workers.size}, @jobs: #{@jobs.inspect}"
  end

  def finished?
    @pids.empty?
  end

  private

  def reserve_worker(player_ids)
    currently_on = @pids.currently_working_on(player_ids).map do |name|
      @workers[name]
    end

    if currently_on.size == 0
      # No worker is working on any of the _player_ids_.
      entry = @free_workers.shift

      if entry.nil?
        log "No free workers left! Taking busy one."
        name, entry = @workers.first
      else
        log "Taking free worker."
      end
    else
      entry = currently_on[0]
      log "Taking already working worker #{entry.name}."

      rest = currently_on[1..-1]
      unless rest.size == 0
        # We need to ensure that other workers have finished working on
        # player_ids before this worker starts working on them, therefore
        # we must issue sync requests.
        @sync_token += 1
        names = rest.map { |e| e.name }.join(",")
        log "Syncing #{entry.name} with token #{@sync_token} to #{names} (#{
          rest.size})."
        entry.worker.request_sync!(@sync_token, rest.size)

        rest.each do |sync_entry|
          sync_entry.worker.sync!(@sync_token)
        end
      end
    end

    log "Reserved #{entry.name} for #{player_ids.inspect}."
    @pids.register_pids(player_ids, entry.name)
    @jobs[entry.name] += 1

    entry.worker
  end
end