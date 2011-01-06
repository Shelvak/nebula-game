package models.unit.events
{
   import flash.events.Event;
   
   public class UnitEvent extends Event
   {
      
      public static const SQUADRON_ID_CHANGE:String = "squadronIdChange";
      public static const STANCE_CHANGE:String = "unitStanceChange";
      public static const VALIDATION_CHANGED: String = "validationChanged";
      public static const SELECTED_RESOURCES_CHANGE: String = "selectedResourcesChange";
      
      
      public function UnitEvent(type:String, oldId:int = 0)
      {
         oldSquadronId = oldId;
         super(type, false, false);
      }
      
      
      /**
       * Makes sense only for <code>SQUADRON_ID_CHANGE</code> event.
       */
      public var oldSquadronId:int;
   }
}