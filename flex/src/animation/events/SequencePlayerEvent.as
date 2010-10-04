package animation.events
{
   import flash.events.Event;
   
   public class SequencePlayerEvent extends Event
   {
      /**
       * Dispatched by <code>SequencePlayer</code> when sequence have been played back
       * from start frame to finish frame and player has reset itself.
       * 
       * @eventType sequencePlaybackComplete
       */
      public static const SEQUENCE_COMPLETE:String = "sequencePlaybackComplete";
      
      
      public function SequencePlayerEvent(type:String)
      {
         super(type, false, false);
      }
   }
}