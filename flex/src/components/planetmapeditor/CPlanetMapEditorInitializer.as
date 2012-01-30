package components.planetmapeditor
{
   import com.developmentarc.core.utils.EventBroker;

   import globalevents.GlobalEvent;

   import mx.graphics.SolidColor;

   import spark.components.Group;
   import spark.primitives.Rect;


   public class CPlanetMapEditorInitializer extends Group
   {
      public function CPlanetMapEditorInitializer() {
         EventBroker.subscribe(
            GlobalEvent.INITIALIZE_MAP_EDITOR, global_initializeMapEditor
         );
         mouseEnabled = false;
         left = 0;
         right = 0;
         top = 0;
         bottom = 0;
      }

      private function global_initializeMapEditor(event:GlobalEvent): void {
         EventBroker.unsubscribe(
            GlobalEvent.INITIALIZE_MAP_EDITOR, global_initializeMapEditor
         )

         const background:Rect = new Rect();
         background.fill = new SolidColor(0x000000);
         background.percentHeight = 100;
         background.percentWidth = 100;
         addElement(background);
         addElement(new CPlanetMapEditorScreen());
      }
   }
}
