package controllers.alliances.actions
{
   import components.alliance.AllianceScreenM;
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.alliances.AlliancesErrorType;

   import models.notification.MTimedEvent;

   import utils.locale.Localizer;
   
   /**
    * Edits alliance properties
    *  
    * @author Jho
    * 
    */   
   public class EditAction extends CommunicationAction
   {
      private var allyName: String;
      public override function applyClientAction(cmd:CommunicationCommand):void
      {
         allyName = cmd.parameters.name;
         super.applyClientAction(cmd);
      }
      
      public override function applyServerAction(cmd:CommunicationCommand):void
      {
         if (cmd.parameters.error == AlliancesErrorType.NOT_UNIQUE)
         {
            new MTimedEvent(Localizer.string('Alliances','label.allyExists'));
         }
         else
         {
            AllianceScreenM.getInstance().alliance.name = allyName;
         }
      }
   }
}
