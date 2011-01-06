package models.parts
{
   import flash.events.IEventDispatcher;
   
   public interface IUpgradableModel extends IEventDispatcher
   {
      function get type() : String; 
      function get upgradePart() : Upgradable;
   }
}