package models.market
{
   import components.market.events.MarketEvent;
   
   import config.Config;
   
   import flash.events.EventDispatcher;
   
   import models.ModelsCollection;
   import models.building.Building;
   
   import utils.SingletonFactory;

   public class MCMarketScreen extends EventDispatcher
   {
      public static function getInstance(): MCMarketScreen
      {
         return SingletonFactory.getSingletonInstance(MCMarketScreen);
      }
      
      [Bindable]
      public var currentTab: String = 'left';
      
      [Bindable]
      public var publicOffers: ModelsCollection;
      
      [Bindable]
      public var privateOffers: ModelsCollection;
      
      [Bindable]
      public var market: Building;
      
      public var planetId: int;
      
      [Bindable]
      public var freeSlots: int;
      
      private var _avgRate: Number;
      
      private var _offerCount: int;
      
      public function set offerCount(value: int): void
      {
         _offerCount = value;
         freeSlots = Math.max(0, (Config.getMaxMarketOffers() - _offerCount));
         dispatchOfferCountChangeEvent();
      }
      
      [Bindable (event="offerCountChange")]
      public function get offerCount(): int
      {
         return _offerCount;
      }
      
      public function set avgRate(value: Number): void
      {
         _avgRate = value;
         dispatchAvgRateChangeEvent();
      }
      
      [Bindable (event="avgRateChange")]
      public function get avgRate(): Number
      {
         return _avgRate;
      }
      
      public function resetScreen(): void
      {
         if (hasEventListener(MarketEvent.RESET_FILTER))
         {
            dispatchEvent(new MarketEvent(MarketEvent.RESET_FILTER));
         } 
      }
      
      private function dispatchAvgRateChangeEvent(): void
      {
         if (hasEventListener(MarketEvent.AVG_RATE_CHANGE))
         {
            dispatchEvent(new MarketEvent(MarketEvent.AVG_RATE_CHANGE));
         }
      }
      
      private function dispatchOfferCountChangeEvent(): void
      {
         if (hasEventListener(MarketEvent.OFFER_COUNT_CHANGE))
         {
            dispatchEvent(new MarketEvent(MarketEvent.OFFER_COUNT_CHANGE));
         }
      }
   }
}