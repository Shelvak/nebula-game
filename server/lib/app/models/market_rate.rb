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

    # Subtract _from_amount_ for resource pair from galaxy with ID _galaxy_id_
    # and set new average rate.
    #
    # - cancellation_shift (Float) - amount you need to shift average market
    # rate when cancelling.
    # - cancellation_amount (Fixnum) - #from_amount when you created the offer.
    # - cancellation_total_amount (Fixnum) - total amount of resource of
    # #from_kind in market, when offer was created.
    #
    def subtract(galaxy_id, from_kind, to_kind, from_amount,
        cancellation_shift, cancellation_amount, cancellation_total_amount)
      model = subtracted_model(galaxy_id, from_kind, to_kind, from_amount)

      # To prevent division by zero or negative numbers.
      market_amount_left = model.from_amount < 1 ? 1 : model.from_amount
      model.to_rate += cancellation_shift *
        # How much of your offer has left.
        (from_amount.to_f / cancellation_amount) *
        # How much market has shifted.
        (cancellation_total_amount.to_f / market_amount_left)
      model.save!

      model
    end

    # Subtract _from_amount_ for resource pair from galaxy with ID _galaxy_id_.
    def subtract_amount(galaxy_id, from_kind, to_kind, from_amount)
      model = subtracted_model(galaxy_id, from_kind, to_kind, from_amount)
      model.save!

      model
    end

    # Return average rate for resource pair for galaxy with ID _galaxy_id_.
    def average(galaxy_id, from_kind, to_kind)
      get(galaxy_id, from_kind, to_kind).to_rate
    end

    # Return lowest rate for resource pair for galaxy with ID _galaxy_id_.
    # Returns nil if no offers exist.
    def lowest(galaxy_id, from_kind, to_kind)
      rate = MarketOffer.select(:to_rate).where(
        :galaxy_id => galaxy_id, :from_kind => from_kind, :to_kind => to_kind
      ).order(:to_rate).c_select_value
      rate.is_a?(String) ? rate.to_f : rate
    end

    protected
    def subtracted_model(galaxy_id, from_kind, to_kind, from_amount)
      model = get(galaxy_id, from_kind, to_kind)
      raise ArgumentError.new("Cannot subtract more than we have from #{model
        }! Wanted to subtract #{from_amount}"
      ) if from_amount > model.from_amount

      model.from_amount -= from_amount
      model
    end
  end
end