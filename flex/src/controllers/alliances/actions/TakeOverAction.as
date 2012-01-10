package controllers.alliances.actions
{
   import controllers.CommunicationAction;


   /**
    * Takes over alliance control. You can only do this if:
    *
    * <ul>
    *    <li>You are a member of that alliance.</li>
    *    <li>Owner has not connected for some time.</li>
    *    <li>You have sufficient alliance technology level.</li>
    * <ul/>
    */
   public class TakeOverAction extends CommunicationAction
   {
   }
}
