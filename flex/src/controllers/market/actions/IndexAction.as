package controllers.market.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import models.ModelsCollection;
   import models.factories.MarketOfferFactory;
   import models.market.MCMarketScreen;

   /**
    * Send list of all market offers in the galaxy.
    * Invocation: by client
    * 
    * Parameters:
    * - planet_id (Fixnum): ID of the planet market is in.
    * 
    * Response:
    * - public_offers (Hash[]): offers that you can buy.
    * See MarketOffer#as_json for +Hash+ format.
    * - planet_offers (Hash[]): offers being offered by you in this planet.
    * - offer_count (Fixnum): total number of your offers.
    * 
    * def action_index 
    * @author Jho
    * 
    */   
   public class IndexAction extends CommunicationAction
   {
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         var mScreen: MCMarketScreen = MCMarketScreen.getInstance();
         mScreen.publicOffers = new ModelsCollection(MarketOfferFactory.fromArray(
            cmd.parameters.publicOffers));
         mScreen.privateOffers = new ModelsCollection(MarketOfferFactory.fromArray(
            cmd.parameters.planetOffers));
         mScreen.offerCount = cmd.parameters.offerCount;
         mScreen.resetScreen();
      }
   }
}