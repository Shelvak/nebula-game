package controllers.buildings
{
	import controllers.CommunicationCommand;
	
	
	
	
	/**
	 * Used for buildings sidebar.
	 */  
	public class BuildingsCommand extends CommunicationCommand
	{
		public static const NEW: String = "buildings|new";
      public static const UPGRADE: String = "buildings|upgrade";
      public static const ACTIVATE: String = "buildings|activate";
      public static const DEACTIVATE: String = "buildings|deactivate";
		
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