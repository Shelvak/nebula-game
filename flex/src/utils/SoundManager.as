package utils
{
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundLoaderContext;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;

   /**
    * The SoundManager is a singleton that allows you to have various ways to control sounds in your project.
    *
    
    * The SoundManager can load external or library sounds, pause/mute/stop/control volume for one or more sounds at a time,
    * fade sounds up or down, and allows additional control to sounds not readily available through the default classes.
    *
    
    * This class is dependent on TweenLite (http://www.tweenlite.com) to aid in easily fading the volume of the sound.
    *
    * @author Matt Przybylski [http://www.reintroducing.com]
    * @version 1.0
    *
    * @author Ryan Christensen (http://drawlogic.com)
    * @version 1.1 - added Tweener support and removed TweenLite support
    */
   public class SoundManager
   {
      //- PRIVATE &amp; PROTECTED VARIABLES -------------------------------------------------------------------------
      // singleton instance
      private var maxPlaying: int = 5;
      private static var _instance:SoundManager;
      private static var _allowInstance:Boolean;
      private var _soundsDict:Dictionary;
      private var _sounds:Array;
      //- PUBLIC &amp; INTERNAL VARIABLES ---------------------------------------------------------------------------
      //- CONSTRUCTOR -------------------------------------------------------------------------------------------
      // singleton instance of SoundManager
      public static function getInstance():SoundManager
      {
         if (SoundManager._instance == null)
         {
            SoundManager._allowInstance = true;
            SoundManager._instance = new SoundManager();
            SoundManager._allowInstance = false;
         }
         return SoundManager._instance;
      }
      public function SoundManager()
      {
         this._soundsDict = new Dictionary(true);
         this._sounds = new Array();
         if (!SoundManager._allowInstance)
         {
            throw new Error("Error: Use SoundManager.getInstance() instead of the new keyword.");
         }
      }
      
      public function setMaxPlaying(value: int): void
      {
         maxPlaying = value;
      }
      
      public function addSound($snd: Sound, $name: String): Boolean
      {
         for (var i:int = 0; i < this._sounds.length; i++)
         {
            if (this._sounds[i].name == $name) return false;
         }
         var sndObj:Object = new Object();
         sndObj.name = $name;
         sndObj.sound = $snd;
         sndObj.channel = new SoundChannel();
         sndObj.position = 0;
         sndObj.paused = true;
         sndObj.volume = 1;
         sndObj.startTime = 0;
         sndObj.loops = 1;
         sndObj.pausedByAll = false;
         this._soundsDict[$name] = sndObj;
         this._sounds.push(sndObj);
         return true;
      }
      
      
      /**
       * Removes a sound from the sound dictionary.  After calling this, the sound will not be available until it is re-added.
       *
       * @param $name The string identifier of the sound to remove
       *
       * @return void
       */
      public function removeSound($name:String):void
      {
         for (var i:int = 0; i < this._sounds.length; i++)
         {
            if (this._sounds[i].name == $name)
            {
               this._sounds[i] = null;
               this._sounds.splice(i, 1);
            }
         }
         delete this._soundsDict[$name];
      }
      /**
       * Removes all sounds from the sound dictionary.
       *
       * @return void
       */
      public function removeAllSounds():void
      {
         for (var i:int = 0; i < this._sounds.length; i++)
         {
            this._sounds[i] = null;
         }
         this._sounds = new Array();
         this._soundsDict = new Dictionary(true);
      }
      /**
       * Plays or resumes a sound from the sound dictionary with the specified name.
       *
       * @param $name The string identifier of the sound to play
       * @param $volume A number from 0 to 1 representing the volume at which to play the sound (default: 1)
       * @param $startTime A number (in milliseconds) representing the time to start playing the sound at (default: 0)
       * @param $loops An integer representing the number of times to loop the sound (default: 0)
       *
       * @return void
       */
      public function playSound($name:String, onComplete: Function = null, 
                                $volume:Number = 1, $startTime:Number = 0, $loops:int = 0):void
      {
//         if (playingCount < maxPlaying)
//         {
            var snd:Object = this._soundsDict[$name];
            snd.volume = $volume;
            snd.startTime = $startTime;
            snd.loops = $loops;
            if (onComplete != null)
               (snd.sound as Sound).addEventListener(Event.COMPLETE, onComplete);
            if (snd.paused)
            {
               snd.channel = snd.sound.play(snd.position, snd.loops, new SoundTransform(snd.volume));
            }
            else
            {
               snd.channel = snd.sound.play($startTime, snd.loops, new SoundTransform(snd.volume));
            }
            snd.paused = false;
//         }
      }
      /**
       * Stops the specified sound.
       *
       * @param $name The string identifier of the sound
       *
       * @return void
       */
      public function stopSound($name:String):void
      {
         var snd:Object = this._soundsDict[$name];
         snd.paused = true;
         snd.channel.stop();
         snd.position = snd.channel.position;
      }
      /**
       * Pauses the specified sound.
       *
       * @param $name The string identifier of the sound
       *
       * @return void
       */
      public function pauseSound($name:String):void
      {
         var snd:Object = this._soundsDict[$name];
         snd.paused = true;
         snd.position = snd.channel.position;
         snd.channel.stop();
      }
      
      private function get playingCount(): int
      {
         var count: int = 0;
         for (var i:int = 0;i < this._sounds.length; i++)
         {
            var id:String = this._sounds[i].name;
            if (!this._soundsDict[id].paused)
            {
               count++;
            }
         }
         return count;
      }
      /**
       * Stops all the sounds that are in the sound dictionary.
       *
       * @param $useCurrentlyPlayingOnly A boolean that only stops the sounds which are currently playing (default: true)
       *
       * @return void
       */
      public function stopAllSounds($useCurrentlyPlayingOnly:Boolean = true):void
      {
         for (var i:int = 0; i < this._sounds.length; i++)
         {
            var id:String = this._sounds[i].name;
            if ($useCurrentlyPlayingOnly)
            {
               if (!this._soundsDict[id].paused)
               {
                  this._soundsDict[id].pausedByAll = true;
                  this.stopSound(id);
               }
            }
            else
            {
               this.stopSound(id);
            }
         }
      }
      /**
       * Pauses all the sounds that are in the sound dictionary.
       *
       * @param $useCurrentlyPlayingOnly A boolean that only pauses the sounds which are currently playing (default: true)
       *
       * @return void
       */
      public function pauseAllSounds($useCurrentlyPlayingOnly:Boolean = true):void
      {
         for (var i:int = 0; i < this._sounds.length; i++)
         {
            var id:String = this._sounds[i].name;
            if ($useCurrentlyPlayingOnly)
            {
               if (!this._soundsDict[id].paused)
               {
                  this._soundsDict[id].pausedByAll = true;
                  this.pauseSound(id);
               }
            }
            else
            {
               this.pauseSound(id);
            }
         }
      }
      
      /**
       * Mutes the volume for all sounds in the sound dictionary.
       *
       * @return void
       */
      public function muteAllSounds():void
      {
         for (var i:int = 0; i < this._sounds.length; i++)
         {
            var id:String = this._sounds[i].name;
            this.setSoundVolume(id, 0);
         }
      }
      /**
       * Resets the volume to their original setting for all sounds in the sound dictionary.
       *
       * @return void
       */
      public function unmuteAllSounds():void
      {
         for (var i:int = 0; i < this._sounds.length; i++)
         {
            var id:String = this._sounds[i].name;
            var snd:Object = this._soundsDict[id];
            var curTransform:SoundTransform = snd.channel.soundTransform;
            curTransform.volume = snd.volume;
            snd.channel.soundTransform = curTransform;
         }
      }
      /**
       * Sets the volume of the specified sound.
       *
       * @param $name The string identifier of the sound
       * @param $volume The volume, between 0 and 1, to set the sound to
       *
       * @return void
       */
      public function setSoundVolume($name:String, $volume:Number):void
      {
         var snd:Object = this._soundsDict[$name];
         var curTransform:SoundTransform = snd.channel.soundTransform;
         curTransform.volume = $volume;
         snd.channel.soundTransform = curTransform;
      }
      /**
       * Gets the volume of the specified sound.
       *
       * @param $name The string identifier of the sound
       *
       * @return Number The current volume of the sound
       */
      public function getSoundVolume($name:String):Number
      {
         return this._soundsDict[$name].channel.soundTransform.volume;
      }
      /**
       * Gets the position of the specified sound.
       *
       * @param $name The string identifier of the sound
       *
       * @return Number The current position of the sound, in milliseconds
       */
      public function getSoundPosition($name:String):Number
      {
         return this._soundsDict[$name].channel.position;
      }
      /**
       * Gets the duration of the specified sound.
       *
       * @param $name The string identifier of the sound
       *
       * @return Number The length of the sound, in milliseconds
       */
      public function getSoundDuration($name:String):Number
      {
         return this._soundsDict[$name].sound.length;
      }
      /**
       * Gets the sound object of the specified sound.
       *
       * @param $name The string identifier of the sound
       *
       * @return Sound The sound object
       */
      public function getSoundObject($name:String):Sound
      {
         return this._soundsDict[$name].sound;
      }
      /**
       * Identifies if the sound is paused or not.
       *
       * @param $name The string identifier of the sound
       *
       * @return Boolean The boolean value of paused or not paused
       */
      public function isSoundPaused($name:String):Boolean
      {
         return this._soundsDict[$name].paused;
      }
      /**
       * Identifies if the sound was paused or stopped by calling the stopAllSounds() or pauseAllSounds() methods.
       *
       * @param $name The string identifier of the sound
       *
       * @return Number The boolean value of pausedByAll or not pausedByAll
       */
      public function isSoundPausedByAll($name:String):Boolean
      {
         return this._soundsDict[$name].pausedByAll;
      }
      //- EVENT HANDLERS ----------------------------------------------------------------------------------------
      //- GETTERS &amp; SETTERS -------------------------------------------------------------------------------------
      public function get sounds():Array
      {
         return this._sounds;
      }
      //- HELPERS -----------------------------------------------------------------------------------------------
      public function toString():String
      {
         return getQualifiedClassName(this);
      }
      //- END CLASS ---------------------------------------------------------------------------------------------
   }
}
