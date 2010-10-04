package models.battle.events
{
   import flash.events.Event;
   
   import models.BaseModel;
   
   public class ParticipantEvent extends Event
   {
      public static const HP_CHANGE: String = 'actualHpChanged';
      
      public function ParticipantEvent(type:String)
      {
         super(type, false, false);
      }
   }
}