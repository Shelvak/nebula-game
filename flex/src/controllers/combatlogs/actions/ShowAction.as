package controllers.combatlogs.actions
{
   
   import com.adobe.serialization.json.JSON;
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.ui.NavigationController;
   
   import utils.PropertiesTransformer;
      
   public class ShowAction extends CommunicationAction
   {
      /**
       * @private
       */
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         NavigationController.getInstance().showBattle(
            PropertiesTransformer.objectToCamelCase(JSON.decode(cmd.parameters.log)));
      }
   }
}