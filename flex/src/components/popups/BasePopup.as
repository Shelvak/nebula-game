package components.popups
{
   import controllers.ui.GameCursorManager;
   
   import flash.events.MouseEvent;
   
   import models.ModelLocator;
   
   import mx.core.FlexGlobals;
   import mx.managers.PopUpManager;
   
   import spark.components.Application;
   import spark.components.Button;
   import spark.components.Panel;
   
   
   
   
   /**
    * Base popup class.
    */
   public class BasePopup extends Panel
   {
      private static const application: Application =
         FlexGlobals.topLevelApplication as Application;
      
      
      /**
       * Shows given type of popup in the screen.
       */      
      public static function show (popupClass: Class, closeHandler: Function) :void
      {
         var popup: BasePopup = new popupClass () as BasePopup;
         popup.closeHandler = closeHandler;
         popup.show ();
      }
      
      
      /**
       * Function that is calle when a popup is closed. An object is passed
       * containing all necessary parameters for the function. See
       * concrete classes for the details of those parameters. 
       */      
      public var closeHandler: Function = null;
      
      
      private var _ML: ModelLocator = ModelLocator.getInstance();
      /**
       * Reference to application-wide instance of <code>ModelLocator</code>
       * for all components extending this one.
       */
      protected function get ML () :ModelLocator
      {
         return _ML;
      }
      
      
      /**
       * Shows this popup in the screen. 
       */      
      public function show () :void
      {
         PopUpManager.addPopUp (this, application, true);
         PopUpManager.centerPopUp (this);
      }
      
      
      /**
       * Removes this popup from popup list in <code>PopupManager</code> and
       * calls closeHandler if command is provided.
       * 
       * @param command Will be used as argument for a close handler.
       */ 
      public function close (command :String = null) :void
      {
         PopUpManager.removePopUp (this);
         if (command && closeHandler != null)
         {
            closeHandler (command);
         }
      }
      
      
      
      
      /**
       * Constructor.
       */ 
      public function BasePopup ()
      {
         super ();
         width = 320;
         height = 240;
         
         addEventListener (MouseEvent.CLICK, closePopup);
//         addEventListener(MouseEvent.MOUSE_OVER, GameCursorManager.application_mouseOverHandler);
//         addEventListener(MouseEvent.MOUSE_OUT, GameCursorManager.application_mouseOutHandler);
      }
      
      
      private function closePopup (event: MouseEvent) :void
      {
         // Close popup if only a button was clicked.
         if (event.target is Button)
         {
            close ();
         }
      }
   }
}