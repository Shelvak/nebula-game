package models.events
{
   import flash.events.Event;
   
   public class StartupEvent extends Event
   {
      public static const CHECKSUMS_DOWNLOADED: String = "checksumsDownloaded";
      public function StartupEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
      {
         super(type, bubbles, cancelable);
      }
   }
}