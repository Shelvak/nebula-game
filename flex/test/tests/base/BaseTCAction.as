package tests.base
{
   import com.developmentarc.core.actions.ActionDelegate;
   import com.developmentarc.core.utils.EventBroker;
   
   import controllers.CommunicationAction;
   
   import flash.errors.IllegalOperationError;
   
   import models.ModelLocator;
   
   
   public class BaseTCAction
   {
      protected var modelLoc:ModelLocator;
      protected var delegate:ActionDelegate;
      protected var action:CommunicationAction;
      
      
      public function BaseTCAction()
      {
         action = getAction();
         action.addCommand(getCommand());
         delegate = new ActionDelegate();
         delegate.addAction(action);
         modelLoc = ModelLocator.getInstance();
      }
      
      
      [After]
      public function tearDown() : void
      {
         modelLoc.reset();
         EventBroker.clearAllSubscriptions();
      }
      
      
      protected function getCommand() : String
      {
         throw new IllegalOperationError("This method is abstract");
      }
      
      
      protected function getAction() : CommunicationAction
      {
         throw new IllegalOperationError("This method is abstract");
      }
   }
}