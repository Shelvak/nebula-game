package controllers.routes.actions
{
   import components.popups.ActionConfirmationPopup;
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import models.BaseModel;
   
   import spark.components.Button;
   import spark.components.Label;
   
   import utils.locale.Localizer;
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Stops the squadron in its current position.
    * 
    * <p>You can either pass <code>MSquadron</code> or <code>MRoute</code> as <code>cmd.parameters</code>
    * for this controller but <code>MSquadron</code> should be preffered at all times.</p>
    */
   public class DestroyAction extends CommunicationAction
   {
      public override function applyClientAction(cmd:CommunicationCommand):void
      {
         var model:BaseModel = BaseModel(cmd.parameters);
         {
            var popUp: ActionConfirmationPopup = new ActionConfirmationPopup();
            popUp.confirmButtonLabel = Localizer.string('Popups', 'label.yes');
            popUp.cancelButtonLabel = Localizer.string('Popups', 'label.no');
            var lbl: Label = new Label();
            lbl.minWidth = 300;
            lbl.text = Localizer.string('Popups', 'message.stopFleet');
            popUp.addElement(lbl);
            popUp.title = Localizer.string('Popups', 'title.stopFleet');
            popUp.confirmButtonClickHandler = function (button: Button = null): void
            {
               sendMessage(new ClientRMO({"id": model.id}, model));
            };
            popUp.show();
         }
      }
   }
}