package controllers.players.actions
{
   import controllers.CommunicationAction;

   import models.notification.MTimedEvent;

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
      
      public override function result(rmo:ClientRMO):void
      {
         super.result(rmo);
         new MTimedEvent(Localizer.string('Credits', 'message.credsConverted'));
      }
   }
}