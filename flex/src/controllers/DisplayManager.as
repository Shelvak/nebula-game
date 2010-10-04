package controllers
{
   import mx.core.FlexGlobals;

   public class DisplayManager
   {
      private static const FPS_STARTUP:int = 2000;
      private static const FPS_GAME:int = 24;
      
      
      /**
       * Sets frame rate to make initialization of the game faster.
       */
      public static function setFPSForStartup():void
      {
         setFPS(FPS_STARTUP);
      }
      
      
      /**
       * Restores frame rate to normal value.
       */
      public static function setFPSForGame():void
      {
         setFPS(FPS_GAME);
      }
      
      
      private static function setFPS(fps:int) : void
      {
         FlexGlobals.topLevelApplication.stage.frameRate = fps;
      }
   }
}