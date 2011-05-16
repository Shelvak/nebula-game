package controllers.alliances.actions
{
   import controllers.CommunicationAction;
   import controllers.GlobalFlags;
   
   import utils.remote.rmo.ClientRMO;
   
   /**
    * Edits alliance properties
    *  
    * @author Jho
    * 
    */   
   public class EditAction extends CommunicationAction
   {
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