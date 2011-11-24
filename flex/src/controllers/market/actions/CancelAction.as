package controllers.market.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import models.market.MCMarketScreen;

   import utils.remote.rmo.ClientRMO;

   /**
    * Cancel given market offer. Return resources left on offer to planet.
    * 
    * Invocation: by client
    * 
    * Parameters:
    * - offer_id (Fixnum): ID of the offer being canceled
    * 
    * Response: None
    * 
    * def action_cancel 
    * @author Jho
    * 
    */   
   public class CancelAction extends CommunicationAction
   {
      private var offerId: int;
      public override function applyClientAction(cmd:CommunicationCommand):void
      {
         offerId = int(cmd.parameters);
         sendMessage(new ClientRMO({'offerId': offerId}));
      }
      
      public override function result(rmo:ClientRMO):void
      {
         super.result(rmo);
         var mScreen: MCMarketScreen = MCMarketScreen.getInstance();
         mScreen.privateOffers.remove(offerId);
         mScreen.publicOffers.remove(offerId);
         mScreen.offerCount--;
      }
   }
}