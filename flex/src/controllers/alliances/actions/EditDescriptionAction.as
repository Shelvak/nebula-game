package controllers.alliances.actions
{
   import controllers.CommunicationAction;
   import controllers.GlobalFlags;
   
   import utils.remote.rmo.ClientRMO;
   
   /**
    * Edits alliance description
    *  
    * @author Jho
    * 
    */   
   public class EditDescriptionAction extends CommunicationAction
   {
      public override function result(rmo:ClientRMO):void
      {
         GlobalFlags.getInstance().lockApplication = false;
         ML.alliance.description = ML.alliance.newDescription;
      }
      
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         GlobalFlags.getInstance().lockApplication = false;
         ML.alliance.newDescription = ML.alliance.description;
      }
   }
}