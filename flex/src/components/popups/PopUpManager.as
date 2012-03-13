package components.popups
{
   import flash.display.DisplayObject;

   import mx.core.FlexGlobals;
   import mx.managers.PopUpManager;

   import utils.SingletonFactory;


   public class PopUpManager
   {
      public static function getInstance(): components.popups.PopUpManager {
         return SingletonFactory.getSingletonInstance(
            components.popups.PopUpManager
         );
      }

      private const OPEN_POPUPS: Array = new Array();

      public function bringToFront(popUp: BasePopUp): void {
         mx.managers.PopUpManager.bringToFront(popUp);
      }

      public function centerPopUp(popUp: BasePopUp): void {
         mx.managers.PopUpManager.centerPopUp(popUp);
      }

      public function addPopUp(popUp: BasePopUp, modal: Boolean = true): void {
         OPEN_POPUPS.push(popUp);
         mx.managers.PopUpManager.addPopUp(
            popUp, DisplayObject(FlexGlobals.topLevelApplication), modal
         );
      }

      public function removePopUp(popUp: BasePopUp): void {
         const idx: int = OPEN_POPUPS.indexOf(popUp);
         OPEN_POPUPS.splice(idx, 1);
         mx.managers.PopUpManager.removePopUp(popUp);
      }

      public function reset(): void {
         for each (var popup: BasePopUp in OPEN_POPUPS.slice()) {
            removePopUp(popup);
         }
      }
   }
}
