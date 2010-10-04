package planetmapgenerator;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

public class Building implements SqlData {
  int x, y, type;

  @Override
  public boolean equals(Object obj) {
    if (obj instanceof Building) {
      Building other = (Building) obj;
      return (other.x == x && other.y == y && other.type == type);
    }
    else {
      return false;
    }
  }

  @Override
  public int hashCode() {
    int hash = 7;
    hash = 43 * hash + this.x;
    hash = 43 * hash + this.y;
    hash = 43 * hash + this.type;
    return hash;
  }

  static int TYPE_MOTHERSHIP = 0;
  static int TYPE_NPC_METAL_EXTRACTOR = 1;
  static int TYPE_NPC_GEOTHERMAL_PLANT = 2;
  static int TYPE_NPC_ZETIUM_EXTRACTOR = 3;
  static int TYPE_NPC_SOLAR_PLANT = 4;
  static int TYPE_NPC_COMMUNICATIONS_HUB = 5;
  static int TYPE_NPC_TEMPLE = 6;
  static int TYPE_NPC_EXCAVATION_SITE = 7;
  static int TYPE_NPC_RESEARCH_CENTER = 8;
  static int TYPE_NPC_JUMPGATE = 9;
  static int TYPE_VULCAN = 10;
  static int TYPE_SCREAMER = 11;
  static int TYPE_THUNDER = 12;

  public static Pair getDimensions(String name) {
    name = Config.underscore(name);
    return new Pair(
      Config.getInt("buildings." + name + ".width"),
      Config.getInt("buildings." + name + ".height")
    );
  }

  public static int getHp(String name) {
    return Config.getInt("buildings." + Config.underscore(name) + ".hp");
  }

  Building(int x, int y, String building) {
    this.x = x;
    this.y = y;

    if (building.equalsIgnoreCase("m")) {
      type = TYPE_MOTHERSHIP;
    }
    else if (building.equalsIgnoreCase("v")) {
      type = TYPE_VULCAN;
    }
    else if (building.equalsIgnoreCase("s")) {
      type = TYPE_SCREAMER;
    }
    else if (building.equalsIgnoreCase("t")) {
      type = TYPE_THUNDER;
    }
    else if (building.equalsIgnoreCase("x")) {
      type = TYPE_NPC_METAL_EXTRACTOR;
    }
    else if (building.equalsIgnoreCase("g")) {
      type = TYPE_NPC_GEOTHERMAL_PLANT;
    }
    else if (building.equalsIgnoreCase("z")) {
      type = TYPE_NPC_ZETIUM_EXTRACTOR;
    }
    else if (building.equalsIgnoreCase("p")) {
      type = TYPE_NPC_SOLAR_PLANT;
    }
    else if (building.equalsIgnoreCase("h")) {
      type = TYPE_NPC_COMMUNICATIONS_HUB;
    }
    else if (building.equalsIgnoreCase("e")) {
      type = TYPE_NPC_TEMPLE;
    }
    else if (building.equalsIgnoreCase("c")) {
      type = TYPE_NPC_EXCAVATION_SITE;
    }
    else if (building.equalsIgnoreCase("r")) {
      type = TYPE_NPC_RESEARCH_CENTER;
    }
    else if (building.equalsIgnoreCase("u")) {
      type = TYPE_NPC_JUMPGATE;
    }
  }

  public static Map<Integer, String> mappings = null;
  static {
    mappings = new HashMap<Integer, String>();
    mappings.put(Building.TYPE_MOTHERSHIP, "Mothership");
    mappings.put(Building.TYPE_VULCAN, "Vulcan");
    mappings.put(Building.TYPE_SCREAMER, "Screamer");
    mappings.put(Building.TYPE_THUNDER, "Thunder");
    mappings.put(Building.TYPE_NPC_METAL_EXTRACTOR,
            "NpcMetalExtractor");
    mappings.put(Building.TYPE_NPC_GEOTHERMAL_PLANT,
            "NpcGeothermalPlant");
    mappings.put(Building.TYPE_NPC_ZETIUM_EXTRACTOR,
            "NpcZetiumExtractor");
    mappings.put(Building.TYPE_NPC_COMMUNICATIONS_HUB,
            "NpcCommunicationsHub");
    mappings.put(Building.TYPE_NPC_EXCAVATION_SITE,
            "NpcExcavationSite");
    mappings.put(Building.TYPE_NPC_JUMPGATE,
            "NpcJumpgate");
    mappings.put(Building.TYPE_NPC_RESEARCH_CENTER,
            "NpcResearchCenter");
    mappings.put(Building.TYPE_NPC_SOLAR_PLANT,
            "NpcSolarPlant");
    mappings.put(Building.TYPE_NPC_TEMPLE,
            "NpcTemple");
  }

  public static String getName(int type) {
    return mappings.get(type);
  }

  public Pair[] getCoordinates() {
    String name = Building.getName(type);
    Pair dimensions = Building.getDimensions(name);
    Pair[] data = {
      new Pair(x, y),
      new Pair(x + dimensions.x - 1, y + dimensions.y - 1)
    };
    return data;
  }

  public List<Unit> getUnits() {
    LinkedList<Unit> data = new LinkedList<Unit>();
    Object unitsList = Config.getList(
            "buildings." + Config.underscore(Building.getName(type))
              + ".units",
            false
    );

    // Units can be null if nobody is garrisoned inside.
    if (unitsList != null) {
      int flank = 0;
      for (Object flankObject: (List) unitsList) {
        for (Object typeObject: (List) flankObject) {
          data.add(
                  new Unit((String) typeObject, flank, x, y)
          );
        }
        flank++;
      }
    }

    return data;
  }

  public static String columns() {
    return "`planet_id`, `type`, `x`, `y`, `x_end`, `y_end`, " +
            "`level`, `hp`, `armor_mod`, " +
            "`constructor_mod`, `construction_mod`, `energy_mod`";
  }

  public String toValues(int planetId) {
    String name = Building.getName(type);
    int hp = Building.getHp(name);
    Pair dimensions = Building.getDimensions(name);
    return String.format(
              "%d, '%s', %d, %d, %d, %d, %d, %d, %d, %d, %d, %d",
              planetId,
              name,
              x,
              y,
              x + dimensions.x - 1,
              y + dimensions.y - 1,
              1,
              hp,
              // MODS
              0, 0, 0, 0
              );
  }
}
