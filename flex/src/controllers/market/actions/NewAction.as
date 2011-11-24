package controllers.market.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import utils.ApplicationLocker;
   import controllers.Messenger;
   
   import models.factories.MarketOfferFactory;
   import models.market.MCMarketScreen;
   import models.market.MarketOffer;
   
   import utils.locale.Localizer;
   import utils.remote.rmo.ClientRMO;

   /**
    *  Create a new offer.
    *  
    *  Invocation: by client
    *
    * Parameters:
    * - market_id (Fixnum): ID of the market
    * - from_amount (Fixnum): amount of resource you want to offer
    * - from_kind (Fixnum): kind of resource you are offering. One of the
    * MarketOffer::KIND_* constants.
    * - to_kind (Fixnum): kind of resource you are demanding.
    * - to_rate (Float): exchange rate. How much resources of _to_kind_ you
    * are demanding for 1 unit of _from_kind_ resource.
    * 
    * Response:
    * - offer (Hash): MarketOffer#as_json
    * 
    * def action_new 
    * @author Jho
    * 
    */   
   public class NewAction extends CommunicationAction
   {
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         var offer: MarketOffer = MarketOfferFactory.fromObject(cmd.parameters.offer);
         var mScreen: MCMarketScreen = MCMarketScreen.getInstance();
         mScreen.privateOffers.addItem(offer);
         mScreen.publicOffers.addItem(offer);
         mScreen.offerCount++;
      }
      
      public override function result(rmo:ClientRMO):void
      {
         super.result(rmo);
         Messenger.show(Localizer.string('Market', 'message.offerSubmited'), 
            Messenger.MEDIUM);
      }
   }
}