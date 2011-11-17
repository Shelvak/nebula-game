package controllers.galaxies.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import utils.DateUtil;
   /**
    * Used for notifying client about started apocalypse
    */
   public class ApocalypseAction extends CommunicationAction
   {
      public override function applyServerAction(cmd: CommunicationCommand): void {
         ML.latestGalaxy.apocalypseStarted = DateUtil.parseServerDTF(
                 cmd.parameters.apocalypseStarted);
      }
   }
}