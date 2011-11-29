package controllers.technologies.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import models.ModelLocator;
   import models.factories.TechnologyFactory;
   import models.parts.TechnologyUpgradable;
   import models.technology.Technology;

   /**
    * Used for accelerating technologies upgrade process
    */
   public class AccelerateAction extends CommunicationAction
   {
      public override function applyServerAction(cmd:CommunicationCommand):void
      {
         var temp:Technology = TechnologyFactory.fromObject(cmd.parameters.technology);
         var technology:Technology = ML.technologies.getTechnologyByType(temp.type);
         technology.upgradePart.stopUpgrade();
         technology.copyProperties(temp);
         if (technology.upgradeEndsAt != null)
         {
            technology.upgradePart.startUpgrade();
         }
         else
         {
            TechnologyUpgradable(technology.upgradePart).dispatchUpgradeFinishedEvent();
            ModelLocator.getInstance().resourcesMods.recalculateMods();
         }
         temp.cleanup();
      }
   }
}