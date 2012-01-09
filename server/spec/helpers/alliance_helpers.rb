def create_alliance(options={})
  alliance = Factory.create(:alliance, options)
  owner = alliance.owner
  owner.alliance = alliance
  owner.save!
  alliance
end