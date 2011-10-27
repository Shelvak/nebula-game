package controllers.alliances.actions
{
   /**
    * Aggregates parameters of <code>controllers.alliance.actions.InviteAction</code> client command.
    * 
    * @see #InviteActionParams()
    * @see #playerId
    * @see InviteAction
    */
   public class InviteActionParams
   {
      /**
       * See documentation of corresponding variables for information about parameters.
       * 
       * @see #planetId
       */
      public function InviteActionParams(playerId:int)
      {
         super();
         this.playerId = playerId;
      }
      
      
      /**
       * ID of a player to invite. <b>Required.</b>
       */
      public var playerId:int;
   }
}