package models.technology.events
{
   import flash.events.Event;
   
   public class TechnologySidebarEvent extends Event
   {
      public static const SELECTED_CHANGE: String = 'selectedBuildingChange';
      public function TechnologySidebarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
      {
         super(type, bubbles, cancelable);
      }
   }
}