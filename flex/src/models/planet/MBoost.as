package models.planet
{
   import config.Config;
   
   import flash.events.EventDispatcher;
   
   import models.resource.ResourceType;
   import models.resource.events.ResourcesEvent;
   
   import utils.DateUtil;

   public class MBoost extends EventDispatcher
   {
      private function refreshResourceRateBoost(): void
      {
         if (rateBoostEndsAt && rateBoostEndsAt.time > lastUpdate.time)
         {
            rateTime = DateUtil.secondsToHumanString(
               (rateBoostEndsAt.time - lastUpdate.time)/1000);
            checkRateState();
         }
         else
         {
            rateTime = null;
            checkRateState();
         }
      }
      private function refreshResourceStorageBoost(): void
      {
         if (storageBoostEndsAt && storageBoostEndsAt.time > lastUpdate.time)
         {
            storageTime = DateUtil.secondsToHumanString(
               (storageBoostEndsAt.time - lastUpdate.time)/1000);
            checkStorageState();
         }
         else
         {
            storageTime = null;
            checkStorageState();
         }
      }
      
      private var storageOn: Boolean = false;
      private var rateOn: Boolean = false;
      
      private function checkStorageState(): void
      {
         if (storageOn && storageTime == null)
         {
            storageOn = false;
            dispatchStorageBoostChangeEvent();
         }
         else if (!storageOn && storageTime != null)
         {
            storageOn = true;
            dispatchStorageBoostChangeEvent();
         }
      }
      
      private function checkRateState(): void
      {
         if (rateOn && rateTime == null)
         {
            rateOn = false;
            dispatchRateBoostChangeEvent();
         }
         else if (!rateOn && rateTime != null)
         {
            rateOn = true;
            dispatchRateBoostChangeEvent();
         }
      }
      
      private var lastUpdate: Date;
      
      public function refreshBoosts(): void
      {
         lastUpdate = new Date();
         refreshResourceRateBoost();
         refreshResourceStorageBoost();
      }
      [Bindable]
      public var rateTime: String = null;
      [Bindable]
      public var storageTime: String = null;
      
      [Bindable (event="rateBoostChanged")]
      public function getRateBoost(): Number
      {
         return rateTime?1+(Config.getPlanetBoost()/100):1;
      }
      
      [Bindable (event="storageBoostChanged")]
      public function getStorageBoost(): Number
      {
         return storageTime?1+(Config.getPlanetBoost()/100):1;
      }
      
      /**
       * Time when resource rate boost will end.
       */
      public var rateBoostEndsAt:Date = null;
      /**
       * Time when resource storage boost will end.
       */
      public var storageBoostEndsAt:Date = null;
      
      private function dispatchStorageBoostChangeEvent(): void
      {
         if (hasEventListener(ResourcesEvent.STORAGE_BOOST_CHANGED))
         {
            dispatchEvent(new ResourcesEvent(ResourcesEvent.STORAGE_BOOST_CHANGED));
         }
      }
      
      private function dispatchRateBoostChangeEvent(): void
      {
         if (hasEventListener(ResourcesEvent.RATE_BOOST_CHANGED))
         {
            dispatchEvent(new ResourcesEvent(ResourcesEvent.RATE_BOOST_CHANGED));
         }
      }
   }
}