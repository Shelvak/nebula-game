class FixFkUpdates < ActiveRecord::Migration
  # Readd FK to ensure it has ON UPDATE.
  def self.readd(src, dst, opts={})
    opts[:target_key] ||= :"#{src.to_s.singularize}_id"

    remove_fk dst, opts[:target_key]
    add_fk src, dst, opts
  end

  def self.up
    readd(:galaxies, :alliances)
    readd(:ss_objects, :buildings, {:target_key => :planet_id})
    readd(:buildings, :construction_queue_entries,
      {:target_key => :constructor_id})
    readd(:ss_objects, :folliages, {:target_key => :planet_id})
    readd(:alliances, :naps, {:target_key => :initiator_id})
    readd(:alliances, :naps, {:target_key => :acceptor_id})
    readd(:players, :notifications)
    readd(:quests, :objectives)
    readd(:objectives, :objective_progresses)
    readd(:players, :objective_progresses)
    readd(:galaxies, :players)
    readd(:alliances, :players, {:on_delete => "SET NULL"})
    readd(:quests, :quests, {:target_key => :parent_id})
    readd(:quests, :quest_progresses)
    readd(:players, :quest_progresses)
    readd(:players, :routes)
    readd(:routes, :route_hops)
    readd(:galaxies, :solar_systems)
    readd(:solar_systems, :ss_objects)
    readd(:players, :ss_objects, {:on_delete => "SET NULL"})
    readd(:players, :technologies)
    readd(:ss_objects, :tiles, {:target_key => :planet_id})
    readd(:players, :units, {:on_delete => "SET NULL"})
    readd(:routes, :units, {:on_delete => "SET NULL"})
    readd(:galaxies, :units)
  end

  def self.down
    raise IrreversibleMigration
  end
end