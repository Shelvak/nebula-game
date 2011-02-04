def create_alliance(player)
  if player.alliance.nil?
    player.alliance = Factory.create(:alliance)
    player.save!
  end

  ally = Factory.create(:player, :alliance => player.alliance)
  [ally, player.alliance]
end

def create_nap(player)
  if player.alliance.nil?
    player.alliance = Factory.create(:alliance)
    player.save!
  end

  nap_alliance = Factory.create(:alliance)
  Factory.create(:nap, :initiator => player.alliance,
    :acceptor => nap_alliance)

  nap = Factory.create(:player, :alliance => nap_alliance)

  [nap, player.alliance, nap_alliance]
end