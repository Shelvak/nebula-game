package models.events
{
   import flash.events.Event;
   
   public class ScreensSwitchEvent extends Event
   {
      /**
       * Dispatched when screen switching operation has finished creating
       * new screen
       * 
       * @eventType newScreenCreated
       */
      public static const SCREEN_CREATED:String = "newScreenCreated";
      
      public function ScreensSwitchEvent(type:String)
      {
         super(type, false, false);
      }
   }
}