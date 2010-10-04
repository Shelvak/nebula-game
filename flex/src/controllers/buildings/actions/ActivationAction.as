package controllers.buildings.actions
{
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import globalevents.GBuildingEvent;
   
   import models.building.Building;
   import models.factories.BuildingFactory;
   
   
   
   
   /**
    * Used for activating/deactivating building
    */
   public class ActivationAction extends CommunicationAction
   {
      
      public override function result() : void
      {
         new GBuildingEvent(GBuildingEvent.BUILDING_ACTIVATION);
      }
 
   }
}