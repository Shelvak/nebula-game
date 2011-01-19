package config
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import models.BaseModel;
   import models.battle.BGun;
   
   import utils.StringUtil;

   public final class BattleConfig
   {
      /**
       * Returns an object containing all unit animation properties.
       * 
       * @param type type of a unit
       * 
       * @return A hash-like object containing all animation properties of a unit
       */
      public static function getUnitAnimationProps(type:String) : Object
      {
         var key:String = "images.battlefield.units." + StringUtil.firstToLowerCase(type) + ".";
         var props: Object = new Object();
         props.targetPoint = Config.getAssetValue(key + "targetPoint");
         props.box = Config.getAssetValue(key + "box");
         props.actions = Config.getAssetValue(key + "actions");
         props.gunPoints = Config.getAssetValue(key + "gunPoints");
         props.moveSpeed = Config.getUnitProperty(type, "ui.move.speed");
         return props;
      }
      public static function getBuildingAnimationProps(type:String) : Object
      {
         var key:String = "images.battlefield.buildings." + StringUtil.firstToLowerCase(type) + ".";
         var props: Object = new Object();
         props.targetPoint = Config.getAssetValue(key + "targetPoint");
         props.box = Config.getAssetValue(key + "box");
         props.actions = Config.getAssetValue(key + "actions");
         props.gunPoints = Config.getAssetValue(key + "gunPoints");
         props.moveSpeed = Config.getUnitProperty(type, "ui.move.speed");
         return props;
      }
      
      
      /**
       * Returns array of guns that the given unit type has.
       * 
       * @return array of <code>BGun</code> instance.
       */
      public static function getUnitGuns(type:String) : Array
      {
         var gunPoints:Array = getUnitAnimationProps(type).gunPoints;
         if (gunPoints == null)
            throw new Error("no gun points for unit "+ type);
         var guns:Array = [];
         var id:int = 0;
         for each (var rawGun:Object in Config.getUnitGuns(type))
         {
            if (gunPoints[id] == null)
               throw new Error("no gun " + id +" point for unit "+ type);
            var gun:BGun = BaseModel.createModel(BGun, rawGun);
            gun.id = id;
            gun.type = StringUtil.underscoreToCamelCase(
               Config.getAssetValue('images.battlefield.units.'+StringUtil.firstToLowerCase(type)+'.guns')[id]);
            gun.position = new Point(
               gunPoints[id][0],
               gunPoints[id][1]
            );
            guns.push(gun);
            id++;
         }
         return guns;
      }
      
      public static function getBuildingGuns(type:String) : Array
      {
         var gunPoints:Array = getBuildingAnimationProps(type).gunPoints;
         var guns:Array = [];
         var id:int = 0;
         for each (var rawGun:Object in Config.getBuildingGuns(type))
         {
            var gun:BGun = BaseModel.createModel(BGun, rawGun);
            gun.id = id;
            gun.type = StringUtil.underscoreToCamelCase(
               Config.getAssetValue('images.battlefield.buildings.'+StringUtil.firstToLowerCase(type)+'.guns')[id]);
            gun.position = new Point(
               gunPoints[id][0],
               gunPoints[id][1]
            );
            guns.push(gun);
            id++;
         }
         return guns;
      }
      
      public static function getGunDelay(type: String): Number
      { 
         var value: Number = Config.getAssetValue('images.battlefield.guns.'+StringUtil.firstToLowerCase(type)+'.shots.delay');
         if (value == 0)
            throw new ArgumentError("Gun "+ type + " has no shots.delay");
         return value;
      }
      
      public static function getGunSpeed(type: String): Number
      {
         var value: Number = Config.getAssetValue('images.battlefield.guns.'+StringUtil.firstToLowerCase(type)+'.move.speed');
         if (value <= 0)
            throw new ArgumentError("Gun "+ type + " has no move.speed");
         return value;
      }
      
      public static function getUnitMoveSpeed(type: String): Number
      {
         var value: Number = Config.getAssetValue('images.battlefield.units.'+StringUtil.firstToLowerCase(type)+'.move.speed');
         if (value == 0)
            throw new ArgumentError("Unit "+ type + " has no move.speed");
         return value;
      }
      
      
      private static const PROJECTILE_HEAD_COORDS:Object = new Object();
      public static function getProjectileHeadCoords(gunType:String) : Point
      {
         var key:String = "images.battlefield.guns." + StringUtil.firstToLowerCase(gunType) + ".targetPoint";
         if (!PROJECTILE_HEAD_COORDS[key])
         {
            var coords:Array = Config.getAssetValue(key);
            if (!coords)
            {
               throw new ArgumentError("Gun " + gunType + " has no targetPoint");
            }
            PROJECTILE_HEAD_COORDS[key] = new Point(coords[0], coords[1]);
         }
         return PROJECTILE_HEAD_COORDS[key];
      }
      
      
      private static const PROJECTILE_TAIL_COORDS:Object = new Object();
      public static function getProjectileTailCoords(gunType:String) : Point
      {
         var key:String = "images.battlefield.guns." + StringUtil.firstToLowerCase(gunType) + ".gunPoints";
         if (!PROJECTILE_TAIL_COORDS[key])
         {
            var coords:Array = Config.getAssetValue(key)[0];
            if (!coords)
            {
               throw new ArgumentError("Gun " + gunType + " has no gunPoints");
            }
            PROJECTILE_TAIL_COORDS[key] = new Point(coords[0], coords[1]);
         }
         return PROJECTILE_TAIL_COORDS[key];
      }
      
      
      public static function getUnitBox(type:String) : Rectangle
      {
         var box:Object = getUnitAnimationProps(type).box;
         if (box == null)
            throw new Error("no box for unit "+type+" found");
         return new Rectangle(
            box.topLeft[0],
            box.topLeft[1],
            box.bottomRight[0] - box.topLeft[0] + 1,
            box.bottomRight[1] - box.topLeft[1] + 1
         );
      }
      
      
      public static function getBuildingBox(type:String) : Rectangle
      {
         var box:Object = getBuildingAnimationProps(type).box;
         return new Rectangle(
            box.topLeft[0],
            box.topLeft[1],
            box.bottomRight[0] - box.topLeft[0] + 1,
            box.bottomRight[1] - box.topLeft[1] + 1
         );
      }
      
      
      public static function getUnitTargetPoint(type:String) : Point
      {
         var point:Object = getUnitAnimationProps(type).targetPoint;
         return new Point(point[0], point[1]);
      }
      
      
      public static function getBuildingTargetPoint(type:String) : Point
      {
         var point:Object = getBuildingAnimationProps(type).targetPoint;
         return new Point(point[0], point[1]);
      }
      
      
      
      public static function getUnitDeathPassable(type: String) : Boolean
      {
         return getUnitAnimationProps(type)["dead.passable"];
      }
      
      public static function getGunAnimationProps(type:String) : Object
      {
         var key:String = "images.battlefield.guns." + StringUtil.firstToLowerCase(type) + ".";
         var props:Object = new Object();
         props.frameWidth = Config.getAssetValue(key + "frameWidth");
         props.shots = Config.getAssetValue(key +"shots");
         props.dispersion = Config.getAssetValue(key + "dispersion");
         props.actions = Config.getAssetValue(key + "actions");
         props.kind = Config.getAssetValue(key + "type");
         return props;
      }
   }
}