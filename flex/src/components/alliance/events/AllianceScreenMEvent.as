package components.alliance.events
{
   import flash.events.Event;
   
   public class AllianceScreenMEvent extends Event
   {
      /**
       * Dispatched when different tab has been selected.
       * 
       * @eventType tabSelect
       */
      public static const TAB_SELECT:String = "tabSelect";
      
      /**
       * Dispatched when <code>MAllianceScreen.alliance</code> property changes.
       * 
       * @eventType allianceChange
       */
      public static const ALLIANCE_CHANGE:String = "allianceChange";
      
      /**
       * Dispatched when <code>MAllianceScreen.managementTabEnabled</code> property changes.
       * 
       * @eventType managementTabEnabledChange
       */
      public static const MANAGEMENT_TAB_ENABLED_CHANGE:String = "managementTabEnabledChange";
      
      
      public function AllianceScreenMEvent(type:String)
      {
         super(type);
      }
   }
}