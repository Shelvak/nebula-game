package models.infoscreen.events
{
   import flash.events.Event;
   
   public class InfoScreenEvent extends Event
   {
      public static const MODEL_CHANGE: String = "infoModelChange";
      public static const MODEL_LEVEL_CHANGE: String = "infoModelLevelChange";
      public static const REFRESH_SELECTED_GUN: String = "refreshSelectedGun";
      public static const GUNS_CREATED: String = "gunsCreated";
      
      public function InfoScreenEvent(type:String)
      {
         super(type);
      }
   }
}