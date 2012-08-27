package models.player
{
   import controllers.ui.NavigationController;
   
   import models.BaseModel;

   import utils.ObjectStringBuilder;

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
            npcPlayer.id = 0;
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

      public function get isCurrentPlayer(): Boolean {
         return ML.player != null && ML.player.id == id;
      }
      
      
      [Bindable]
      [Optional]
      /**
       * Name of the player.
       *
       * @default empty string
       */
      public var name:String = "";

      public override function equals(o: Object): Boolean {
         const another: PlayerMinimal = o as PlayerMinimal;
         return another != null && another.id == this.id;
      }


      override public function toString(): String {
         return new ObjectStringBuilder(this)
            .addProp("id")
            .addProp("name").finish();
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