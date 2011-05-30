package models.time.events
{
   import flash.events.Event;
   
   
   public class MTimeEventEvent extends Event
   {
      /**
       * Dispatched when <code>models.time.IMTimeEvent.hasOccured</code> property changes.
       * 
       * @eventType hasOccuredChange
       * 
       * @see models.time.IMTimeEvent#hasOccured
       */
      public static const HAS_OCCURED_CHANGE:String = "hasOccuredChange";
      
      
      /**
       * Dispatched when <code>models.time.IMTimeEvent.occuresIn</code> property changes.
       * 
       * @eventType occuresInChange
       * 
       * @see models.time.IMTimeEvent#occuresIn
       */
      public static const OCCURES_IN_CHANGE:String = "occuresInChange";
      
      
      /**
       * Dispatched when <code>models.time.IMTimeEvent.occuresAt</code> property changes.
       * 
       * @eventType occuresAtChange
       * 
       * @see models.time.IMTimeEvent#occuresAt
       */
      public static const OCCURES_AT_CHANGE:String = "occuresAtChange";
      
      
      public function MTimeEventEvent(type:String)
      {
         super(type);
      }
   }
}