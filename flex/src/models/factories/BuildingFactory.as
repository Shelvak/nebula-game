package models.factories
{
   import config.Config;
   
   import flash.utils.getDefinitionByName;
   
   import models.building.Building;
   import models.building.Npc;
   
   import utils.Objects;
   
   
   /**
    * Lets easily create instances of buildings.
    */
   public class BuildingFactory
   {
      /**
       * Creates a building form a given simple object.
       *  
       * @param data An object representing a building.
       * 
       * @return instance of <code>Building</code> with values of properties
       * loaded from the data object.
       */
      public static function fromObject(data: Object): Building {
         if (!data) {
            return null;
         }
         try {
            return Objects.create(
               getDefinitionByName("models.building." + data.type) as Class,
               data
            );
         }
         catch (e: ReferenceError) {
            if (Config.getBuildingNpc(data.type)) {
               return Objects.create(Npc, data);
            }
            else {
               return Objects.create(Building, data);
            }
         }
         return null;
      }
      
      
      /**
       * Creates building instance of a given type with <code>x, y, xEnd, yEnd</code>
       * properties set to these values:
       * <ul>
       *    <li><code>x, y</code> - <code>0</code></li>
       *    <li><code>xEnd</code> - <code>Config.getBuildingWidth(type) - 1</code></li>
       *    <li><code>yEnd</code> - <code>Config.getBuildingHeight(type) - 1</code></li>
       * </ul>
       *  
       * @param type Type of a building. Use constants form
       * <code>BuildingType</code> class.
       * 
       * @return Instance of <code>Building</code>.
       */      
      public static function createDefault(type:String) : Building {
         var building:Building;
         try {
            building =
               new (getDefinitionByName("models.building." + type) as Class)();
         }
         catch (e: ReferenceError) {
            building = new Building();
         }
         building.type = type;
         Building.setSize(building);
         return building;
      }
      
      
      /**
       * Constructs a ghost (fake) building which takes place on the map but
       * has <code>id</code> set to <code>0</code>. This method does not set
       * <code>constructionMod</code> property.
       */
      public static function createGhost(type: String,
                                         x: int,
                                         y: int,
                                         constructorId: int,
                                         prepaid: Boolean): Building {
         var ghost:Building = new Building();
         ghost.type = type;
         ghost.x = x;
         ghost.y = y;
         Building.setSize(ghost);
         ghost.constructorId = constructorId;
         ghost.prepaid = prepaid;
         return ghost;
      }
   }
}