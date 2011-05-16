package models.planet
{
   import config.Config;
   
   import models.resource.ResourceType;
   
   import utils.DateUtil;

   public class MBoost
   {
      private function refreshResourceRateBoost(): void
      {
         if (rateBoostEndsAt && rateBoostEndsAt.time > lastUpdate.time)
         {
            rateTime = DateUtil.secondsToHumanString(
               (rateBoostEndsAt.time - lastUpdate.time)/1000);
         }
         else
         {
            rateTime = null;
         }
      }
      private function refreshResourceStorageBoost(): void
      {
         if (storageBoostEndsAt && storageBoostEndsAt.time > lastUpdate.time)
         {
            storageTime = DateUtil.secondsToHumanString(
               (storageBoostEndsAt.time - lastUpdate.time)/1000);
         }
         else
         {
            storageTime = null;
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
      
      public function getRateBoost(): Number
      {
         return rateTime?1+(Config.getPlanetBoost()/100):1;
      }
      
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
   }
}