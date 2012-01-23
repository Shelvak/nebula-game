# Python macros for odsimport.ods.
#
# For this to work, it needs to be in script path.
#
# Linux:
# $ ln -s path/to/skaiciuokle.py ~/.libreoffice/3/user/Scripts/python/
#
# While developing, you need to update symlink timestamp for libreoffice to
# reload the file:
# $ while true; do sleep 1; touch -h path/to/skaiciuokle.py; echo -n "."; done
#

import math

def log(name, value):
  file = open('/home/arturas/pymacro.log', 'a')
  file.write(name + ": " + str(value) + "\n")
  file.close()

empty_row = (tuple(),)

### unit/base technology multipliers ###

unit_tech_start_multiplier = lambda npc: 8 if npc else 4
unit_tech_end_multiplier = lambda npc: 120 if npc else 60

### Attack modifier division ###

kind_attack_mod = lambda mod: 0.2 * mod # For space/ground technologies
base_attack_mod = lambda mod: 0.3 * mod # For unit base technologies
specialized_attack_mod = lambda mod: 0.5 * mod # For unit specialization

### Specialization formulas ###

# base is full attack modifier
# coef is critical/absorption damage multiplier
ground_specs = (
  ("Damage", lambda base, coef: base),
  ("Armor", lambda base, coef: 1 - 1 / (1 + base)),
  ("Critical", lambda base, coef: base / (coef - 1)),
  ("Absorption", lambda base, coef: (1 / (1 + base) - 1) / (1 / coef - 1))
)
space_specs = ground_specs + (("Speed", lambda base, coef: base),)

def get_specs(is_space):
  return space_specs if is_space else ground_specs

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
  level also counts."""
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
  if isinstance(volume_coefs, tuple) and len(volume_coefs) == 3 and \
      isinstance(volume_coefs[0], tuple):
    # Convert volume_coefs if they come from spreadsheet.
    return tech_war_points(
      metal_cost_coefs, energy_cost_coefs, zetium_cost_coefs,
      (volume_coefs[0][0], volume_coefs[1][0], volume_coefs[2][0]),
      points_mult, max_lvl
    )
  else:
    metal_volume, energy_volume, zetium_volume = volume_coefs

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
                   max_planets_required):
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
  gen_row("required planets", lin_dep_raw(1, max_planets_required, max_lvl))

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
  start_mult = unit_tech_start_multiplier(npc)
  end_mult = unit_tech_end_multiplier(npc)

  specs = get_specs(is_space)

  ### Base technology

  num_of_base_levels = 10 if unlocker else 9
  base_mod = base_attack_mod(attack_mod)

  list = tuple()
  list += unit_tech_base(
    name, build_time, start_mult, end_mult, num_of_base_levels,
    metal, energy, zetium, volume_coefs, points_mult, max_planets_required
  )

  for spec_name, func in specs:
    max = func(base_mod, crit_abs_coef) * 100
    coefs = lin_dep_raw(0, max, num_of_base_levels) if unlocker \
      else lin_dep_raw_with_first_lvl(max, num_of_base_levels)

    list += (name, spec_name.lower() + " mod") + coefs + (0, 1),
  list += empty_row

  ### Specialization technologies

  spec_mod = specialized_attack_mod(attack_mod)

  for spec_name, func in specs:
    tech_name = name + " " + spec_name
    list += unit_tech_base(
      tech_name, build_time, start_mult, end_mult, 10,
      metal, energy, zetium, volume_coefs, points_mult, max_planets_required
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

  specs = get_specs(False)

  list = tuple()

  kind_mod = kind_attack_mod(attack_mod)

  for spec_name, func in specs:
    tech_name = name + " " + spec_name
    list += unit_tech_base(
      tech_name, build_time, start_mult, end_mult, 10,
      metal, energy, zetium, volume_coefs, points_mult, max_planets_required
    )

    coefs = lin_dep_raw_with_first_lvl(func(kind_mod, crit_abs_coef) * 100, 10)
    list += (tech_name, spec_name.lower() + " mod") + coefs + (0, 1),
    list += empty_row

  return list

def speed_group(name):
  pass

