package components.buildingsidebar
{
   import flash.events.Event;
   
   import models.building.Building;

   public class DemoChangedEvent extends Event
   {
      public static const DEMO_SELECTION_CHANGED: String = "demoSelectionChanged";
      private var _building:String;
      /**
       * Instance of a <code>Building</code> that one way or another caused this event
       * to be dispatched. 
       */      
      public function get building() : String
      {
         return _building;
      }
      
      public function DemoChangedEvent(type:String, b:String = null)
      {
         super(type);
         _building = b;
      }
   }
}