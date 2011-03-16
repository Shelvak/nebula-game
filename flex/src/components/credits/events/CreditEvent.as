package components.credits.events
{
   import flash.events.Event;
   
   public class CreditEvent extends Event
   {
      public static const ACCELERATE_CHANGE: String = 'selected_accelerate_changed';
      
      public function CreditEvent(type:String)
      {
         super(type);
      }
   }
}