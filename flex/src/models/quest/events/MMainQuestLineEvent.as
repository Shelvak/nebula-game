package models.quest.events
{
   import flash.events.Event;


   public class MMainQuestLineEvent extends Event
   {
      public static const CURRENT_PRESENTATION_CHANGE:String = "currentPresentationChange";
      public static const SHOW_BUTTON_CHANGE:String = "showButtonChange";

      public function MMainQuestLineEvent(type:String) {
         super(type);
      }
   }
}
