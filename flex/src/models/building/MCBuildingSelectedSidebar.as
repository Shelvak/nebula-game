package models.building
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   import models.building.events.BuildingSidebarEvent;
   
   import utils.SingletonFactory;
   
   public class MCBuildingSelectedSidebar extends EventDispatcher
   {
      public static function getInstance(): MCBuildingSelectedSidebar
      {
         return SingletonFactory.getSingletonInstance(MCBuildingSelectedSidebar);
      }
      
      private var _selectedBuilding: Building;
      
      public function get selectedBuilding(): Building
      {
         return _selectedBuilding; 
      }
      
      public function set selectedBuilding(value: Building): void
      {
         _selectedBuilding = value;
         dispatchSelectedBuildingChangeEvent();
      }
      
      private function dispatchSelectedBuildingChangeEvent(): void
      {
         if (hasEventListener(BuildingSidebarEvent.SELECTED_CHANGE))
         {
            dispatchEvent(new BuildingSidebarEvent(BuildingSidebarEvent.SELECTED_CHANGE));
         }
      }
   }
}