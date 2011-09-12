# Stores current market rate for resource pair in given galaxy.
class MarketRate < ActiveRecord::Base
  belongs_to :galaxy

  def to_s
    "<MarketRate(#{id} in galaxy #{galaxy_id}): #{from_kind} -> #{to_kind
      }: #{from_amount} x #{to_rate}>"
  end

  class << self
    # Returns +MarketRate+ for galaxy _galaxy_id_ and resource pair.
    #
    # Creates from seed values if it does not exist.
    def get(galaxy_id, from_kind, to_kind)
      model = where(:galaxy_id => galaxy_id, :from_kind => from_kind,
                    :to_kind => to_kind).first
      if model.nil?
        seed_amount, seed_rate = Cfg.market_seed(from_kind, to_kind)
        model = new(:galaxy_id => galaxy_id, :from_kind => from_kind,
                    :to_kind => to_kind, :from_amount => seed_amount,
                    :to_rate => seed_rate)
        model.save!
      end

      model
    end

    # Add _from_amount_ for resource pair to galaxy with ID _galaxy_id_ and
    # recalculate new average rate.
    def add(galaxy_id, from_kind, to_kind, from_amount, to_rate)
      model = get(galaxy_id, from_kind, to_kind)
      model.to_rate =
        (model.from_amount * model.to_rate.to_f + from_amount * to_rate.to_f) /
        (model.from_amount + from_amount)
      model.from_amount += from_amount
      model.save!

      model
    end

    # Subtract _from_amount_ for resource pair from galaxy with ID _galaxy_id_.
    def subtract(galaxy_id, from_kind, to_kind, from_amount)
      model = get(galaxy_id, from_kind, to_kind)
      raise ArgumentError.new("Cannot subtract more than we have from #{model
        }! Wanted to subtract #{from_amount}"
      ) if from_amount > model.from_amount

      model.from_amount -= from_amount
      model.save!

      model
    end

    # Return average rate for resource pair for galaxy with ID _galaxy_id_.
    def average(galaxy_id, from_kind, to_kind)
      get(galaxy_id, from_kind, to_kind).to_rate
    end
  end
end