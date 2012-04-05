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
      public static const SELF_DESTRUCT: String = "buildings|self_destruct";
      public static const ACTIVATE: String = "buildings|activate";
      public static const DEACTIVATE: String = "buildings|deactivate";
      public static const REPAIR: String = "buildings|repair";
      public static const ACTIVATE_OVERDRIVE: String = "buildings|activate_overdrive";
      public static const DEACTIVATE_OVERDRIVE: String = "buildings|deactivate_overdrive";
      public static const CANCEL_CONSTRUCTOR: String = "buildings|cancel_constructor";
      public static const CANCEL_UPGRADE: String = "buildings|cancel_upgrade";
      public static const ACCELERATE_CONSTRUCTOR: String = "buildings|accelerate_constructor";
      public static const ACCELERATE_UPGRADE: String = "buildings|accelerate_upgrade";
      public static const SET_BUILD_IN_2ND_FLANK: String = "buildings|set_build_in_2nd_flank";
      public static const SET_BUILD_HIDDEN: String = "buildings|set_build_hidden";
      public static const SHOW_GARRISON: String = "buildings|show_garrison";
      public static const SHOW_GARRISON_GROUPS: String = "buildings|show_garrison_groups";
      public static const TRANSPORT_RESOURCES: String = "buildings|transport_resources";
      
      
      /**
       * @see controllers.buildings.actions.MoveAction
       */
      public static const MOVE:String = "buildings|move";
		
      
		public function BuildingsCommand(type:String,
                                       parameters:Object = null,
                                       fromServer:Boolean = false)
		{
			super(type, parameters, fromServer);
		}
	}
}