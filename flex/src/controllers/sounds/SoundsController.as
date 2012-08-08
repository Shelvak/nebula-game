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

      private static var sounds: Object;

      private static var channelNames: Dictionary = new Dictionary(true);
      private static var channels: Object = {};

      public static const MP3: String = '.mp3';

      public static function playSoundByName(name: String): void
      {
         if (channels[name] == null)
         {
            var ch: SoundChannel = Sound(sounds[name]).play();
            ch.addEventListener(Event.SOUND_COMPLETE, removeChannel);
            channelNames[ch] = name;
            channels[name] = ch;
         }
      }

      public static function playSoundByIndex(index: int, fileExtention: String = MP3): void
      {
         var name: String = (soundNames.getItemAt(index + 1) as MSound).source;
         if (channels[name] == null)
         {
            var ch: SoundChannel = Sound(sounds[name + fileExtention]).play();
            ch.addEventListener(Event.SOUND_COMPLETE, removeChannel);
            channelNames[ch] = name;
            channels[name] = ch;
         }
      }

      [Bindable]
      public static var soundNames: ArrayCollection;

      public static function loadSounds(from: Object): void
      {
         sounds = from;
         var names: Array = [];
         // For 'none' in sound selection
         names.push(new MSound(Localizer.string('PlayerOptions',
            'label.noSound'), null));
         for (var source: String in sounds)
         {
            var parts: Array = source.split('/');
            names.push(new MSound(Localizer.string('PlayerOptions',
               'label.sound.' + (parts[parts.length-1] as String).slice(
               0, (parts[parts.length-1] as String).length-4)),
               source.slice(0, source.length-4)));
         }
         soundNames = new ArrayCollection(names);
      }

      private static function removeChannel(e: Event): void
      {
         var ch: SoundChannel = SoundChannel(e.currentTarget);
         ch.removeEventListener(Event.SOUND_COMPLETE, removeChannel);
         var name: String = channelNames[ch];
         channels[name] = null;
         channelNames[ch] = null;
      }
   }
}