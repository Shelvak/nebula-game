/**
 * Created by IntelliJ IDEA.
 * User: Jho
 * Date: 1/30/12
 * Time: 3:53 PM
 * To change this template use File | Settings | File Templates.
 */
package components.resourcetransporter {
   import components.resourcetransporter.events.ResourceTransporterEvent;

   import flash.events.EventDispatcher;

   import models.building.Building;

   import utils.SingletonFactory;

   public class MCResourceTransporter extends EventDispatcher {

      public static function getInstance(): MCResourceTransporter
      {
         return SingletonFactory.getSingletonInstance(MCResourceTransporter);
      }
      
      private var _selectedBuilding: Building;

      [Bindable (event="selectedBuildingChange")]
      public function set selectedBuilding(value: Building): void
      {
         _selectedBuilding = value;
         dispatchSelectedBuildingChangeEvent();
      }
      
      public function get selectedBuilding(): Building
      {
         return _selectedBuilding;
      }

      private function dispatchSelectedBuildingChangeEvent(): void
      {
         if (hasEventListener(ResourceTransporterEvent.SELECTED_BUILDING_CHANGE))
         {
            dispatchEvent(new ResourceTransporterEvent(
               ResourceTransporterEvent.SELECTED_BUILDING_CHANGE));
         }
      }
   }
}