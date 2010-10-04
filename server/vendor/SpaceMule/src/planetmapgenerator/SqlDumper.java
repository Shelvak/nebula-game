package planetmapgenerator;

import java.util.HashSet;
import java.util.Set;

public class SqlDumper {
  private String tiles_table;
  private String buildings_table;
  private String folliages_table;
  private String units_table;
  private Set<Integer> dumpedPlanets = new HashSet<Integer>();
  static int CHUNK = 32000;

  SqlDumper(String tiles_table, String buildings_table,
          String folliages_table, String units_table) {
    this.tiles_table = tiles_table;
    this.buildings_table = buildings_table;
    this.folliages_table = folliages_table;
    this.units_table = units_table;
  }

  void dump(int galaxyId, int planetId, Generator generator) {
    if (dumpedPlanets.contains(planetId)) {
      System.err.println(String.format(
              "Already dumped planet with id %d! Exiting.",
              planetId
      ));
      System.exit(1);
    }
    else {
      dumpTiles(planetId, generator);
      dumpFolliage(planetId, generator);
      dumpBuildings(planetId, generator);
      dumpUnits(galaxyId, planetId, generator);
      dumpedPlanets.add(planetId);
    }
  }

  private void dumpSql(int planetId, String table, String columns,
          Iterable<SqlData> storage) {
    int index = 0;
    for (SqlData data: storage) {
      if (index == 0) {
        System.out.print(String.format(
                "INSERT INTO `%s` (%s) VALUES ",
                table, columns));
      } else {
        System.out.print(",");
      }

      System.out.print("(" + data.toValues(planetId) + ")");

      index++;

      if (index == CHUNK) {
        System.out.println();
        index = 0;
      }
    }

    System.out.println();
  }

  private void dumpTiles(int planetId, Generator generator) {
    dumpSql(planetId, tiles_table, SqlTile.columns(),
            generator.planetMap.getDatabaseTiles());
  }

  private void dumpFolliage(int planetId, Generator generator) {
    dumpSql(planetId, folliages_table, Folliage.columns(),
            generator.planetMap.getFolliages());
  }

  private void dumpBuildings(int planetId, Generator generator) {
    dumpSql(planetId, buildings_table, Building.columns(),
            generator.planetMap.getBuildings());
  }

  private void dumpUnits(int galaxyId, int planetId, Generator generator) {
    dumpSql(planetId, units_table, Unit.columns(),
            generator.planetMap.getUnits(galaxyId));
  }
}
