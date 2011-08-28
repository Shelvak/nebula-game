package models.technology
{
   import components.technologytree.TechnologySidebar;
   
   import flash.events.EventDispatcher;
   
   import models.technology.events.TechnologySidebarEvent;
   
   import utils.SingletonFactory;
   
   public class MCTechnologySelectedSidebar extends EventDispatcher
   {
      public static function getInstance(): MCTechnologySelectedSidebar
      {
         return SingletonFactory.getSingletonInstance(MCTechnologySelectedSidebar);
      }
      
      private var _selectedTechnology: Technology;
      
      public function get selectedTechnology(): Technology
      {
         return _selectedTechnology; 
      }
      
      public function set selectedTechnology(value: Technology): void
      {
         _selectedTechnology = value;
         dispatchSelectedTechnologyChangeEvent();
      }
      
      private function dispatchSelectedTechnologyChangeEvent(): void
      {
         if (hasEventListener(TechnologySidebarEvent.SELECTED_CHANGE))
         {
            dispatchEvent(new TechnologySidebarEvent(TechnologySidebarEvent.SELECTED_CHANGE));
         }
      }
   }
}