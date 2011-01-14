package controllers
{
   import controllers.messages.MessagesProcessor;
   
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   
   import utils.remote.IResponder;
   import utils.remote.rmo.ClientRMO;
   
   
   
   /**
    * Actions that include sending messages to the server and receiving responses and acting
    * accordingly to them should extend this class.
    */
   public class CommunicationAction extends BaseAction implements IResponder
   {
      /**
       * A command currently beeing processed.
       */
      protected var currentCommand:CommunicationCommand;
      
      
      /**
       * Override this if your action needs to do anything when a response message has been received from
       * the server. 
       */
      public function result () :void
      {
      }
      
      
      /**
       * Override this if the default behaviour does not fit: this method calls
       * <code>applyClientAction()</code> and <code>applyServerAction</code> methods depending on the
       * command's <code>fromServer</code> property's value.
       * 
       * @param command Instance of <code>BaseCommand</code>.
       * 
       * @see controllers.BaseCommand
       */
      public override function applyAction(command:Event) :void
      {
         var cmd:CommunicationCommand = CommunicationCommand(command);
         currentCommand = cmd;
         if(cmd.fromServer)
         {
            applyServerAction(cmd);
         }
         else
         {
            applyClientAction(cmd);
         }
      }
      
      
      /**
       * Sends a message to a server (does not set model property on ClientRMO). Override if this is not
       * correct behaviour. This method will be called by <code>applyAction()</code> if command's
       * <code>formServer</code> property's value is <b>false</b>.
       */
      public function applyClientAction(cmd:CommunicationCommand) : void
      {
         sendMessage(new ClientRMO(cmd.parameters));
      } 
      
      
      /**
       * This method will be called by <code>applyAction()</code> if command's <code>formServer</code>
       * property's value is <b>true</b>. This is an abstract method. You must override it.
       */
      public function applyServerAction (cmd: CommunicationCommand) :void
      {
         throw new IllegalOperationError (
            this + ": you must override applyServerAction() method."
         );
      }
      
      
      /**
       * This method simlifies sending messages to the server. You only need to pass a <code>ClientRMO</code>
       * object: message will be dispached for you by this method. Also action and responder properties will
       * be set <strong>if they have not been set prior</strong> calling this method.
       */
      protected function sendMessage(rmo:ClientRMO) :void
      {
         if (rmo.action == null)
         {
            rmo.action = currentCommand.type;
         }
         if (rmo.responder == null)
         {
            rmo.responder = this;
         }
         if (rmo.model)
         {
            rmo.model.pending = true;
         }
         MessagesProcessor.getInstance().sendMessage(rmo);
      }
   }
}