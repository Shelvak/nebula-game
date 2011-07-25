package models.player
{
   import controllers.ui.NavigationController;
   
   import models.BaseModel;
   import models.chat.MChat;
   
   
   /**
    * Minimal version of the player. Defines only <code>name</code> property (<code>id</code> is
    * already defined in <code>BaseModel</code>)
    */
   public class PlayerMinimal extends BaseModel
   {
      public function PlayerMinimal()
      {
         super();
      }
      
      [Bindable (event="modelIdChange")]
      public function get isNpc(): Boolean
      {
         return id == 0;
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
      public function show() : void
      {
         NavigationController.getInstance().showPlayer(id);
      }
   }
}