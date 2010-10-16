package components.movement.events
{
   import flash.events.Event;
   
   public class SquadronEvent extends Event
   {
      public static const SELECTED_CHANGE: String = 'selectedSquadronChanged';
      
      public function SquadronEvent(type:String)
      {
         super(type);
      }
   }
}