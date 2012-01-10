package models.player
{
   import controllers.ui.NavigationController;
   
   import models.BaseModel;

   import utils.Objects;

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
      
      
      public function PlayerMinimal(id:int = 0, name:String = null) {
         super();
         if (id != 0) {
            this.id = Objects.paramIsId("id", id);
         }
         if (name != null) {
            this.name = Objects.paramNotEmpty("name", name);
         }
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

      public override function equals(o:Object): Boolean {
         const player:PlayerMinimal = o as PlayerMinimal;
         if (player == null) {
            return false;
         }
         return this.id == player.id;
      }
      
      
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