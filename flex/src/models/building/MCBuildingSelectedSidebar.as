package models.building
{
   import controllers.buildings.BuildingsCommand;
   import controllers.objects.ObjectClass;
   import controllers.ui.NavigationController;
   
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   import models.ModelLocator;
   import models.Owner;
   import models.building.events.BuildingSidebarEvent;
   
   import mx.collections.ArrayCollection;
   
   import utils.SingletonFactory;
   
   public class MCBuildingSelectedSidebar extends EventDispatcher
   {
      public static function getInstance(): MCBuildingSelectedSidebar
      {
         return SingletonFactory.getSingletonInstance(MCBuildingSelectedSidebar);
      }
      
      private function get ML(): ModelLocator
      {
         return ModelLocator.getInstance();
      }
      
      private function get NC(): NavigationController
      {
         return NavigationController.getInstance();
      }     
      
      /**
       * List of buildings player is alowed to construct.
       * 
       * @default null 
       */      
      public var constructable:ArrayCollection = null;
      
      public function openBuilding(building: Building): void
      {
         if (building.upgradePart.upgradeEndsAt != null 
            || ML.latestPlanet.ssObject.owner != Owner.PLAYER)
         {
            return;
         }
         switch (building.type)
         {
            case BuildingType.RESEARCH_CENTER:
               NC.showTechnologies();
               break;
            case BuildingType.MARKET:
               NC.showMarket(building);
               break;
            case BuildingType.DEFENSIVE_PORTAL:
               if (building.state == Building.ACTIVE)
               {
                  NC.showDefensivePortal(ML.latestPlanet.id);
               }
               break;
            case BuildingType.HEALING_CENTER:
               NC.showHealing(building, ML.latestPlanet.getActiveHealableUnits());
               break;
            default:
               if (building.npc)
               {            
                  if (ML.latestPlanet.getAgressiveGroundUnits().length != 0)
                  {
                     NC.showUnits(ML.latestPlanet.getAgressiveGroundUnits(), 
                        ML.latestPlanet.toLocation(), building);
                  }
               }
               else if (building.isConstructor(ObjectClass.UNIT))
               {
                  NC.showFacilities(building.id);
                  return;
               }
               else if (building.state != Building.WORKING && building.usesResource)
               {
                  if (!building.pending)
                  {
                     if (building.state == Building.ACTIVE)
                     {
                        new BuildingsCommand(BuildingsCommand.DEACTIVATE, 
                           building).dispatch ();
                     }
                     else if (building.state == Building.INACTIVE)
                     {
                        new BuildingsCommand(BuildingsCommand.ACTIVATE, 
                           building).dispatch ();
                     }
                  }
               }
               break;
         }
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