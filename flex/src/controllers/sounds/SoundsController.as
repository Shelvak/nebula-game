/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 8/6/12
 * Time: 5:42 PM
 * To change this template use File | Settings | File Templates.
 */
package controllers.sounds {
   import flash.media.Sound;
   import flash.media.SoundChannel;

   import utils.SingletonFactory;

   public class SoundsController {

      [Embed(source='/embed/beep.mp3')]
      private static const beep: Class;

      [Embed(source='/embed/notification.mp3')]
      private static const notification: Class;

      private static const names: Object = {
         'beep': new beep() as Sound,
         'notification': new notification() as Sound
      }

      public static function getInstance(): SoundsController
      {
         return SingletonFactory.getSingletonInstance(SoundsController);
      }

      public static function playSound(name: String): void
      {
         var ch: SoundChannel = Sound(names[name]).play();
      }
   }
}
