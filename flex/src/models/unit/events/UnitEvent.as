package models.unit.events
{
   import flash.events.Event;
   
   public class UnitEvent extends Event
   {
      
      public static const SQUADRON_ID_CHANGE:String = "squadronIdChange";
      public static const STANCE_CHANGE:String = "unitStanceChange";
      public static const STORED_CHANGE:String = "storedAmountChange";
      public static const METAL_CHANGE:String = "metalAmountChange";
      public static const ENERGY_CHANGE:String = "energyAmountChange";
      public static const ZETIUM_CHANGE:String = "zetiumAmountChange";
      public static const VALIDATION_CHANGED: String = "validationChanged";
      public static const SELECTED_RESOURCES_CHANGE: String = "selectedResourcesChange";
      public static const PANEL_BUTTON_CLICK: String = "panelButtonClick";
      public static const OPEN_FACILITY: String = "openFacility";
      
      
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