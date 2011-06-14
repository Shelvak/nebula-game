package utils.assets.events
{
   import flash.events.Event;
   
   
   public class ImagePreloaderEvent extends Event
   {
      /**
       * Dispatched each 5 SWFs are unpacked by the ImagePreloader.
       * 
       * @eventType unpackProgress
       */
      public static const UNPACK_PROGRESS:String = "unpackProgress";
      
      
      public function ImagePreloaderEvent(type:String)
      {
         super(type);
      }
   }
}