package components.popups
{
   import components.popups.skins.BasePopUpSkin;

   import flash.events.MouseEvent;

   import flashx.textLayout.formats.VerticalAlign;

   import models.ModelLocator;

   import mx.collections.ArrayCollection;
   import mx.events.FlexEvent;

   import spark.components.Button;
   import spark.components.Group;
   import spark.components.Panel;
   import spark.layouts.HorizontalAlign;
   import spark.layouts.HorizontalLayout;
   import spark.layouts.supportClasses.LayoutBase;

   import utils.datastructures.Collections;
   import utils.logging.Log;


   /**
    * Base popup class.
    */
   public class BasePopUp extends Panel
   {
      private function get popUpManager(): PopUpManager {
         return PopUpManager.getInstance();
      }

      /**
       * Reference to application-wide instance of <code>ModelLocator</code>.
       */
      protected static function get ML() : ModelLocator {
         return ModelLocator.getInstance();
      }
      
      
      public function BasePopUp() : void {
         super();
         setStyle("skinClass", BasePopUpSkin);
         addEventListener(MouseEvent.CLICK, this_clickHandler);
         addEventListener(FlexEvent.CREATION_COMPLETE, this_creationCompleteHandler);
      }
      
      private function this_creationCompleteHandler(event:FlexEvent) : void {
         popUpManager.centerPopUp(this);
      }
      
      /**
       * Shows this popup in the screen. 
       */      
      public function show() : void {
         popUpManager.addPopUp(this);
      }
      
      /**
       * Removes this popup from popup list in <code>PopupManager</code>.
       */
      public function close() : void {
         popUpManager.removePopUp(this);
      }
      
      
      /* ###################### */
      /* ### ACTION BUTTONS ### */
      /* ###################### */

      protected function get actionButtonsLayout(): LayoutBase {
         const layout:HorizontalLayout = new HorizontalLayout();
         layout.horizontalAlign = HorizontalAlign.RIGHT;
         layout.verticalAlign = VerticalAlign.MIDDLE;
         return layout;
      }
      
      /**
       * A list of all action buttons in this popup.
       */
      private var _actionButtons:ArrayCollection = new ArrayCollection();
      private function findActionButton(button:Button) : ActionButton {
         return Collections.findFirst(_actionButtons,
            function(actionButton:ActionButton) : Boolean {
               return actionButton.button === button;
            }
         );
      }
      
      /**
       * Use this to add any action buttons (those are the buttons at the bottom of the popup and
       * will do something usefull when user clicks on them; most of the time the popup will be closed
       * when one of those buttons is clicked) to the popup. Buttons are ordered the same way as you
       * add them.
       * 
       * @param button an instance of a button.
       * @param clickHandler click handler to invoke when the user clicks on this button. The handler will be
       * passed the button as the only argument. Can be <code>null</code>.
       * @param closeOnClick if <code>true</code>, popup will be closed when the button is clicked.
       */
      public function addActionButton(button:Button,
                                      clickHandler:Function,
                                      closeOnClick:Boolean = true) : void {
         _actionButtons.addItem(new ActionButton(button, clickHandler, closeOnClick));
         if (grpActionButtons != null)
            grpActionButtons.addElement(button);
      }
      
      [SkinPart(required="true")]
      /**
       * Container for all action buttons.
       */
      public var grpActionButtons:Group;
      
      protected override function partAdded(partName:String, instance:Object) : void {
         super.partAdded(partName, instance);
         if (instance == grpActionButtons) {
            grpActionButtons.layout = actionButtonsLayout;
            for each (var actionButton:ActionButton in _actionButtons) {
               grpActionButtons.addElement(actionButton.button);
            }
         }
      }
      
      private function this_clickHandler(event:MouseEvent) : void {
         if (event.target is Button) {
            var actionButton:ActionButton = findActionButton(Button(event.target));
            if (actionButton != null) {
               if (actionButton.closeHandler != null) {
                  try {
                     actionButton.closeHandler.call(null, actionButton.button);
                  }
                  catch (err:Error) {
                     Log.getMethodLogger(BasePopUp, "this_clickHandler").error(
                        "Invoking handler of an action button {0} failed with the error: {1}",
                        actionButton.button, err.message
                     );
                     throw err;
                  }
               }
               if (actionButton.closeOnClick)
                  close();
            }
         }
      }
   }
}


import spark.components.Button;


class ActionButton
{
   public function ActionButton(button:Button, closeHandler:Function, closeOnClick:Boolean) {
      this.button       = button;
      this.closeHandler = closeHandler;
      this.closeOnClick = closeOnClick;
   }
   public var button:Button;
   public var closeHandler:Function;
   public var closeOnClick:Boolean;
}