package models.building
{
   import components.buildingsidebar.DemoChangedEvent;
   
   import flash.events.EventDispatcher;

   [Bindable]
   public class MCSidebarBuilding extends EventDispatcher
   {
      public var demo: Boolean = false;
      public var constructing: Boolean = false;
      public var type: String;
      public var disabled: Boolean = false;
      public var query: Boolean = false;
      public function MCSidebarBuilding(_type: String)
      {
         type = _type;
         super();
      }
      
      public function refresh(): void
      {
         new DemoChangedEvent(DemoChangedEvent.CONSTRUCTING_CHANGED);
      }
   }
}