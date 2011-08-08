package models.factories
{
   import models.BaseModel;
   import models.market.MarketOffer;

   public class MarketOfferFactory
   {
      public static function fromObject(data:Object) : MarketOffer
      {
         return BaseModel.createModel(MarketOffer, data);
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