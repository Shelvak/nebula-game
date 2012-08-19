/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 8/8/12
 * Time: 11:20 AM
 * To change this template use File | Settings | File Templates.
 */
package models.sound {
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;

   public class MSound {
      /**
       * Full name of sound, e.g. "notifications/foo"
       */
      public var name: String;
      /**
       * Basename of the sound. If the full name would be "notifications/foo"
       * then basename would be "foo".
       */
      public var basename: String;

      private var source: Sound;
      private var channels: Vector.<SoundChannel> = new Vector.<SoundChannel>();

      /**
       * @param _name full sound name without the extension, e.g. "foo/bar/baz"
       * @param _source
       */
      public function MSound(_name: String, _source: Sound) {
         name = _name;
         var parts: Array = name.split("/");
         basename = parts[parts.length - 1];
         source = _source;
      }

      /**
       * Plays this sound.
       *
       * @param allowOverlapping Do we allow several instances of this sound to
       * play simultaneously?
       */
      public function play(allowOverlapping: Boolean = false): void {
         if (allowOverlapping || channels.length == 0) {
            const channel: SoundChannel = source.play();
            /**
             * From Flash ASDoc:
             *
             * This method returns null if you have no sound card or if you run out of available
             * sound channels. The maximum number of sound channels available at once is 32.
             */
            if (channel != null) {
               channel.addEventListener(Event.SOUND_COMPLETE, removeChannel);
               channels.push(channel);
            }
         }
      }

      private function removeChannel(e: Event): void {
         const channel: SoundChannel = channels.shift();
         channel.removeEventListener(Event.SOUND_COMPLETE, removeChannel);
      }
   }
}
