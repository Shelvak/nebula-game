package models.player
{
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
       * For now this opens a private channel to this player. Later this will open a profile or something
       * like that.
       */
      public function show() : void
      {
         MChat.getInstance().openPrivateChannel(id, name);
      }
   }
}