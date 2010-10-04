package controllers.resources.actions
{
   import components.screens.*;
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import globalevents.GResourcesEvent;
   
   import models.resource.ModType;
   
   import utils.DateUtil;
   
   /**
    * Downloads amounts of resources and shows it on resources bar.
    */ 
   public class IndexAction extends CommunicationAction
   {  
      
      /**
       * @private
       */
      override public function applyServerAction
         (cmd: CommunicationCommand) :void
      {            
         if (ML.latestPlanet != null)
            if (cmd.parameters.resourcesEntry.planetId == ML.latestPlanet.id)
            {
               //save all the information about resources     
               ML.metal.currentStock = cmd.parameters.resourcesEntry.metal;
               ML.metal.maxStock = cmd.parameters.resourcesEntry.metalStorage;
               ML.metal.rate = cmd.parameters.resourcesEntry.metalRate;
               
               ML.energy.currentStock = cmd.parameters.resourcesEntry.energy;
               ML.energy.maxStock = cmd.parameters.resourcesEntry.energyStorage;
               ML.energy.rate = cmd.parameters.resourcesEntry.energyRate;
               
               ML.zetium.currentStock = cmd.parameters.resourcesEntry.zetium;
               ML.zetium.maxStock = cmd.parameters.resourcesEntry.zetiumStorage;
               ML.zetium.rate = cmd.parameters.resourcesEntry.zetiumRate;
               
               //date of the last resources update @ server
               var updatedAt: Date;
               //timePast - time that have already ran since last update (in mSec)
               var timePast: Number;
               if (cmd.parameters.resourcesEntry.lastUpdate) {
                  updatedAt = DateUtil.parseServerDTF(cmd.parameters.resourcesEntry.lastUpdate);
                  timePast = new Date().time - updatedAt.time;
                  
                  //update resourcebar
                  new GResourcesEvent(GResourcesEvent.UPDATE, timePast);
               }
               
            }
      }
      
      
   }
}