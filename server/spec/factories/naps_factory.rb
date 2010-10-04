Factory.define :nap do |m|
  m.association :initiator, :factory => :alliance
  m.association :acceptor, :factory => :alliance
  m.status Nap::STATUS_ESTABLISHED
end