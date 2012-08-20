/**
 * Created with IntelliJ IDEA.
 * User: arturas
 * Date: 8/19/12
 * Time: 4:02 PM
 * To change this template use File | Settings | File Templates.
 */
package models.player {
   import models.sound.MSound;

   /**
    * Tiny class to represent a sound option in player options screen.
    */
   public class PlayerSoundOption {
      [Bindable]
      public var name: String;
      private var _value: String;
      private var sound: MSound;

      public function PlayerSoundOption(
         _name: String, value: String, _sound: MSound
      ) {
         name = _name;
         _value = value;
         sound = _sound;
      }

      public function get value(): String {
         return _value;
      }

      public function play(): void {
         if (sound != null) {
            sound.play();
         }
      }
   }
}
