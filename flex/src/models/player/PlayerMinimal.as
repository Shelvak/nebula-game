package models.player
{
   import controllers.ui.NavigationController;
   
   import models.BaseModel;
   
   import utils.locale.Localizer;
   
   
   /**
    * Minimal version of the player. Defines only <code>name</code> property (<code>id</code> is
    * already defined in <code>BaseModel</code>)
    */
   public class PlayerMinimal extends BaseModel
   {
      private static var npcPlayer:PlayerMinimal = null;
      public static function get NPC_PLAYER() : PlayerMinimal {
         if (npcPlayer == null) {
            npcPlayer = new PlayerMinimal();
            npcPlayer.id = PlayerId.NO_PLAYER;
            npcPlayer.name = Localizer.string("Players", "npc");
         }
         return npcPlayer;
      }
      
      
      public function PlayerMinimal() {
         super();
      }
      
      
      [Bindable]
      [Optional]
      /**
       * Name of the player.
       * 
       * <p>Metadata:<br/>
       * [Bindable]<br/>
       * [Optional]
       * </p>
       * 
       * @default empty string
       */
      public var name:String = "";
      
      
      /* ########## */
      /* ### UI ### */
      /* ########## */
      
      /**
       * Opens up player profile screen.
       */
      public function show() : void {
         NavigationController.getInstance().showPlayer(id);
      }
   }
}