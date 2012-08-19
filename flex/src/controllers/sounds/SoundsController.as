/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 8/6/12
 * Time: 5:42 PM
 * To change this template use File | Settings | File Templates.
 */
package controllers.sounds {
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.utils.Dictionary;

   import models.sound.MSound;

   import mx.collections.ArrayCollection;

   import utils.locale.Localizer;

   public class SoundsController {
      // Hash of {fullName => MSound}
      private static var sounds: Object = {};

      private static const MP3: String = '.mp3';
      private static const SOUNDS_PREFIX: String = 'sounds/';
      public static const NOTIFICATION_PREFIX: String = 'notifications/';

      /**
       * Registers sound object to this controller. Strips .mp3 from name.
       *
       * @param name full sound name, e.g.: "sounds/notifications/n08.mp3"
       * @param data
       */
      public static function registerSound(name: String, data: Sound): void
      {
         if (name.substr(0, SOUNDS_PREFIX.length) == SOUNDS_PREFIX) {
            name = name.substr(SOUNDS_PREFIX.length);
         }
         else {
            throw new ArgumentError(
               "Sound name '"+name+"' does not start with '"+SOUNDS_PREFIX+
               "'! Are you sure you're registering a sound?"
            );
         }
         name = stripMp3(name);

         var sound: MSound = new MSound(name, data);
         sounds[name] = sound;
      }

      /**
       * Fetches sound by name.
       *
       * @param name full sound name (must be without .mp3 extension)
       * @return
       */
      public static function fetch(name: String): MSound
      {
         const sound: MSound = sounds[name];
         if (sound == null) {
            throw new ArgumentError("Unknown sound '"+name+"'!");
         }

         return sound;
      }

      /**
       * Fetches notification sound by basename.
       * @param basename
       * @return
       */
      public static function fetchNotification(basename: String): MSound
      {
         return fetch(NOTIFICATION_PREFIX + basename);
      }

      /**
       * Return a vector containing sounds to which callback returned true.
       *
       * @param callback callback function with one argument (MSound).
       * @return
       */
      public static function filter(callback: Function): Vector.<MSound>
      {
         const vector: Vector.<MSound> = new Vector.<MSound>();
         for each (var sound: MSound in sounds) {
            if (callback(sound)) {
               vector.push(sound);
            }
         }

         return vector;
      }

      private static function stripMp3(name: String): String
      {
         const extension: String = name.substr(name.length - 4, 4);
         if (extension == MP3) {
            name = name.substr(0, name.length - 4);
         }
         return name;
      }
   }
}