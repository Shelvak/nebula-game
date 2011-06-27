package models.events
{
   import flash.events.Event;
   
   public class LocaleEvent extends Event
   {
      public static const BUNDLES_LOADED: String = 'localeBundlesLoaded';
      public function LocaleEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
      {
         super(type, bubbles, cancelable);
      }
   }
}