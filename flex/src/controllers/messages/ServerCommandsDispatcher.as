package controllers.messages
{
   import com.developmentarc.core.actions.commands.AbstractCommand;
   import com.developmentarc.core.utils.SingletonFactory;
   
   import flash.utils.getDefinitionByName;
   
   import utils.StringUtil;
   import utils.remote.rmo.ServerRMO;
   
   
   
   
   /**
    * Responsible for dispatching right commands with right parameters for
    * messages received from the server.
    */
   public class ServerCommandsDispatcher
   {
      public static function getInstance() : ServerCommandsDispatcher
      {
         return SingletonFactory.getSingletonInstance(ServerCommandsDispatcher);
      }
      
      
      /**
       * Dispatches appropriate commands with appropriate parameters for a
       * given <code>ServerRMO</code>.
       * 
       * @param rmo instance of <code>ServerRMO</code> of just received message
       * for which appropriate command must be dispatched.
       */
      public function dispatchCommand (rmo: ServerRMO) :void
      {
         var cmdPackage: String = "controllers." + rmo.controller;
            
         // First letter of the class name must be in upper-case
         var cmdName: String = StringUtil.firstToUpperCase(rmo.controller) + "Command";
         
         try {
            var command: Class = Class (getDefinitionByName (
               cmdPackage + "." + cmdName
            ));
         }
         // Ignore unsupported controllers from server.
         catch (e: ReferenceError)
         {
            trace ("Unsupported command form server: " + cmdName);
            return;
         }
         
         // Ignore unsupported actions from server.
         if (!command [StringUtil.camelCaseToUnderscore(rmo.action).toUpperCase()])
         {
            trace (
               "Unsupported action form server: " +
               cmdName + "." + rmo.action.toUpperCase ()
            );
            return;
         }
         
         AbstractCommand (
            new command (
               command [StringUtil.camelCaseToUnderscore(rmo.action).toUpperCase()],
               rmo.parameters,
               true
            )
         ).dispatch ();
      }
   }
}