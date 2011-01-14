package models.parts
{
   import flash.events.IEventDispatcher;
   
   import interfaces.ICleanable;
   
   
   public interface IUpgradableModel extends IEventDispatcher, ICleanable
   {
      function get type() : String; 
      function get upgradePart() : Upgradable;
   }
}