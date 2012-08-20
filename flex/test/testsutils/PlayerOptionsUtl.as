package testsutils
{
   import models.player.PlayerOptions;


   public class PlayerOptionsUtl
   {
      public static function muteSounds(): void {
         PlayerOptions.soundForAllianceMsg = PlayerOptions.NO_SOUND;
         PlayerOptions.soundForNotification = PlayerOptions.NO_SOUND;
         PlayerOptions.soundForPrivateMsg = PlayerOptions.NO_SOUND;
      }
   }
}
