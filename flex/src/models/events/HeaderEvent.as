package models.events
{
   import flash.events.Event;
   
   public class HeaderEvent extends Event
   {
      public static const LIST_SORT: String = "listSort";
      
      public var key: String;
      public function HeaderEvent(type:String, _key: String)
      {
         key = _key;
         super(type);
      }
   }
}