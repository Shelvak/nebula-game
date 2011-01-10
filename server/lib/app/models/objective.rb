class Objective < ActiveRecord::Base
  belongs_to :quest
  # FK :dependent => :delete_all
  has_many :objective_progresses

  # Override this to provide calculation logic for initial value of 
  # objective progress. By default it just returns 0.
  def initial_completed(player_id); 0; end

  # Filter model list to reject models that don't meet our constraints.
  def filter(models)
    unless level.nil?
      models = models.reject { |model| model.level != level }
    end

    models
  end

  # {
  #   :id => Fixnum,
  #   :quest_id => Fixnum,
  #   :type => String (one of the Objective::* classes),
  #   :key => String (type related objective key, like "Unit::Trooper"),
  #   :level => Fixnum (level of key required to progress),
  #   :count => Fixnum (number of progressions required for objective),
  #   :npc => Boolean (should we do things with npc (only in some types)),
  #   :alliance => Boolean (can alliance help with this objective)
  # }
  def as_json(options=nil)
    attributes.symbolize_keys
  end

  class << self
    # Update objective progresses related to given models.
    def progress(models)
      # For caching friendly player ids.
      cache = {}

      # Iterate through all objective progresses and collect how much
      # we have completed them.
      all_progresses = {}
      models.group_to_hash { |model| model.class }.each do
        |klass, class_models|

        objectives = where(:key => resolve_key(klass)).all
        objectives.each do |objective|
          objective_models = objective.filter(class_models)

          beneficaries = count_benefits(objective_models)
          beneficaries.each do |player_id, count|
            progresses = objective_progresses(player_id, objective, cache)
            progresses.each do |progress|
              all_progresses[progress] = count
            end
          end
        end
      end

      # Actually increase _completed_ on them and save them. This is
      # separated from top loop because saving progress may complete quest
      # and newly started objectives get progressed in same run.
      #
      # This happens if:
      #
      # You have 2 quests:
      # Q1: have 1 Trooper
      # Q2: have 2 Troopers
      #
      # Q1 gets completed, Q2 gets it's #initial_completed set and THEN gets
      # progressed by .progress loop.
      transaction do
        all_progresses.each do |progress, count|
          progress.completed += count
          progress.save!
        end
      end
    end

    # Regress objective by given _models_ instead of progressing it.
    def regress(models)
      @regression = true
      ret = progress(models)
      @regression = false

      ret
    end

    def regression?; @regression; end

    def resolve_key(klass)
      klass.to_s
    end

    def count_benefits(models)
      benefits = models.grouped_counts { |model| model.player_id }

      # Subtract from counters if regression.
      benefits.each do |player_id, count|
        benefits[player_id] = count * -1
      end if regression?

      benefits
    end
    
    # Default implementation returns progresses that are bound to object
    # owner (or alliance if the objective is marked as alliance).
    # Override this to provide other means of who this objective
    # should benefit to.
    def objective_progresses(player_id, objective, cache)
      if objective.alliance?
        cache[player_id] = Player.find(player_id).friendly_ids \
          if cache[player_id].nil?
        player_ids = cache[player_id]
      else
        player_ids = player_id
      end
      
      objective.objective_progresses.where(:player_id => player_ids).all
    end
  end
end