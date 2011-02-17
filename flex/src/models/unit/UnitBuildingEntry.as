package models.unit
{
   import controllers.objects.ObjectClass;
   
   import flash.display.BitmapData;
   
   import models.BaseModel;
   import models.tile.TerrainType;
   
   import utils.ModelUtil;
   import utils.StringUtil;
   import utils.assets.AssetNames;
   
   
   public class UnitBuildingEntry extends BaseModel
   {
      public function UnitBuildingEntry(type:String = "", count:int = 0, terrainType:int = TerrainType.GRASS, level:int = 0)
      {
         super();
         _terrainType = terrainType;
         _type = StringUtil.firstToUpperCase(type);
         _count = count;
         this.level = level;
      };
      
      
      private var _type:String = null;
      [Required]
      [Bindable(event="willNotChange")]
      /**
       * Type of units that are part of a squadron.
       */
      public function set type(value:String) : void
      {
         _type = StringUtil.firstToUpperCase(value);
      }
      /**
       * @private
       */
      public function get type() : String
      {
         return _type;
      }
      
      
      private var _count:uint = 0;
      [Required]
      [Bindable]
      /**
       * How many units of this <code>type</code> are in a squadron.
       */
      public function set count(value:uint) : void
      {
         _count = value;
      }
      /**
       * @private
       */
      public function get count() : uint
      {
         return _count;
      }
      
      
      [Bindable]
      public var level:int = 0;
      
      
      private var _terrainType:int
      [Bindable(event="willNotChange")]
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
         return ModelUtil.getModelClass(type) == ObjectClass.UNIT;
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
      public function get imageData() : BitmapData
      {
         var t:String = ModelUtil.getModelSubclass(type);
         if (isBuilding)
         {
            return IMG.getImage(AssetNames.getBuildingImageName(t));
         }
         else
         {
            return IMG.getImage(AssetNames.getUnitImageName(t));
         }
      }
      
      
      public override function toString() : String
      {
         return "[class: " + className + ", type: " + type + ", count: " + count + "]";
      }
   }
}