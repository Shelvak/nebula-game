package models.battle
{
   import flash.display.BitmapData;
   
   import models.BaseModel;
   import models.IBattleParticipantModel;
   import models.unit.Unit;
   
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   import utils.profiler.Profiler;
   
   
   public class BUnit extends BaseModel implements IBattleParticipantModel
   {
      include "mixins/guns.as";
      include "mixins/box.as";
      include "mixins/targetPoint.as";
      include "mixins/frameDimensions.as";
      include "mixins/actualHp.as";
	  include "../mixins/commonUnitProps.as";
	  
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
     private var _playerStatus: int;
     
      public function get playerStatus(): int
      {
         return _playerStatus;
      }
      
      public function set playerStatus(value: int): void
      {
         _playerStatus = value;
      }
      
      
      public function get framesData() : Vector.<BitmapData>
      {
         return ImagePreloader.getInstance().getFrames(AssetNames.getUnitFramesFolder(type));
      }
      
      public override function toString():String {
         return super.toString() + "(type=" + type + ",status=" + playerStatus + ")";
      }
   }
}