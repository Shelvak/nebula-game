package controllers.market.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.Messenger;

   import models.market.MCMarketScreen;
   import models.market.MarketOffer;

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
            Messenger.show(Localizer.string('Market', 'message.offerGone'));
            MCMarketScreen.getInstance().publicOffers.remove(offer.id);
         }
         else
         {
            offer.fromAmount -= cmd.parameters.amount;
            if (offer.fromAmount <= 0)
            {
               MCMarketScreen.getInstance().publicOffers.remove(offer.id);
            }
         }
      }
   }
}