package components.planetmapeditor.events
{
   import flash.events.Event;


   public class MPlanetMapEditorEvent extends Event
   {
      public static const WIDTH_CHANGE: String = "widthChange";
      public static const HEIGHT_CHANGE: String = "heightChange";
      public static const NAME_CHANGE: String = "nameChange";
      public static const TERRAIN_CHANGE: String = "terrainChange";

      public function MPlanetMapEditorEvent(type:String) {
         super(type);
      }
   }
}
