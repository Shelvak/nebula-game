package models.unit.events
{
   import flash.events.Event;
   
   public class UnitEvent extends Event
   {
      
      public static const SQUADRON_ID_CHANGE: String = "squadronIdChange";
      
      public var oldSquadronId: int;
      
      public function UnitEvent(type:String, oldId: int)
      {
         oldSquadronId = oldId;
         super(type, false, false);
      }
   }
}