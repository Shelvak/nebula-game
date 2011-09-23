package controllers.alliances.actions
{
   import components.alliance.AllianceScreenM;
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.Messenger;
   import controllers.alliances.AlliancesErrorType;
   
   import utils.locale.Localizer;
   import utils.remote.rmo.ClientRMO;
   
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
            Messenger.show(Localizer.string('Alliances','label.allyExists'), Messenger.SHORT);
         }
         else
         {
            AllianceScreenM.getInstance().alliance.name = allyName;
         }
      }
      
      public override function result(rmo:ClientRMO):void
      {
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}