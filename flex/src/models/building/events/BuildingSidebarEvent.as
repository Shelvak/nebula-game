package models.building.events
{
   import flash.events.Event;
   
   public class BuildingSidebarEvent extends Event
   {
      public static const SELECTED_CHANGE: String = 'selectedBuildingChange';
      public function BuildingSidebarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
      {
         super(type, bubbles, cancelable);
      }
   }
}