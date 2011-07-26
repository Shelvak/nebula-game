package controllers.players.actions
{
   import controllers.CommunicationAction;
   import controllers.GlobalFlags;
   import controllers.Messenger;
   
   import utils.locale.Localizer;
   import utils.remote.rmo.ClientRMO;
   
   /**
    *	 Convert creds from VIP creds to normal creds.
    *	
    *	 Rate is determined by your VIP level. See Player#vip_conversion_rate
    *	
    *	 Invocation: by client
    *	
    *	 Parameters:
    *	 - amount (Fixnum): number of VIP creds to convert
    *	
    *	 Response: None
    *	 
    * @author Jho
    * 
    */   
   public class ConvertCredsAction extends CommunicationAction
   {
      public override function cancel(rmo:ClientRMO):void
      {
         GlobalFlags.getInstance().lockApplication = false;
         super.cancel(rmo);
      }
      
      public override function result(rmo:ClientRMO):void
      {
         GlobalFlags.getInstance().lockApplication = false;
         Messenger.show(Localizer.string('Credits', 'message.credsConverted'),
         Messenger.MEDIUM);
      }
   }
}