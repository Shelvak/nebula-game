#!/usr/bin/env ruby

require 'rubygems'
require 'json'
sections = {}

def read_txt(file)
  File.read(file).gsub(",", ".").split("\n").map do |row|
    row.split("\t")
  end
end

MAIN_TITLE_PROPS = [
  [/ time$/, ".upgrade_time"],
  [/ metal rate$/, ".metal.generate"],
  [/ metal cost$/, ".metal.cost"],
  [/ metal storage$/, ".metal.store"],
  [/ metal starting$/, ".metal.starting"],
  [/ energy rate$/, ".energy.generate"],
  [/ energy usage$/, ".energy.use"],
  [/ energy cost$/, ".energy.cost"],
  [/ energy storage$/, ".energy.store"],
  [/ energy starting$/, ".energy.starting"],
  [/ zetium rate$/, ".zetium.generate"],
  [/ zetium cost$/, ".zetium.cost"],
  [/ zetium storage$/, ".zetium.store"],
  [/ zetium starting$/, ".zetium.starting"],
  [/ radar strength$/, ".radar.strength"],
  [/ construction mod$/, ".mod.construction"],
  [/ scientists min$/, ".scientists.min"],
  [/ scientists$/, ".scientists"],
  [/ unload per tick/, ".unload_per_tick"],
  [/ armor mod/, ".mod.armor"],
  [/ damage mod/, ".mod.damage"],
]

MAIN_TITLE_ALIASES = [
  [/Mex t1/, "metal_extractor"],
  [/Mex t2/, "metal_extractor_t2"],
  [/Collector t1/, "wind_panel"],
  [/Collector t2/, "solar_plant"],
  [/Collector t3/, "geothermal_plant"],
  [/Zex t1/, "zetium_extractor"],
  [/Zex t2/, "zetium_extractor_t2"],
  ["SCond. Tech.", "superconductor_technology"],
  ["Powd. Zet.", "powdered_zetium"],
  ["HV Charges", "high_velocity_charges"],
]

def underscore(string)
  string.downcase.gsub(' ', '_')
end

def sf(a, b, b1, c, c1, c2, d, d1, mult)
  # b * (level + b1)
  linear = (b == 1 ? "" : "#{b} * ") +
    (b1 == 0 ? "level" : "(level + #{b1})")
  # c2 * (level + c1) ** c
  pow = (c2 == 1 ? "" : "#{c2} * ") +
    (c1 == 0 ? "level" : "(level + #{c1})") +
    (c == 1 ? "" : " ** #{c}")
  # d ** (level + d1)
  exp = d == 1 ? "1" : \
    "#{d} ** " + (d1 == 0 ? "level" : "(level + #{d1})")

  params = []
  params.push a if a != 0
  params.push linear if b != 0
  params.push pow if c2 != 0
  params.push exp if d != 0
  params = params.join(" + ")

  formula = mult == 1 ? params : "(#{params}) * #{mult}"
  if formula.match(/[a-z]/i)
    formula
  else
    eval formula
  end
end

def read_value(sheet, row, col, default=nil)
  # Change , to . to get floats.
  value = sheet[row][col]
  value == "" ? default : value
end

def read_main_definition(sections, row, sheet)
  title = read_value(sheet, row, 0)
  a = read_value(sheet, row, 1, 0).to_f
  b = read_value(sheet, row, 2, 0).to_f
  b1 = read_value(sheet, row, 3, 0).to_f
  c = read_value(sheet, row, 4, 0).to_f
  c1 = read_value(sheet, row, 5, 0).to_f
  c2 = read_value(sheet, row, 6, 0).to_f
  d = read_value(sheet, row, 7, 0).to_f
  d1 = read_value(sheet, row, 8, 0).to_f
  max_lvl = read_value(sheet, row, 9, 0).to_i
  mult = read_value(sheet, row, 11, 1).to_f

  prefix = title[0].chr
  title = title[2..-1]
  case prefix
  when "B"
    section = "buildings"
  when "T"
    section = "technologies"
  when "U"
    section = "units"
  end

  property = title.dup
  name = title.dup
  MAIN_TITLE_PROPS.each { |from, to| name.sub!(from, '') }
  property.sub!(name, '')
  MAIN_TITLE_ALIASES.each { |from, to| name.sub!(from, to) }
  
  name = underscore(name)

  MAIN_TITLE_PROPS.each { |from, to| property.sub!(from, to) }
  config_name = "#{name}#{property}"
  max_lvl_prop = "#{name}.max_level"

  if title == config_name
    puts "Unknown title '#{title}'!"
    return nil
  end

  sections[section] ||= {}
  sections[section][config_name] = sf(a, b, b1, c, c1, c2, d, d1, mult)
  sections[section][max_lvl_prop] ||= max_lvl

  puts (
    "Strange. #{section}.#{max_lvl_prop} max lvl was set to %d, but " +
    "#{section}.#{config_name} is trying to set it to %d!"
  ) % [sections[section][max_lvl_prop], max_lvl] \
    if max_lvl != 0 && sections[section][max_lvl_prop] != max_lvl

  true
end

# Read from main sheet
sheet = read_txt(File.dirname(__FILE__) + '/odsimport/main.txt')
finished = false
row = 1
until finished
  title = sheet[row][0]
  unless title.nil?
    if title == "table_end"
      finished = true
    else
      read_main_definition(sections, row, sheet)
    end
  end

  row += 1
end

def zero?(val)
  val.nil? || val.strip == "" || val.to_i == 0
end

def add_guns(sections, section, config_name, gun_index, dmg_per_gun,
    gun_cooldown, gun_reach, gun_count, dmg_type, dmg_mod)
  sections[section]["#{config_name}.guns"] ||= []
  return if zero?(gun_count) || dmg_type.strip == ""

  guns = sections[section]["#{config_name}.guns"]
  gun_count.to_i.times do |index|
    index += gun_index
    dpt = dmg_per_gun.to_i * gun_cooldown.to_i
    f_dmg_mod = dmg_mod.to_f / 100
    guns[index] = {
      "dpt" => zero?(dmg_mod) \
        ? dpt.to_i : "#{dpt} + #{dpt} * #{f_dmg_mod} * (level-1)",
      "period" => gun_cooldown.to_i,
      "damage" => dmg_type.downcase.to_sym,
      "reach" => gun_reach.downcase.to_sym
    }
  end
end

def read_unit_definition(row, sheet, sections)
  name, tier, hp, initiative, dmg_per_gun, gun_cooldown, gun_reach,
    gun_count, dmg_type, build_time,
    xp_mod, xp_needed, armor_type, dmg_mod, armor_mod, base_cost,
    metal, energy, zetium, volume, storage = sheet[row]

  section = tier == "Towers" ? "buildings" : "units"
  sections[section] ||= {}

  if match = name.match(/Gun(\d)/)
    gun_index = match[1].to_i - 1
    config_name = underscore(name.sub(/ Gun\d/, ''))

    add_guns(sections, section, config_name, gun_index, dmg_per_gun,
      gun_cooldown, gun_reach, gun_count, dmg_type, dmg_mod)
  else
    config_name = underscore(name)

    attrs = []
    attrs.push [hp.to_i, "hp"]
    attrs.push [initiative.to_i, "initiative"]
    attrs.push [build_time.to_i * 60, "upgrade_time"]
    attrs.push [xp_mod.to_f, "xp_modifier"]
    attrs.push [xp_needed.to_i, "xp_needed"]
    attrs.push [armor_type.downcase.to_sym, "armor"] unless armor_type == ""
    attrs.push [armor_mod.to_i, "armor_mod"]
    attrs.push [metal.to_f, "metal.cost"]
    attrs.push [energy.to_f, "energy.cost"]
    attrs.push [zetium.to_f, "zetium.cost"]
    attrs.push [volume.to_i, "volume"] unless zero?(volume)
    attrs.push [storage.to_i, "storage"] unless zero?(storage)
    attrs.each do |value, name|
      sections[section]["#{config_name}.#{name}"] = value
    end

    add_guns(sections, section, config_name, 0, dmg_per_gun,
      gun_cooldown, gun_reach, gun_count, dmg_type, dmg_mod)
  end
end

sheet = read_txt(File.dirname(__FILE__) + '/odsimport/units.txt')
mode = :unknown
row = 0
until mode == :finished
  title = sheet[row][0]
  unless title.nil? || title == ""
    case title
    when "damages_start"
      mode = :damages
      row += 1 # Skip header
    when "units_start"
      mode = :units
      row += 1 # Skip header
    when "units_end"
      mode = :finished
    else
      case mode
      when :damages
        damage, armor, coef = sheet[row]
        name = "#{underscore(damage)}.#{underscore(armor)}"
        sections["damages"] ||= {}
        sections["damages"][name] = coef.to_f
      when :units
        read_unit_definition(row, sheet, sections)
      end
    end
  end

  row += 1
end

# Read variables sheet
sheet = read_txt(File.dirname(__FILE__) + '/odsimport/variables.txt')
sections["units"] ||= {}
sections["units"]["transportation.volume.metal"] = "resource / #{
  sheet[10][1].to_f}"
sections["units"]["transportation.volume.energy"] = "resource / #{
  sheet[11][1].to_f}"
sections["units"]["transportation.volume.zetium"] = "resource / #{
  sheet[12][1].to_f}"

IGNORED_KEYS = [
  /^buildings\.(.+?)\.(armor|armor_mod|xp_needed)$/,
  /^units\.(gnat|glancer|gnawer|spudder|dirac|thor|demosis)\.upgrade_time$/
]

sections.each do |section, values|
  filepath = File.expand_path(
    File.dirname(__FILE__) +
    "/../config/sets/default/sections/#{section}.yml"
  )
  data = File.read(filepath)
  values.each do |key, value|
    full_name = "#{section}.#{key}"
    catch :next do
      IGNORED_KEYS.each do |match|
        throw :next if full_name =~ match
      end

      if data =~ /^#{key}:/
        if value.is_a?(Array) || value.is_a?(Hash)
          value = value.to_json.gsub(":", ": ").gsub(",", ", ")
        end

        data.gsub!(/#{key}:(.*)$/,
          "#{key}: #{value} # autogenerated by odsimport")
      else
        puts "#{key}: 1 # missing key!"
      end
    end
  end

  File.open(filepath, "w") do |f|
    f.write data
  end
  puts "#{filepath} written."
end