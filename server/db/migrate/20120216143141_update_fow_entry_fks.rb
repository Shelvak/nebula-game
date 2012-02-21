class UpdateFowEntryFks < ActiveRecord::Migration
  def self.up
    # Update FKs to have on update statements.

    remove_fk :fow_ss_entries, :solar_system_id
    add_fk    :solar_systems,  :fow_ss_entries

    remove_fk :fow_ss_entries, :player_id
    add_fk    :players,        :fow_ss_entries

    remove_fk :fow_ss_entries, :alliance_id
    add_fk    :alliances,      :fow_ss_entries

    remove_fk :fow_galaxy_entries, :galaxy_id
    add_fk    :galaxies,           :fow_galaxy_entries

    # These even didn't exist...
    add_fk    :players,            :fow_galaxy_entries
    add_fk    :alliances,          :fow_galaxy_entries
  end

  def self.down
    raise IrreversibleMigration
  end
end