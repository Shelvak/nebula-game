package models.resource.events
{
   import flash.events.Event;
   
   public class ResourcesEvent extends Event
   {
      public static const RESOURCES_CHANGED: String = "resourceAmmountChanged";
      
      public static const STORAGE_CHANGED: String = "resourceStorageChanged";
      
      public static const RATE_CHANGED: String = "resourceRateChanged";
      
      public static const RATE_BOOST_CHANGED: String = "rateBoostChanged";
      
      public static const STORAGE_BOOST_CHANGED: String = "storageBoostChanged";
      
      public function ResourcesEvent(type:String)
      {
         super(type, false, false);
      }
   }
}