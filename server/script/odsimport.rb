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
  [/time$/, ".upgrade_time"],
  [/metal rate$/, ".metal.generate"],
  [/metal cost$/, ".metal.cost"],
  [/metal storage$/, ".metal.store"],
  [/metal starting$/, ".metal.starting"],
  [/energy rate$/, ".energy.generate"],
  [/energy usage$/, ".energy.use"],
  [/energy cost$/, ".energy.cost"],
  [/energy storage$/, ".energy.store"],
  [/energy starting$/, ".energy.starting"],
  [/zetium rate$/, ".zetium.generate"],
  [/zetium cost$/, ".zetium.cost"],
  [/zetium storage$/, ".zetium.store"],
  [/zetium starting$/, ".zetium.starting"],
  [/radar strength$/, ".radar.strength"],
  [/construction mod$/, ".mod.construction"],
  [/scientists min$/, ".scientists.min"],
  [/scientists$/, ".scientists"],
  [/war points$/, ".war_points"],
  [/population$/, ".population"],
  [/max players$/, ".max_players"],
  [/fee$/, ".fee"],
  [/teleported volume$/, ".teleported_volume"],
  [/time decrease$/, ".mod.movement_time_decrease"],
  [/armor mod$/, ".mod.armor"],
  [/damage mod$/, ".mod.damage"],
  [/storage mod$/, ".mod.storage"],
  [/M gen mod$/, ".mod.metal.generate"],
  [/M store mod$/, ".mod.metal.store"],
  [/E gen mod$/, ".mod.energy.generate"],
  [/E store mod$/, ".mod.energy.store"],
  [/Z gen mod$/, ".mod.zetium.generate"],
  [/Z store mod$/, ".mod.zetium.store"],
  [/healing time mod$/, ".healing.time.mod"],
  [/healing cost mod$/, ".healing.cost.mod"],
]

MAIN_TITLE_ALIASES = [
  [/Mex t1/, "metal_extractor"],
  [/Mex t2/, "metal_extractor_t2"],
  [/Zex t1/, "zetium_extractor"],
  [/Zex t2/, "zetium_extractor_t2"],
  ["SCond. Tech.", "superconductor_technology"],
  ["Powd. Zet.", "powdered_zetium"],
  ["HV Charges", "high_velocity_charges"],
]

def underscore(original)
  string = original.dup.to_s
  string.tr!(' ', '_')
  string.gsub!(/::/, '/')
  string.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
  string.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
  string.tr!("-", "_")
  string.downcase!
  string
end

def sf(a, b, b1, c, c1, c2, d, d1, level_mult, mult)
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

  return 0.0 if params.size == 0

  formula = mult == 1 ? params : "(#{params}) * #{mult}"
  formula = level_mult == "level" ? "(#{formula}) * level" : formula
  if formula.match(/[a-z]/i)
    formula
  else
    eval(formula)
  end
end

def read_value(sheet, row, col, default=nil)
  # Change , to . to get floats.
  value = sheet[row][col]
  value == "" ? default : value
end

def read_main_definition(sections, row, sheet)
  txt_title = read_value(sheet, row, 0)
  txt_prop = read_value(sheet, row, 1)
  a = read_value(sheet, row, 2, 0).to_f
  b = read_value(sheet, row, 3, 0).to_f
  b1 = read_value(sheet, row, 4, 0).to_f
  c = read_value(sheet, row, 5, 0).to_f
  c1 = read_value(sheet, row, 6, 0).to_f
  c2 = read_value(sheet, row, 7, 0).to_f
  d = read_value(sheet, row, 8, 0).to_f
  d1 = read_value(sheet, row, 9, 0).to_f
  max_lvl = read_value(sheet, row, 10, 0).to_i
  level_mult = read_value(sheet, row, 11, 0)
  mult = read_value(sheet, row, 12, 1).to_f

  prefix = txt_title[0].chr
  txt_title = txt_title[2..-1]
  case prefix
  when "B"
    section = "buildings"
  when "T"
    section = "technologies"
  when "U"
    section = "units"
  end

  property = txt_prop.dup
  name = txt_title.dup
  MAIN_TITLE_ALIASES.each { |from, to| name.sub!(from, to) }
  
  name = underscore(name)

  MAIN_TITLE_PROPS.each { |from, to| property.sub!(from, to) }
  config_name = "#{name}#{property}"
  max_lvl_prop = "#{name}.max_level"

  if txt_title == name || txt_prop == property
    puts "Unknown title '#{txt_title} #{txt_prop}'!"
    return nil
  end

  sections[section] ||= {}
  sections[section][config_name] = sf(a, b, b1, c, c1, c2, d, d1, level_mult, mult)
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
begin
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
rescue Exception => e
  puts "Reading #{sheet[row].inspect} (row #{row}) failed!"
  raise e
end

def zero?(val)
  val.nil? || val.strip == "" || val.to_i == 0
end

def add_guns(sections, section, config_name, gun_index, dmg_per_gun,
    gun_cooldown, gun_reach, gun_count, dmg_type, dmg_mod)
  sections[section]["#{config_name}.guns"] ||= []
  return if zero?(gun_count) || dmg_type.strip == ""

  guns = sections[section]["#{config_name}.guns"]
  gun_count.to_i.times do
    dpt = dmg_per_gun.to_i * gun_cooldown.to_i
    f_dmg_mod = dmg_mod.to_f / 100
    guns.push(
      "dpt" => zero?(dmg_mod) \
        ? dpt.to_i : "#{dpt} + #{dpt} * #{f_dmg_mod} * (level-1)",
      "period" => gun_cooldown.to_i,
      "damage" => dmg_type.downcase.to_sym,
      "reach" => gun_reach.downcase.to_sym
    )
  end
end

def read_unit_definition(row, sheet, sections)
  name, tier, hp, initiative, dmg_per_gun, gun_cooldown, gun_reach,
    gun_count, dmg_type, build_time,
    xp_mod, xp_needed, armor_type, dmg_mod, armor_mod, max_lvl, base_cost,
    metal, energy, zetium, population, volume, storage,
    ss_hop_time, galaxy_hop_time = sheet[row]

  metal = metal.to_f
  energy = energy.to_f
  zetium = zetium.to_f

  case tier
  when "Towers"
    metal = "#{metal} * level"
    energy = "#{energy} * level"
    zetium = "#{zetium} * level"
    ["buildings"]
  else
    ["units"]
  end.each do |section|
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
      attrs.push ["#{xp_needed.to_i} * (level-1)", "xp_needed"]
      attrs.push [armor_type.downcase.to_sym, "armor"] unless armor_type == ""
      attrs.push ["#{armor_mod.to_i} * (level-1)", "armor_mod"]
      attrs.push [max_lvl.to_i, "max_level"] unless zero?(max_lvl)
      attrs.push [metal, "metal.cost"]
      attrs.push [energy, "energy.cost"]
      attrs.push [zetium, "zetium.cost"]
      attrs.push [population.to_i, "population"] unless zero?(population) ||
        section == "buildings"
      attrs.push [volume.to_i, "volume"] unless zero?(volume) ||
        section == "buildings"
      attrs.push [
        "#{storage} + #{storage} * #{STORAGE_GAINED_PER_UNIT_LVL} * (level-1)",
        "storage"
      ] unless zero?(storage) || section == "buildings"
      attrs.push [(ss_hop_time.to_f * 60).to_i, "move.solar_system.hop_time"] \
        unless zero?(ss_hop_time)
      attrs.push [(galaxy_hop_time.to_f * 60).to_i, "move.galaxy.hop_time"] \
        unless zero?(galaxy_hop_time)
      attrs.each do |value, attr_name|
        sections[section]["#{config_name}.#{attr_name}"] = value
      end

      dmg_type = "" if tier == "MTow" && section == "units"
      if dmg_type.strip == ""
        sections[section]["#{config_name}.guns"] = []
      else
        add_guns(sections, section, config_name, 0, dmg_per_gun,
          gun_cooldown, gun_reach, gun_count, dmg_type, dmg_mod)
      end
    end
  end
end

# Read variables sheet
sheet = read_txt(File.dirname(__FILE__) + '/odsimport/variables.txt')
sections["units"] ||= {}
sections["units"]["transportation.volume.metal"] = sheet[11][1].to_f
sections["units"]["transportation.volume.energy"] = sheet[12][1].to_f
sections["units"]["transportation.volume.zetium"] = sheet[13][1].to_f
sections["units"]["galaxy_ss_hop_ratio"] = sheet[19][1].to_f
STORAGE_GAINED_PER_UNIT_LVL = sheet[27][1].to_f


# Read units sheet.
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

# Read raiders sheet.
sheet = read_txt(File.dirname(__FILE__) + '/odsimport/raiders.txt')
row = 0
begin
  until sheet[row].nil?
    title = sheet[row][0]
    if ! title.nil? && title.match(/\D/)
      key = case title
      when "Planet raiders" then "raiders.planet"
      when "Pulsar raiders" then "raiders.battleground"
      when "Apocalypse raiders" then "raiders.apocalypse"
      else raise "Unknown raiders title: #{title}"
      end

      row += 2
      sheet[row].each_with_index do |type, col|
        unless type == ""
          arg_reductor = sheet[row + 1][col]
          chance_reductor = sheet[row + 1][col + 2]
          from_range_pow_coef = sheet[row + 2][col]
          from_range_mult_coef = sheet[row + 2][col + 1]
          to_range_pow_coef = sheet[row + 3][col]
          to_range_mult_coef = sheet[row + 3][col + 1]
          chance_initial = sheet[row + 4][col]
          chance_arg_mult = sheet[row + 4][col + 1]

          sections["raiding"] ||= {}
          sections["raiding"][key] ||= {}
          sections["raiding"][key][type] = [
            "(arg - #{arg_reductor}) ** #{from_range_pow_coef} * #{
              from_range_mult_coef}",
            "(arg - #{arg_reductor}) ** #{to_range_pow_coef} * #{
              to_range_mult_coef}",
            "#{chance_initial} + (arg - #{chance_reductor}) * #{
              chance_arg_mult}"
          ]
         end
      end
    end

    row += 1
  end
rescue Exception => e
  puts "Reading #{sheet[row].inspect} (row #{row}) failed!"
  raise e
end

IGNORED_KEYS = [
  /^buildings\.(.+?)\.(armor|xp_needed)$/,
  /^technologies\.mdh\.mod\.(armor|damage)$/
]


#private void replaceKey(String key, String value) {
#  String metadata = metadataEdit.getText();
#  Pattern regexp = Pattern.compile("",
#    Pattern.DOTALL | Pattern.MULTILINE);
#  Matcher matcher = regexp.matcher(metadata);
#  if (matcher.find()) {
#    String lastChar = matcher.group(1);
#    metadata = matcher.replaceFirst(value + lastChar);
#  }
#  else {
#    metadata += "\n" + value;
#  }
#  metadataEdit.setText(metadata);
#}

def sub_key!(data, key, value)
  re = /^#{key}:.+?(\s*(^\S|\Z))/m
  data.gsub!(re, "#{key}: #{value} # autogenerated by odsimport\\1")
end

# Pretty JSON.
def p_json(item)
  item.to_json.gsub(":", ": ").gsub(",", ", ")
end

sections.each do |section, values|
  filepath = File.expand_path(
    File.dirname(__FILE__) +
    "/../config/sets/default/sections/#{section}.yml"
  )
  data = File.read(filepath)
  values.each do |key, value|
    full_name = "#{section}.#{key}"
    next unless IGNORED_KEYS.find { |match| full_name =~ match }.nil?

    if data =~ /^#{key}:/
      case value
      when Array
        value = \
          value.size == 0 \
          ? "[]" \
          : "\n" + value.map { |i| "  - #{p_json(i)}" }.join("\n")
      when Hash
        value = \
          value.size == 0 \
          ? "{}" \
          : "\n" + value.map { |k, v| "  #{k}: #{p_json(v)}" }.join("\n")
      else
        if key =~ /
          \.(
            (solar_system|galaxy)\.hop_time|
            upgrade_time|
            healing\.time\.mod
          )
        $/x
          value = "(#{value}) / speed"
        elsif key =~ /(generate|use)$/ && ! key.include?(".mod.")
          value = "(#{value}) * speed"
        end
      end

      sub_key!(data, key, value)
    else
      puts "#{key}: 1 # missing key! (#{section})"
    end
  end

  File.open(filepath, "wb") do |f|
    f.write data.gsub("\r\n", "\n")
  end
  puts "#{filepath} written."
end
