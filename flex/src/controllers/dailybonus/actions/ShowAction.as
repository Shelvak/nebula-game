package controllers.dailybonus.actions
{
   
   import components.dailybonus.DailyBonusComp;
   import components.dailybonus.DailyBonusEvent;
   import components.popups.ActionConfirmationPopUp;
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import models.player.PlayerOptions;

   import utils.ApplicationLocker;
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
         if (!PlayerOptions.showPopupsAfterLogin)
         {
            ML.player.dailyBonus = bonus;
         }
         else
         {
            var popUp: ActionConfirmationPopUp = new ActionConfirmationPopUp();
            var cont: DailyBonusComp = new DailyBonusComp();
            cont.addEventListener(DailyBonusEvent.CLOSE_PANEL,
               function(e: DailyBonusEvent):void
               {
                  ML.player.dailyBonus = bonus;
                  popUp.close();
               });
            cont.reward = bonus;
            popUp.title = Localizer.string('Popups', 'title.dailyBonus');
            popUp.addElement(cont);
            popUp.confirmButtonLabel = Localizer.string('Quests', 'label.claimReward');
            popUp.cancelButtonLabel = Localizer.string('Quests', 'label.claimLater');
            popUp.cancelButtonClickHandler = function(button: Button):void
            {
               ML.player.dailyBonus = bonus;
            };
            popUp.confirmButtonClickHandler = function(button: Button):void
            {
               new DailyBonusCommand(DailyBonusCommand.CLAIM,
                  {'planetId': MSSObject(cont.planetSelector.selectedItem).id}
               ).dispatch();
            };
            popUp.show();
         }
      }
   }
}