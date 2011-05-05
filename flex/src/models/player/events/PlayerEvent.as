package models.player.events
{
   import flash.events.Event;
   
   public class PlayerEvent extends Event
   {
      public static const SCIENTISTS_CHANGE: String = 'scientistsChanged';
      public static const CREDS_CHANGE: String = 'playerCredsChanged';
      
      public function PlayerEvent(type:String)
      {
         super(type);
      }
   }
}