package controllers.quests
{
   import controllers.CommunicationCommand;
   
   public class QuestsCommand extends CommunicationCommand
   {
      /**
       * @see controllers.quests.actions.IndexAction
       */
      public static const INDEX:String = "quests|index";
      
      /**
       * @see controllers.quests.actions.ClaimRewardsAction
       */
      public static const CLAIM_REWARDS:String = "quests|claimRewards";
      
      
      
      public function QuestsCommand(type:String,
                                           parameters:Object = null,
                                           fromServer:Boolean = false,
                                           eagerDispatch:Boolean = false)
      {
         super(type, parameters, fromServer, eagerDispatch);
      }
   }
}