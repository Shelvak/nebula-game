package globalevents
{
   import models.market.MarketOffer;

   public class GMarketEvent extends GlobalEvent
   {
      public static const OFFER_SELECTED: String = 'offerSelected';
      
      public var offer: MarketOffer;
      public function GMarketEvent(type:String, _offer: MarketOffer)
      {
         offer = _offer;
         super(type);
      }
   }
}