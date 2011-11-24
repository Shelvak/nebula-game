package models.factories
{
   import models.market.MarketOffer;

   import utils.Objects;

   public class MarketOfferFactory
   {
      public static function fromObject(data:Object) : MarketOffer
      {
         return Objects.create(MarketOffer, data);
      }
      
      public static function fromArray(data: Array) : Array
      {
         var target: Array = [];
         for each (var rawOffer: Object in data)
         {
            target.push(fromObject(rawOffer));
         }
         return target;
      }
   }
}