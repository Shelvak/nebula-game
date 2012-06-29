module PauseableActor
  def initialize(*args)
    @pause = false
    super(*args) if defined?(super)
  end

  def pause
    @pause = true
  end

  def resume
    signal :resume
  end

private

  def check_for_pause
    if @pause
      @pause = false
      wait :resume
    end
  end
end