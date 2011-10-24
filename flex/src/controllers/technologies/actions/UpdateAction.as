package controllers.technologies.actions
{
	
	import controllers.CommunicationAction;
	import controllers.CommunicationCommand;
	import controllers.GlobalFlags;
	
	import models.factories.TechnologyFactory;
	import models.technology.Technology;
	
	import utils.remote.rmo.ClientRMO;
	
	
	/**
	 * Used for updating technology
	 */
	public class UpdateAction extends CommunicationAction
	{	
		
		override public function applyServerAction
			(cmd: CommunicationCommand) :void{
			var temp:Technology = TechnologyFactory.fromObject(cmd.parameters.technology);
         var technology:Technology = ML.technologies.getTechnologyByType(temp.type);
         technology.upgradePart.stopUpgrade();
         technology.copyProperties(temp);
         technology.upgradePart.startUpgrade();
         temp.cleanup();
		}
      
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      public override function result(rmo:ClientRMO):void
      {
         GlobalFlags.getInstance().lockApplication = false;
      }
	}
}