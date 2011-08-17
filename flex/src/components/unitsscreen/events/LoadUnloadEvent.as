package components.unitsscreen.events
{
   import flash.events.Event;
   
   public class LoadUnloadEvent extends Event
   {
      public static const SELECTED_VOLUME_CHANGED: String = 'selectedVolumeChanged';
      public function LoadUnloadEvent(type:String)
      {
         super(type);
      }
   }
}