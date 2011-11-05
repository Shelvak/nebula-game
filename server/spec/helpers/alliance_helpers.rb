def create_alliance(options={})
  alliance = Factory.create(:alliance, options)
  alliance.owner.alliance = alliance
  alliance.owner.save!
  alliance
end