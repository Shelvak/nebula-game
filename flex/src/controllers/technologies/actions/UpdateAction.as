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
			var temp: Technology = TechnologyFactory.fromObject(cmd.parameters.technology);
			ML.technologies.getTechnologyByType(temp.type).upgradePart.stopUpgrade();
			ML.technologies.getTechnologyByType(temp.type).copyProperties(temp);
			ML.technologies.getTechnologyByType(temp.type).upgradePart.startUpgrade();
			new GTechnologiesEvent(GTechnologiesEvent.UPDATE_APPROVED);
		}
		
		
	}
}