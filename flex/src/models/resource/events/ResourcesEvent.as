package models.resource.events
{
   import flash.events.Event;
   
   public class ResourcesEvent extends Event
   {
      public static const RESOURCES_CHANGED: String = "resourceAmmountChanged";
      
      public static const STORAGE_CHANGED: String = "resourceStorageChanged";
      
      public static const RATE_CHANGED: String = "resourceRateChanged";
      
      public function ResourcesEvent(type:String)
      {
         super(type, false, false);
      }
   }
}