package controllers.routes
{
   import controllers.CommunicationCommand;
   
   public class RoutesCommand extends CommunicationCommand
   {
      /**
       * @see controllers.routes.actions.IndexAction
       */
      public static const INDEX:String = "routes|index";
      
      /**
       * @see controllers.routes.actions.DestroyAction
       */
      public static const DESTROY:String = "routes|destroy";
      
      
      public function RoutesCommand(type:String,
                                    parameters:Object = null,
                                    fromServer:Boolean = false,
                                    eagerDispatch:Boolean = false)
      {
         super(type, parameters, fromServer, eagerDispatch);
      }
   }
}