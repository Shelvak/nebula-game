package components.planetmapeditor
{
   import com.developmentarc.core.utils.EventBroker;

   import components.map.planet.PlanetVirtualLayer;

   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;


   public class MapEditorLayer extends PlanetVirtualLayer
   {
      private static const ACTIVATION_KEY_CODE: int = Keyboard.CONTROL;

      override public function handleMouseEvent(event: MouseEvent): void {
         switch (event.type) {
            case MouseEvent.MOUSE_OVER:
               mouseOverHandler(event);
               break;

            case MouseEvent.MOUSE_MOVE:
               mouseMoveHandler(event);
               break;

            case MouseEvent.CLICK:
               clickHandler(event);
               break;
         }
      }

      protected function mouseOverHandler(event: MouseEvent): void {
      }

      protected function mouseMoveHandler(event: MouseEvent): void {
      }

      protected function clickHandler(event: MouseEvent): void {
      }

      override protected function addGlobalEventHandlers(): void {
         EventBroker.subscribe(KeyboardEvent.KEY_DOWN, keyboard_keyDownHandler);
         EventBroker.subscribe(KeyboardEvent.KEY_UP, keyboard_keyUpHandler);
      }

      override protected function removeGlobalEventHandlers(): void {
         EventBroker.unsubscribe(KeyboardEvent.KEY_DOWN, keyboard_keyDownHandler);
         EventBroker.unsubscribe(KeyboardEvent.KEY_UP, keyboard_keyUpHandler);
      }

      private function keyboard_keyDownHandler(event: KeyboardEvent): void {
         if (event.keyCode == ACTIVATION_KEY_CODE) {
            activationKeyDown();
         }
      }

      private function keyboard_keyUpHandler(event: KeyboardEvent): void {
         if (event.keyCode == ACTIVATION_KEY_CODE) {
            activationKeyUp();
         }
      }

      protected function activationKeyDown(): void {

      }

      protected function activationKeyUp(): void {

      }
   }
}
