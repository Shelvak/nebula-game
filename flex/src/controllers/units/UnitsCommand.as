package controllers.units
{
   import controllers.CommunicationCommand;
   
   public class UnitsCommand extends CommunicationCommand
   {
      public static const NEW: String = "units|new";
      
      public static const UPDATE: String = "units|update";
      
      public static const ATTACK: String = "units|attack";
      
      public static const DEPLOY: String = "units|deploy";
      
      public static const HEAL: String = "units|heal";
      
      public static const LOAD: String = "units|load";
      
      public static const TRANSFER_RESOURCES: String = "units|transfer_resources";
      
      public static const UNLOAD: String = "units|unload";
      
      public static const SHOW: String = "units|show";
      
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