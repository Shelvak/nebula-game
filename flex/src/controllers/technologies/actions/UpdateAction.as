package controllers.technologies.actions
	
{
	
	import controllers.CommunicationAction;
	import controllers.CommunicationCommand;
	
	import globalevents.GTechnologiesEvent;
	
	import models.factories.TechnologyFactory;
	import models.technology.Technology;
	
	
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
			new GTechnologiesEvent(GTechnologiesEvent.UPDATE_APPROVED);
		}
		
		
	}
}