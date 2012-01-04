package components.quests.slides
{
   import flash.events.Event;


   public class CSlideEvent extends Event
   {
      public static const MODEL_CHANGE:String = "modelChange";

      public function CSlideEvent(type:String) {
         super(type);
      }
   }
}
