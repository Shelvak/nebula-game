package models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import models.battle.BGun;

   public interface IBattleParticipantModel extends IAnimatedModel
   {
      function get type() : String;
      
      function get box() : Rectangle;
      
      function get targetPoint() : Point;
      
      function get actualHp() : int;
      function set actualHp(value:int) : void;
      
      function get hp() : int;
      function set hp(value:int) : void;
      
      function get maxHp() : int;
      
      function get kind() : String;
      
      function get playerStatus() : int;
      
      function getGun(id:int) : BGun;
      
      function toString():String;
   }
}