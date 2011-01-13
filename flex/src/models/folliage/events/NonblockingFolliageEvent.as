package models.folliage.events
{
   import flash.events.Event;
   
   public class NonblockingFolliageEvent extends Event
   {
      public static const SWING:String = "swingNonblockingFolliage";
      
      
      public function NonblockingFolliageEvent(type:String)
      {
         super(type, false, false);
      }
   }
}