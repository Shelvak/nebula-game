package controllers.units.actions
{
   import controllers.CommunicationAction;

   import models.unit.MCUnitScreen;

   import utils.remote.rmo.ClientRMO;

   /**
    * Used for updating units
    */
   public class UpdateAction extends CommunicationAction
   {
      public override function result(rmo:ClientRMO) : void
      {
         super.result(rmo);
         MCUnitScreen.getInstance().confirmChanges();
      }
   }
}