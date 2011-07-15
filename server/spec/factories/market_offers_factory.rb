Factory.define :market_offer do |m|
  m.association :planet, :factory => :planet_with_player
  m.from_kind MarketOffer::KIND_METAL
  m.from_amount 9000
  m.to_kind MarketOffer::KIND_ZETIUM
  m.to_rate 0.5
end