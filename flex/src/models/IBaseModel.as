package models
{
   import flash.events.IEventDispatcher;
   
   import interfaces.IEqualsComparable;
   import interfaces.IHashable;

   public interface IBaseModel extends IEventDispatcher, IEqualsComparable, IHashable
   {
      function get id() : int;
      function set id(value:int) : void;
   }
}