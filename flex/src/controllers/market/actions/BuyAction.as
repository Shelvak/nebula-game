package controllers.market.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import models.market.MCMarketScreen;
   import models.market.MarketOffer;
   import models.notification.MFaultEvent;
   import models.notification.MTimedEvent;

   import utils.locale.Localizer;
   import utils.remote.rmo.ClientRMO;

   /**
    * Buy some part of the offer from the market. Resources then are
    * transmitted to you planet/player.
    * 
    * Invocation: by client
    * 
    * Parameters:
    * - offer_id (Fixnum): ID of the offer being bought
    * - planet_id (Fixnum): ID of the planet where offer is being bought
    * - amount (Fixnum): amount of the resource being bought
    * 
    * Response:
    * - amount (Fixnum): amount actually bought. If 0, offer was destroyed
    * and purchase was unsuccessful. If > 0 - purchase was successful.
    * 
    * def action_buy 
    * @author Jho
    * 
    */   
   public class BuyAction extends CommunicationAction
   {
      private var offer: MarketOffer;
      
      public override function applyClientAction(cmd:CommunicationCommand):void
      {
         offer = cmd.parameters.offer;
         sendMessage(new ClientRMO({
         'offerId': offer.id,
         'planetId': cmd.parameters.planetId,
         'amount': cmd.parameters.amount
         }, offer));
      }
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         if (cmd.parameters.amount <= 0)
         {
            new MFaultEvent(Localizer.string('Market', 'message.offerGone'));
            MCMarketScreen.getInstance().publicOffers.remove(offer.id);
         }
         else
         {
            var mScreen: MCMarketScreen = MCMarketScreen.getInstance();
            offer.fromAmount -= cmd.parameters.amount;
            if (offer.fromAmount <= 0)
            {
               mScreen.publicOffers.remove(offer.id);
            }
            mScreen.dispatchRateUpdateNeededEvent();
         }
      }
   }
}