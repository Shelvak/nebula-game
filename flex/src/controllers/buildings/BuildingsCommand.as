package controllers.buildings
{
	import controllers.CommunicationCommand;
	
	
	
	
	/**
	 * Used for buildings sidebar.
	 */  
	public class BuildingsCommand extends CommunicationCommand
	{
		public static const NEW: String = "newBuilding";
      public static const UPGRADE: String = "upgradeBuilding";
      public static const ACTIVATE: String = "activateBuilding";
      public static const DEACTIVATE: String = "deactivateBuilding";
		
		/**
		 * Constructor. 
		 */
		public function BuildingsCommand  
			(type: String, parameters: Object = null, fromServer: Boolean = false)
		{
			super (type, parameters, fromServer);
		}
	}
}