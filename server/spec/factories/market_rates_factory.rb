Factory.define :market_rate do |m|
  m.association :galaxy
  m.from_kind MarketOffer::KIND_METAL
  m.to_kind MarketOffer::KIND_ENERGY
  m.to_rate 0.235
  m.from_amount 12312
end