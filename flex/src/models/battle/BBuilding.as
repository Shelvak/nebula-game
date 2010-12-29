package models.battle
{
   
   import config.Config;
   
   import utils.StringUtil;
   
   import config.BattleConfig;
   
   import flash.display.BitmapData;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import models.BaseModel;
   import models.IMBattleParticipant;
   import models.building.Building;
   import models.unit.UnitKind;
   
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   public class BBuilding extends BaseModel implements IMBattleParticipant
   {
      include "mixins/frameDimensions.as";
      include "mixins/actualHp.as";
      
      
      public static const CURRENT: int = 0;
      public static const ALLIANCE: int = 1;
      public static const NAP: int = 2;
      public static const ENEMY: int = 3;
      
      [Required]
      public var playerId: int;
      
      [Required]
      public var level: int;
      /**
       * 0 means it's current player
       * 1 means it's your aliance
       * 2 means it's your nap 
       * 3 means it's your enemy 
       */   
      private var _playerStatus: int = 0;
      
      public function get playerStatus(): int
      {
         return _playerStatus;
      }
      
      public function set playerStatus(value: int): void
      {
         _playerStatus = value;
      }
      
      public function get box() : Rectangle
      {
         return BattleConfig.getBuildingBox(type);
      }
      
      
      public function get targetPoint() : Point
      {
         return BattleConfig.getBuildingTargetPoint(type);
      }
      
      
      public function get framesData() : Vector.<BitmapData>
      {
         return ImagePreloader.getInstance().getFrames(AssetNames.getBuildingFramesFolder(type));
      }
      
      private var _type: String;
      
      [Required]
      public function set type(value:String) : void
      {
         _type = value;
      }
      
      public function get type() : String
      {
         return _type;
      }
      
      private var _hp:int = 0;
      [Required]
      public function set hp(value:int) : void
      {
         if (value < 0)
         {
            _hp = 0;
         }
         else
         {
            _hp = value;
         }
      }
      public function get hp() : int
      {
         return _hp;
      }
      
      public function get maxHp(): int
      {
         return StringUtil.evalFormula(Config.getBuildingHp(type), {'level': level});
      }
      
      private var guns:Array = null;
      /**
       * Returns a gun with specified id.
       * 
       * @param id id (index) of a gun; starts from 0
       * 
       * @return instance of <code>BGun</code> with a given id
       */
      public function getGun(id:int) : BGun
      {
         if (!guns)
         {
            guns = BattleConfig.getBuildingGuns(type);
         }
         return guns[id];
      } 
      
      public function get kind(): String
      {
         return UnitKind.GROUND;
      }
   }
}

