package controllers.units
{
   import controllers.CommunicationCommand;
   
   public class UnitsCommand extends CommunicationCommand
   {
      public static const NEW: String = "newUnit";
      
      public static const UPDATE: String = "updateUnits";
      
      public static const ATTACK: String = "unitsAttack";
      
      public static const DEPLOY: String = "unitsDeploy";
      
      public static const LOAD: String = "unitsLoad";
      
      public static const UNLOAD: String = "unitsUnload";
      
      public static const SHOW: String = "unitsShow";
      
      public static const MOVE:String = "units|move";
      public static const MOVEMENT:String = "units|movement";
      public static const MOVEMENT_PREPARE:String = "units|movement_prepare";
      
      /**
       * Constructor. 
       */
      public function UnitsCommand(type:String, parameters:Object = null, fromServer:Boolean = false, eagerDispatch:Boolean = false)
      {
         super(type, parameters, fromServer, eagerDispatch);
      }
   }
}