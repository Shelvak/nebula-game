package controllers.alliances.actions
{
   import models.player.PlayerMinimal;

   import utils.Objects;


   public class GiveAwayActionParams
   {
      /**
       * @see #player
       */
      public function GiveAwayActionParams(player:PlayerMinimal) {
         super();
         this.player = Objects.paramNotNull("player", player);
      }

      /**
       * A player to give away alliance to.
       * 
       * <p><b>Required. Not null.</b></p>
       */
      public var player:PlayerMinimal;
   }
}
