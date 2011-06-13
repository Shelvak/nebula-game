package utils.assets
{
   import assets.AssetsBundle;
   
   import config.Config;
   
   import controllers.startup.StartupInfo;
   import controllers.startup.StartupMode;
   
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.errors.IOError;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.NetStatusEvent;
   import flash.events.ProgressEvent;
   import flash.net.SharedObject;
   import flash.net.SharedObjectFlushStatus;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   
   import models.ModelLocator;
   
   import mx.events.ModuleEvent;
   import mx.formatters.NumberFormatter;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.modules.IModuleInfo;
   import mx.modules.ModuleManager;
   import mx.utils.ObjectUtil;
   
   import utils.EventUtils;
   import utils.Objects;
   import utils.PropertiesTransformer;
   import utils.SingletonFactory;
   import utils.assets.events.ImagePreloaderEvent;
   
   
   
   
   /**
    * Dispached after each image downloaded.
    * 
    * @eventType flash.events.ProgressEvent.PROGRESS
    */
   [Event (name="progress", type="flash.events.ProgressEvent")]
   
   
   /**
    * Dispached after all images have been downloaded.
    * 
    * @eventType flash.events.Event.COMPLETE
    */
   [Event (name="complete", type="flash.events.Event")]
   
   
   /**
    * @see utils.assets.events.ImagePreloaderEvent#UNPACK_PROGRESS
    * 
    * @eventType utils.assets.events.ImagePreloaderEvent.UNPACK_PROGRESS
    */
   [Event(name="unpackProgress", type="utils.assets.events.ImagePreloaderEvent")]
   
   
   /**
    * Once created this class downloads all images that need to be retrieved
    * from the server for later use at once (rendering planet map and stuff
    * like that).
    * 
    * <p>This class should be treaded as a singleton and instance of it should
    * be retrieved either using static method <code>getInstance()</code> or
    * using <code>utils.SingletonFactory</code>.</p>
    */ 
   public final class ImagePreloader extends EventDispatcher
   {
      private function get STARTUP_INFO() : StartupInfo
      {
         return StartupInfo.getInstance();
      }
      
      
      private function get LOG() : ILogger
      {
         return Log.getLogger(Objects.getClassName(this, true));
      }
      
      
      /**
       * @return instance of <code>ImagePreloader</code> for application wide use.
       */
      public static function getInstance() : ImagePreloader
      {
         return SingletonFactory.getSingletonInstance(ImagePreloader);
      }
      
      
      private var _movieClips:Object = {};
      
      
      /**
       * Constructor.
       */ 
      public function ImagePreloader()
      {
         _swfLoader = new Loader();
         _swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfLoaded);
         _swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
      }
      
      
      /**
       * Progress (precentage value) of unpacking of downloaded module.
       */
      public var currentUnpackingProgress:Number;
      
      
      [Bindable]
      /**
       * Label of a module currently beeing downloaded.
       */
      public var currentModuleLabel:String = "";
      
      
      private function setCurrentModuleLabel(event:ModuleEvent = null) : void
      {
         if (!event)
         {
            currentModuleLabel = _currentModule + " (0 %)" 
         }
         else {
            var percentage:int = event.bytesLoaded * 100 / event.bytesTotal;
            var formatter:NumberFormatter = new NumberFormatter();
            formatter.precision = 1
            
            currentModuleLabel = _currentModule + " (" + percentage.toString() + " % - " +
               formatter.format(event.bytesLoaded / 1024) + "k/" +
               formatter.format(event.bytesTotal / 1024) + "k)" 
         }
      }
      
      
      /* ##################### */
      /* ### IMAGE GETTERS ### */
      /* ##################### */
      
      private var _framesCache:Object = {};
      
      
      /**
       * Returns <code>Vector</code> that contains all images of animation for a given asset.
       * For each distinct <code>name</code> the same instance is always returned.
       * 
       * @param name Name of the asset which is actually an array of frame images
       * 
       * @return <code>Vector</code> containing all frames for the given asset
       */
      public function getFrames(name:String) : Vector.<BitmapData>
      {
         return getVisualAsset(name);
      }
      
      /**
       * Returns instance of <code>BitmapData</code> which is accociated
       * with the given file name.
       * 
       * @param name Name of the image file (without extension) with full path.
       * 
       * @return Instance of <code>BitmapImage</code> or null if
       * given file name is not bound to any image. 
       */
      public function getImage(name:String) : BitmapData
      {
         if (name.indexOf("null") != -1)
         {
            return null;
         }
         return getFrames(name)[0];
      };
      
      
      /* #################### */
      /* ### SharedObject ### */
      /* #################### */
      
      
      private static const SO_NAME:String = "nebula44images";
      private static const SO_PROP:String = "images";
      
      
      private function loadFromSharedObject() : void
      {
         
      }
      
      
      private function saveToSharedObject() : void
      {
         try
         {
            var so:SharedObject = SharedObject.getLocal(SO_NAME);
            
            so.data[SO_PROP] = "Test";
            so.addEventListener(NetStatusEvent.NET_STATUS, sharedObject_netStatusHandler, false, 0, true);
            if (so.flush(50 * 1024 * 1024) == SharedObjectFlushStatus.FLUSHED)
            {
               LOG.info("All images saved in SharedObject.");
               dispatchCompleteEvent();
            }
            else
            {
               LOG.info("Requested for unlimited amount of local storage. Waiting user response.");
            }
         }
         // OK: user has disabled local storage for our app
         catch (err:Error)
         {
            LOG.info("Failed to create SharedObject: user has disabled local storage for our domain.");
            dispatchCompleteEvent();
         }
      }
      
      
      private function sharedObject_netStatusHandler(event:NetStatusEvent) : void
      {
         LOG.info("NetStatusEvent: {0}", ObjectUtil.toString(event));
         if (event.info["code"] == "SharedObject.Flush.Success")
         {
            LOG.info("All images saved in SharedObject.");
            dispatchCompleteEvent();
         }
         else
         {
            // did not gove us enough storage
            LOG.info("Unable to save images in SharedObject: user has denied local storage request.");
         }
      }
      
      /* ################ */
      /* ### DOWNLOAD ### */
      /* ################ */
      
      
      private function getModules() : Array
      {
         if (STARTUP_INFO.mode == StartupMode.GAME)
         {
            return AssetsBundle.getGameModules();
         }
         else
         {
            return AssetsBundle.getBattleModules();
         }
      }
      
      
      private var _currentModule:String = "";
      private var _modulesTotal:int;
      private var _moduleInfo:IModuleInfo = null;
      
      
      /**
       * Starts download process.  
       */ 
      public function startDownload () :void
      {
         var _assetsModuleInfo: IModuleInfo;
         _assetsModuleInfo = ModuleManager.getModule("assets/AssetsConfig.swf");
         _assetsModuleInfo.addEventListener(
            ModuleEvent.READY,
            function(event:ModuleEvent) : void
            {
               Config.assetsConfig =
                  PropertiesTransformer.objectToCamelCase(_assetsModuleInfo.factory.create().config);
               _modulesTotal = getModules().length;
               downloadNextModule();
            }
         );
         _assetsModuleInfo.load();
         
      }
      private function downloadNextModule() : void
      {
         currentUnpackingProgress = 0;
         if (_moduleInfo != null)
         {
            _moduleInfo.unload();
            _moduleInfo = null;
         }
         if (getModules().length == 0)
         {
            finalizeDownload ();
            return;
         }
         
         _currentModule = getModules().pop();
         setCurrentModuleLabel();
         _moduleInfo = ModuleManager.getModule("assets/" + _currentModule + ".swf");
         _moduleInfo.addEventListener(
            ModuleEvent.READY,
            function(event:ModuleEvent) : void
            {
               _moduleInfo.removeEventListener(ModuleEvent.PROGRESS, dispatchProgressEvent);
               dispatchProgressEvent(event);
               unpackModule(_moduleInfo);
            }
         );
         _moduleInfo.addEventListener(
            ModuleEvent.PROGRESS,
            function(event:ModuleEvent) : void
            {
               setCurrentModuleLabel(event);
               dispatchProgressEvent(event);
            }
         );
         _moduleInfo.load();
      }
      /**
       * Called when all modules have been downloaded and unpacked.
       */
      private function finalizeDownload() : void
      {
         _swfLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, swfLoaded);
         _swfLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
         _swfLoader = null;
         _swfHash = null;
         _swfNames = null;
//         saveToSharedObject();
         dispatchCompleteEvent();
      }
      
      
      private var _swfLoader:Loader = null;
      private var _swfHash:Object = null;
      private var _swfHashLength:int = 0;
      private var _swfNames:Vector.<String> = null;
      private var _currentSwfName:String = null;
      /**
       * Unpacks a module: loads all embeded SWFs but does not unpack them. This will be done
       * lazily.
       */
      private function unpackModule(moduleInfo:IModuleInfo) : void
      {
         _swfHash = moduleInfo.factory.create().getSWFsHash();
         _swfNames = new Vector.<String>();
         for (var name:String in _swfHash)
         {
            _swfNames.push(name);
         }
         _swfHashLength = _swfNames.length;
         loadNextSWF();
      }
      private function loadNextSWF() : void
      {
         if (_swfNames.length == 0)
         {
            _swfHash = null;
            _swfNames = null;
            downloadNextModule();
            return;
         }
         _currentSwfName = _swfNames.pop();
         _swfLoader.loadBytes(new (_swfHash[_currentSwfName])());
      }
      private function swfLoaded(event:Event) : void
      {
         var instance:* = _swfLoader.content;
         if (instance is MovieClip)
         {
            MovieClip(instance).stop();
            _movieClips[_currentSwfName.substring(0, _currentSwfName.length - 4)] = instance;
            /**
             * @since Flash Player 10.3
             * 
             * Devs in Adobe changed something in 10.3 version. If I deffer unpacking of frames
             * in a MovieClip until they are actually needed, goToAndStop() does not work anymore.
             * The MovieClip completely ignores number of a frame I pass and it stays on the 1st frame
             * all the time. So all unpacked frames of an animation become the first frame and our
             * animations do not seem to work anymore. All this does not happen if I unpack the frames
             * right after the SWF has been loaded.
             */
            getVisualAsset(_currentSwfName.substring(0, _currentSwfName.length - 4));
         }
         else
         {
            throw new Error("Unexpected asset type: " + getQualifiedClassName(instance));
         }
         currentUnpackingProgress = 1 - _swfNames.length / _swfHashLength;
         if (_swfNames.length % 5 == 0)
         {
            dispatchUnpackProgressEvent();
         }
         loadNextSWF();
      }
      private function ioErrorHandler(event:IOErrorEvent) : void
      {
         
         throw new IOError(
            event.text + "\nLoaded module: " + _currentModule + "\nContent type: " + 
            _swfLoader.contentLoaderInfo.contentType
         );
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function throwAssetNotFoundError(name:String) : void
      {
         throw new ArgumentError("Asset '" + name + "' not found");
      }
      
      /**
       * Returns asset from the chache if the asset has been requested before or unpacks this
       * asset from a <code>MovieClip</code>, deletes this <code>MovieClip</code> from memory and
       * returns the asset.
       * 
       * @param cache cache object to use
       * @param name name of an asset
       * 
       * @return instance of <code>Vector.&lt;BitmapData&gt;</code>
       */
      private function getVisualAsset(name:String) : Vector.<BitmapData>
      {
         if (_framesCache[name] === undefined)
         {
            if (_movieClips[name] === undefined)
            {
               throwAssetNotFoundError(name);
            }
            var clip:MovieClip = _movieClips[name]
            var frames:Vector.<BitmapData> = new Vector.<BitmapData>(clip.totalFrames, true);
            for (var i:int = 1; i <= clip.totalFrames; i++)
            {
               frames[i - 1] = getFrame(clip, i);
            }
            _framesCache[name] = frames;
            delete _movieClips[name];
         }
         return _framesCache[name];
      }
      private function getFrame(clip:MovieClip, frameNumber:int) : BitmapData
      {
         clip.gotoAndStop(frameNumber);
         var frame:BitmapData = new BitmapData(clip.width, clip.height, true, 0);
         frame.draw(clip);
         return frame;
      }
      
      
      public static function corr(image1:BitmapData, image2:BitmapData) : Number
      {
         var bytes1:ByteArray = image1.getPixels(image1.rect); bytes1.position = 0;
         var bytes2:ByteArray = image2.getPixels(image2.rect); bytes2.position = 0;
         var SHIFT_A:int = 8 * 3; var MASK_A:uint = 0xFF000000;
         var SHIFT_R:int = 8 * 2; var MASK_R:uint = 0x00FF0000;
         var SHIFT_G:int = 8 * 1; var MASK_G:uint = 0x0000FF00;
         var SHIFT_B:int = 8 * 0; var MASK_B:uint = 0x000000FF;
         var CHANNEL_MAX:uint = 0xFF;
         var result:Number = 0;
         var byteIdx:int = 0;
         while(bytes1.bytesAvailable >= 4)
         {
            var px1:uint = bytes1.readUnsignedInt();
            var A1:uint = (px1 & MASK_A >> SHIFT_A) / CHANNEL_MAX;
            var R1:uint = (px1 & MASK_R >> SHIFT_R) / CHANNEL_MAX;
            var G1:uint = (px1 & MASK_G >> SHIFT_G) / CHANNEL_MAX;
            var B1:uint = (px1 & MASK_B >> SHIFT_B) / CHANNEL_MAX;
            
            var px2:uint = bytes2.readUnsignedInt();
            var A2:uint = (px2 & MASK_A >> SHIFT_A) / CHANNEL_MAX;
            var R2:uint = (px2 & MASK_R >> SHIFT_R) / CHANNEL_MAX;
            var G2:uint = (px2 & MASK_G >> SHIFT_G) / CHANNEL_MAX;
            var B2:uint = (px2 & MASK_B >> SHIFT_B) / CHANNEL_MAX;
            
            result += A1 * A2 * (R1 * R2 + G1 * G2 + B1 * B2);
         }
         return result / 1e6;         
      }
      
      
      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */
      
      
      private function dispatchCompleteEvent() : void
      {
         if (hasEventListener(Event.COMPLETE))
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      
      private function dispatchProgressEvent(event:ModuleEvent) : void
      {
         var modulesLoaded:Number = _modulesTotal - getModules().length;
         var b:Number = 1 / _modulesTotal;
         var currentProgress:Number = (modulesLoaded + event.bytesLoaded / event.bytesTotal) * b;
         event.bytesTotal = 100;
         event.bytesLoaded = currentProgress * 100;
         dispatchEvent(event);
      }
      
      
      private function dispatchUnpackProgressEvent() : void
      {
         EventUtils.dispatchSimpleEvent(this, ImagePreloaderEvent, ImagePreloaderEvent.UNPACK_PROGRESS);
      }
   }
}
