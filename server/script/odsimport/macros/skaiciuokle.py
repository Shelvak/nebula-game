# Python macros for odsimport.ods.
#
# For this to work, it needs to be in script path.
#
# Linux:
# $ mkdir -p ~/.libreoffice/3/user/Scripts/python/
# $ ln -s path/to/skaiciuokle.py ~/.libreoffice/3/user/Scripts/python/
#
# While developing, you need to update symlink timestamp for libreoffice to
# reload the file:
# $ while true; do sleep 1; touch -h skaiciuokle.py; echo -n "."; done
#

import math

def log(name, value):
  file = open('/home/arturas/pymacro.log', 'a')
  file.write(name + ": " + str(value) + "\n")
  file.close()

empty_row = (tuple(),)

### unit/base technology multipliers ###

unit_tech_start_multiplier = lambda npc: 12 if npc else 4
unit_tech_end_multiplier = lambda npc: 180 if npc else 60

### Attack modifier division ###

kind_proportion = lambda mod: 0.35 * mod # For space/ground technologies
base_proportion = lambda mod: 0.2 * mod # For unit base technologies
specialized_proportion = lambda mod: 0.45 * mod # For unit specialization

### Specialization formulas ###

# base is full attack modifier
# coef is critical/absorption damage multiplier
spec_damage = ("Damage", lambda base, coef: base)
spec_armor = ("Armor", lambda base, coef: 1 - 1 / (1 + base))
spec_critical = ("Critical", lambda base, coef: base / (coef - 1))
spec_absorption = (
  "Absorption", lambda base, coef: (1 / (1 + base) - 1) / (1 / coef - 1)
)
# 140% attack maps to 400% speed.
spec_speed = ("Speed", lambda base, coef: base / 0.35)
# 140% attack maps to 119% storage
spec_storage = ("Storage", lambda base, coef: base * 0.85)

ground_specs = (spec_damage, spec_armor, spec_critical, spec_absorption)
space_specs = ground_specs + (spec_speed,)
# Technologies that don't contain any specializations.
no_spec_names = (
  "T Jumper", "T MDH",
  "T Mobile Vulcan", "T Mobile Screamer", "T Mobile Screamer"
)

def contains(list, value):
  try:
      list.index(value)
      return True
  except ValueError:
      return False

def get_specs(name, is_space):
  if name == "T Mule":
    return (spec_armor, spec_absorption, spec_speed, spec_storage)
  elif name == "T Rhyno":
    return space_specs + (spec_storage, )
  elif contains(no_spec_names, name):
    return tuple()
  elif is_space:
    return space_specs
  else:
    return ground_specs

def max_lvl_for_unit_tech(name, unlocker):
  if contains(no_spec_names, name):
    return 1
  elif unlocker:
    return 10
  else:
    return 9

### Time modifiers ###

def mins2sec(count):
  """Convert minutes to seconds."""
  return count * 60

def hrs2sec(count):
  """Convert hours to seconds."""
  return mins2sec(count) * 60

def days2sec(count):
  """Convert days to seconds."""
  return hrs2sec(count) * 24

def wks2sec(count):
  """Convert weeks to seconds."""
  return days2sec(count) * 7

def months2sec(count):
  """Convert months to seconds (month has 30 days)."""
  return days2sec(count) * 30

### Converters ###

def c_int(value):
  return 0 if value == "" else int(value)

def c_float(value):
  return 0 if value == "" else float(value)

def volume_coefs_expand(coefs):
  if isinstance(coefs, tuple) and len(coefs) == 3 and \
      isinstance(coefs[0], tuple):
    # Convert volume_coefs if they come from spreadsheet.
    return (coefs[0][0], coefs[1][0], coefs[2][0])
  else:
    return coefs

### Superformula ###

def sf_lin(level, b, b1):
  """Linear part of superformula."""
  level, b, b1 = c_int(level), c_float(b), c_float(b1)
  return b * (level + b1)

def sf_pow(level, c, c1, c2):
  """Power part of superformula."""
  level, c, c1, c2 = c_int(level), c_float(c), c_float(c1), c_float(c2)
  return c2 * (level + c1) ** c

def sf_exp(level, d, d1):
  """Exponential part of superformula."""
  level, d, d1 = c_int(level), c_float(d), c_float(d1)
  return d ** (level + d1)

def sf_join(constant, linear, power, exp, multiplier):
  """Join function for all parts of superformula."""
  constant, linear, power, exp, multiplier = c_float(constant), \
    c_float(linear), c_float(power), c_float(exp), c_float(multiplier)

  return float((constant + linear + power + exp) * multiplier)

def sf(level, coefficients):
  if isinstance(coefficients[0], tuple):
    # Invoked from spreadsheet.
    return sf(level, coefficients[0])
  else:
    # Invoked from code.
    a, b, b1, c, c1, c2, d, d1, _, _, multiplier = coefficients
    return sf_join(
      a,
      sf_lin(level, b, b1),
      sf_pow(level, c, c1, c2),
      sf_exp(level, d, d1),
      multiplier
    )

### Resources to time converter ###

def cost2time_ss(costs, volume_coefs, number_of_levels, multiplier):
  return cost2time(costs[0], costs[1], costs[2], volume_coefs,
    number_of_levels, multiplier)

def cost2time(metal_costs, energy_costs, zetium_costs, volume_coefs,
              number_of_levels, multiplier):
  metal_coef, energy_coef, zetium_coef = volume_coefs_expand(volume_coefs)

  time = lambda m, e, z: (float(m) / metal_coef + float(e) / energy_coef + \
                         float(z) / zetium_coef) * multiplier

  metal_start = sf(1, metal_costs)
  metal_end = sf(number_of_levels, metal_costs)
  energy_start = sf(1, energy_costs)
  energy_end = sf(number_of_levels, energy_costs)
  zetium_start = sf(1, zetium_costs)
  zetium_end = sf(number_of_levels, zetium_costs)

  start = time(metal_start, energy_start, zetium_start)
  end = time(metal_end, energy_end, zetium_end)

  return lin_dep_raw(start, end, number_of_levels)

### Dependencies ###

def lin_dep_raw(value1, value2, num_of_levels):
  """Returns tuple with values for linear dependency distributed in
  _num_of_levels_ between two values."""
  diff = float(value2 - value1)

  #      const   b  b1  c  c1 c2 d  d1 max_lvl
  res = [0,      0, -1, 0, 0, 0, 0, 0, num_of_levels]
  if num_of_levels == 1:
    res[0] = value2
    res[1] = 0
  else:
    res[0] = value1
    res[1] = diff / (num_of_levels - 1)

  return tuple(res)

def lin_dep(level1, coefs1, mult1, level2, coefs2, mult2, num_of_levels):
  value1 = sf(level1, coefs1) * mult1
  value2 = sf(level2, coefs2) * mult2
  return lin_dep_raw(value1, value2, num_of_levels)

def lin_dep_raw_with_first_lvl(max, num_of_levels):
  """Given min is 0 and max is passed, return linear dependency where first
  level also counts. I have no idea what that means"""
  coefs = lin_dep_raw(0, max, num_of_levels + 1)
  first_const = sf(2, coefs + (0, 1)) - 1
  coefs = list(lin_dep_raw(0, max - first_const, num_of_levels))
  coefs[0] = first_const
  return tuple(coefs)

def pow_dep_raw(value1, value2, num_of_levels):
  """Returns tuple with values for power dependency distributed in
  _num_of_levels_ between two values."""
  #      const   b  b1 c  c1 c2 d  d1 max_lvl
  res = [value1, 0, 0, 0, 0, 1, 0, 0, num_of_levels]
  if num_of_levels > 1:
    diff = value2 - value1
    res[3] = 0 if diff <= 0 else math.log(diff) / math.log(num_of_levels)
  elif num_of_levels == 1:
    res[5] = 0

  return tuple(res)

def pow_dep(level1, coefs1, mult1, level2, coefs2, mult2, num_levels):
  value1 = sf(level1, coefs1) * mult1
  value2 = sf(level2, coefs2) * mult2
  return pow_dep_raw(value1, value2, num_levels)

### Technologies ###

def research_time(coefs):
  """Given time coefs return array of coefs for min scientists needed.
  1 hours translates to minimum 12 scientists."""
  log("rt coefs", coefs)
  if isinstance(coefs[0], tuple):
    # Spreadsheet invocation.
    return research_time(coefs[0])
  else:
    coefs = list(coefs)
    coefs[10] = float(coefs[10]) / hrs2sec(1) * 12
    return tuple(coefs)

def tech_war_points(metal_cost_coefs, energy_cost_coefs, zetium_cost_coefs,
                    volume_coefs, points_mult, max_lvl):
  """Returns coefficients for war points required to unlock technology."""
  metal_volume, energy_volume, zetium_volume = volume_coefs_expand(volume_coefs)

  metal_start = sf(1, metal_cost_coefs) / metal_volume
  energy_start = sf(1, energy_cost_coefs) / energy_volume
  zetium_start = sf(1, zetium_cost_coefs) / zetium_volume
  points_start = (metal_start + energy_start + zetium_start) * points_mult

  if max_lvl == 1:
    return (points_start, 0, 0, 0, 0, 0, 0, 0, max_lvl, "level", 1)
  else:
    metal_end = sf(max_lvl, metal_cost_coefs) / metal_volume
    energy_end = sf(max_lvl, energy_cost_coefs) / energy_volume
    zetium_end = sf(max_lvl, zetium_cost_coefs) / zetium_volume
    points_end = (metal_end + energy_end + zetium_end) * points_mult

    return lin_dep_raw(points_start, points_end, max_lvl) + ("level", 1)

def tech_war_points_ss(cost_coefs, volume_coefs, points_mult, max_lvl):
  """Spreadsheet version of tech_war_points."""
  return tech_war_points(
    cost_coefs[0], cost_coefs[1], cost_coefs[2], volume_coefs, points_mult,
    max_lvl
  )

### Units ###

def dmg2armor(data, dmg_type, armor_type, dmg_per_gun, guns):
  for row in data:
    cell_dmg_type, cell_armor_type, multiplier = row
    if dmg_type == cell_dmg_type and armor_type == cell_armor_type:
      return multiplier * dmg_per_gun * guns

  return -1

### Unit technologies ###

def unit_tech_base(name, build_time, start_mult, end_mult, max_lvl,
                   metal, energy, zetium, volume_coefs, points_mult,
                   max_planets_required, npc):
  """
  Returns tuple with base rows for unit technology.

  Those include: time, metal, energy, zetium costs, min amount of scientists,
  required war points and required planets.
  """
  list = []

  gen_row = lambda prop, coefs: \
    list.append((name, prop) + coefs + (0, 1))

  for str, value in (
    ("time", build_time), ("metal cost", metal), ("energy cost", energy),
    ("zetium cost", zetium)
  ): gen_row(str, lin_dep_raw(value * start_mult, value * end_mult, max_lvl))

  list.append((name, "scientists min") + research_time(list[0][2:]))
  list.append((name, "war points") + tech_war_points(
    list[1][2:], list[2][2:], list[3][2:],
    volume_coefs, points_mult, max_lvl
  ))
  gen_row(
    "required pulsars" if npc else "required planets",
    lin_dep_raw(1, max_planets_required, max_lvl)
  )

  return tuple(list)

def unit_techs(name, build_time, metal, energy, zetium, volume_coefs,
               points_mult, max_planets_required,
               attack_mod, crit_abs_coef,
               is_space, unlocker, npc=False):
  """
  Generates technologies for base unit and its specializations.

  If _unlocker_ is true, then base technology has 10 levels and first level of
  technology just unlocks it. If it is false, then base technology has 9 levels
  and each level has its impact on abilities.
  """
  build_time = mins2sec(build_time)

  specs = get_specs(name, is_space)

  ### Base technology

  num_of_base_levels = max_lvl_for_unit_tech(name, unlocker)
  base_mod = base_proportion(attack_mod)

  start_mult = unit_tech_start_multiplier(npc)
  end_mult = start_mult if num_of_base_levels == 1 \
    else unit_tech_end_multiplier(npc)


  list = tuple()
  list += unit_tech_base(
    name, build_time, start_mult, end_mult, num_of_base_levels,
    metal, energy, zetium, volume_coefs, points_mult, max_planets_required, npc
  )

  for spec_name, func in specs:
    max = func(base_mod, crit_abs_coef) * 100
    coefs = lin_dep_raw(0, max, num_of_base_levels) if unlocker \
      else lin_dep_raw_with_first_lvl(max, num_of_base_levels)

    list += (name, spec_name.lower() + " mod") + coefs + (0, 1),
  list += empty_row

  ### Specialization technologies

  spec_mod = specialized_proportion(attack_mod)

  for spec_name, func in specs:
    tech_name = name + " " + spec_name
    list += unit_tech_base(
      tech_name, build_time, start_mult, end_mult, 10,
      metal, energy, zetium, volume_coefs, points_mult, max_planets_required,
      npc
    )

    coefs = lin_dep_raw_with_first_lvl(func(spec_mod, crit_abs_coef) * 100, 10)
    list += (tech_name, spec_name.lower() + " mod") + coefs + (0, 1),
    list += empty_row

  return list

def kind_tech_group(name, build_time, metal, energy, zetium, volume_coefs,
                    points_mult, max_planets_required,
                    attack_mod, crit_abs_coef, npc=False):
  """
  Returns technologies for one kind (e.g.: space, ground, turret).
  """
  build_time = mins2sec(build_time)
  start_mult = unit_tech_start_multiplier(npc)
  end_mult = unit_tech_end_multiplier(npc)

  specs = get_specs(name, False)

  list = tuple()

  proportion = kind_proportion(attack_mod)

  for spec_name, func in specs:
    tech_name = name + " " + spec_name
    list += unit_tech_base(
      tech_name, build_time, start_mult, end_mult, 10,
      metal, energy, zetium, volume_coefs, points_mult, max_planets_required,
      npc
    )

    coefs = lin_dep_raw_with_first_lvl(func(proportion, crit_abs_coef) * 100, 10)
    list += (tech_name, spec_name.lower() + " mod") + coefs + (0, 1),
    list += empty_row

  return list

def speed_group(base_name, build_time, metal, energy, zetium,
                volume_coefs, points_mult,
                max_planets_required, attack_mod, npc):
  """
  Returns technologies for speed group (heavy/light flight)
  """
  build_time = mins2sec(build_time)
  start_mult = unit_tech_start_multiplier(npc)
  end_mult = unit_tech_end_multiplier(npc)

  list = tuple()

  proportion = kind_proportion(attack_mod)

  spec_name, func = spec_speed
  for name in ("Heavy", "Light"):
    tech_name = "T " + base_name + name + " Flight"
    list += unit_tech_base(
      tech_name, build_time, start_mult, end_mult, 10,
      metal, energy, zetium, volume_coefs, points_mult, max_planets_required,
      npc
    )

    coefs = lin_dep_raw_with_first_lvl(func(proportion, 0) * 100, 10)
    list += (tech_name, spec_name.lower() + " mod") + coefs + (0, 1),
    list += empty_row

  return list

