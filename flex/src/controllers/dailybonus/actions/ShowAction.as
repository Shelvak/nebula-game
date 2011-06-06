package controllers.dailybonus.actions
{
   
   import components.dailybonus.DailyBonusComp;
   import components.popups.ActionConfirmationPopup;
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.dailybonus.DailyBonusCommand;
   
   import models.Reward;
   import models.solarsystem.MSSObject;
   
   import mx.collections.ArrayCollection;
   
   import spark.components.Button;
   
   import utils.locale.Localizer;
   
   public class ShowAction extends CommunicationAction
   {
      
      // Get todays reward for this player. Raises error if reward is already
      // taken.
      //
      // Invocation: by server
      //
      // Parameters: None
      //
      // Response:
      // - bonus (Hash): Rewards//as_json
      //
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         var bonus: Reward = new Reward(cmd.parameters.bonus);
         var popUp: ActionConfirmationPopup = new ActionConfirmationPopup();
         var cont: DailyBonusComp = new DailyBonusComp();
         cont.reward = bonus;
         popUp.title = Localizer.string('Popups', 'title.dailyBonus');
         popUp.addElement(cont);
         popUp.confirmButtonLabel = Localizer.string('Quests', 'label.claimReward');
         popUp.cancelButtonClickHandler = function(button: Button):void
         {
            ML.player.dailyBonus = bonus;
         };
         popUp.confirmButtonClickHandler = function(button: Button):void
         {
            GlobalFlags.getInstance().lockApplication = true;
            new DailyBonusCommand(DailyBonusCommand.CLAIM, 
               {'planetId': MSSObject(cont.planetSelector.selectedItem).id}
            ).dispatch();
         };
         popUp.show();
      }
   }
}