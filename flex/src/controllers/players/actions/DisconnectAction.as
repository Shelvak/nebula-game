package controllers.players.actions
{
   import components.popups.ErrorPopup;
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.screens.Screens;
   import controllers.screens.ScreensSwitch;
   
   import globalevents.GlobalEvent;
   
   import utils.Localizer;
   import utils.StringUtil;
   
   
   /**
    * Shows appropriate popupup when user gets disconnected (by initiative of a server).
    * This does not handle situations when connection is lost or can't be established.
    */
   public class DisconnectAction extends CommunicationAction
   {
      private var popup:ErrorPopup;
      
      override public function applyServerAction (cmd: CommunicationCommand) :void
      {
         var reason:String = cmd.parameters.reason;
         if (reason == null) return;
         reason = StringUtil.underscoreToCamelCaseFirstLower(reason);
         
         new GlobalEvent(GlobalEvent.APP_RESET);
         
         popup = new ErrorPopup ();
         popup.cancelButtonLabel = Localizer.string ("Popups", "label.ok");
         popup.showRetryButton = false;
         popup.closeHandler =
            function(cmd:String) : void
            {
               ScreensSwitch.getInstance().showScreen (Screens.LOGIN);
            };
         
         var message:String = Localizer.string("Popups", "message.disconnect." + reason); 
         if (message != null)
         {
            
            popup.message = message;
         }
         else
         {
            
            popup.message = Localizer.string("Popups", "message.disconnect.default");
         }
         
         var title:String = popup.title = Localizer.string("Popups", "title.disconnect." + reason);
         if (title != null)
         {
            popup.title = title;
         }
         else
         {
            popup.title = Localizer.string ("Popups", "title.disconnect.default");
         }
         
         popup.show();
         popup = null;
      }
   }
}