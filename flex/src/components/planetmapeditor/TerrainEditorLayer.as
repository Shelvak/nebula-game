package components.planetmapeditor
{
   import com.developmentarc.core.utils.EventBroker;

   import components.map.planet.PlanetVirtualLayer;
   import components.map.planet.objects.IInteractivePlanetMapObject;
   import components.map.planet.objects.IPrimitivePlanetMapObject;

   import flash.events.KeyboardEvent;

   import flash.ui.Keyboard;

   import models.planet.MPlanetObject;

   import mx.collections.ArrayCollection;

   import mx.collections.ListCollectionView;


   public class TerrainEditorLayer extends PlanetVirtualLayer
   {
      internal static const ACTIVATION_KEY_CODE:int = Keyboard.CONTROL;

      private function activate(): void {
         objectsLayer.passOverMouseEventsTo(this);
      }

      private function deactivate(): void {

      }

      /* ################################ */
      /* ### KEYBOARD EVENTS HANDLERS ### */
      /* ################################ */

      override protected function addGlobalEventHandlers(): void {
         EventBroker.subscribe(KeyboardEvent.KEY_DOWN, keyboard_keyDownHandler);
         EventBroker.subscribe(KeyboardEvent.KEY_UP, keyboard_keyUpHandler);
      }

      override protected function removeGlobalEventHandlers(): void {
         EventBroker.unsubscribe(KeyboardEvent.KEY_DOWN, keyboard_keyDownHandler);
         EventBroker.unsubscribe(KeyboardEvent.KEY_UP, keyboard_keyUpHandler);
      }

      private function keyboard_keyDownHandler(event:KeyboardEvent): void {
         if (event.keyCode == ACTIVATION_KEY_CODE) {
            activate();
         }
      }

      private function keyboard_keyUpHandler(event:KeyboardEvent): void {
         if (event.keyCode == ACTIVATION_KEY_CODE) {
            deactivate();
         }
      }

      /* ############## */
      /* ### NO-OPS ### */
      /* ############## */

      override protected function get componentClass(): Class {
         return null;
      }

      override protected function get modelClass(): Class {
         return null;
      }

      override protected function get objectsList(): ListCollectionView {
         return new ArrayCollection();
      }

      override protected function removeAllObjects(): void {
      }

      override public function objectSelected(object: IInteractivePlanetMapObject): void {
      }

      override public function objectDeselected(object: IInteractivePlanetMapObject): void {
      }

      override public function addObject(object: MPlanetObject): void {
      }

      override public function objectRemoved(object: IPrimitivePlanetMapObject): void {
      }

      override public function openObject(object: IPrimitivePlanetMapObject): void {
      }
   }
}
