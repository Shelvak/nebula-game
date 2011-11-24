package controllers.market.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import models.market.MCMarketScreen;

   /**
    * Return average market rate for selling resource 1 -> resource 2.
    * 
    *  Invocation: by client
    * 
    *  Parameters:
    * - from_kind (Fixnum): resource kind you are offering
    * - to_kind (Fixnum): resource kind you are demanding
    * 
    * Response:
    * - avg_rate (Float): average market rate for that resource pair
    * 
    * def action_avg_rate 
    * @author Jho
    * 
    */
   public class AvgRateAction extends CommunicationAction
   {
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         MCMarketScreen.getInstance().avgRate = cmd.parameters.avgRate;
      }
   }
}