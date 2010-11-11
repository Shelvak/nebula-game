package models.unit
{
   import flash.display.BitmapData;
   
   import models.tile.TerrainType;
   
   import utils.assets.AssetNames;
   
   public class UnitBuildingEntry extends UnitEntry
   {
      /**
       * @copy UnitEntry#UnitEntry()
       */
      public function UnitBuildingEntry(type:String = "", count:int = 0, terrainType:int = TerrainType.GRASS, level: int = 0)
      {
         super(type, count, level);
         _terrainType = terrainType;
      };
      
      
      private var _terrainType:int
      /**
       * Image of terrain of a planet this building is located. Irrelevant for units and
       * return <code>null</code> for them.  
       */
      public function get terrainImageData() : BitmapData
      {
         if (isBuilding)
         {
            return IMG.getImage(
               AssetNames.NOTIFICATION_IMAGE_FOLDER +
               "unit_background_" + TerrainType.getName(_terrainType)
            );
         }
         return null;
      }
      
      
      /**
       * <code>true</code> if this is actually a unit.
       */
      public function get isUnit() : Boolean
      {
         return type.indexOf("Unit::") == 0 || type.indexOf("unit::") == 0;
      }
      
      
      /**
       * <code>true</code> if this is actually a building.
       */
      public function get isBuilding() : Boolean
      {
         return !isUnit;
      }
      
      
      [Bindable(event="willNotChange")]
      /**
       * Image of this constructable.
       */
      public override function get imageData() : BitmapData
      {
         var t:String = type.replace("Unit::", "").replace("unit::", "")
                            .replace("Building::", "").replace("building::", "");
         if (isBuilding)
         {
            return IMG.getImage(AssetNames.getBuildingImageName(t));
         }
         else
         {
            return IMG.getImage(AssetNames.getUnitImageName(t));
         }
      }
   }
}