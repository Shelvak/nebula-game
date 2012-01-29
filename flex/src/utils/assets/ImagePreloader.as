package utils.assets
{
   import assets.AssetsBundle;

   import config.Config;

   import controllers.startup.StartupInfo;
   import controllers.startup.StartupMode;

   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.errors.IOError;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;

   import mx.events.ModuleEvent;
   import mx.formatters.NumberFormatter;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.modules.IModuleInfo;
   import mx.modules.ModuleManager;

   import namespaces.client_internal;

   import utils.Events;
   import utils.Objects;
   import utils.PropertiesTransformer;
   import utils.SingletonFactory;


   /**
    * Dispatched after each image downloaded.
    * 
    * @eventType flash.events.ProgressEvent.PROGRESS
    */
   [Event(name="progress", type="flash.events.ProgressEvent")]
   
   /**
    * Dispatched after all images have been downloaded.
    * 
    * @eventType flash.events.Event.COMPLETE
    */
   [Event(name="complete", type="flash.events.Event")]

   
   /**
    * Once created this class downloads all images that need to be retrieved
    * from the server for later use at once (rendering planet map and stuff
    * like that).
    * 
    * <p>This class should be treated as a singleton and instance of it should
    * be retrieved either using static method <code>getInstance()</code> or
    * using <code>utils.SingletonFactory</code>.</p>
    */ 
   public class ImagePreloader extends EventDispatcher
   {
      public static function getInstance() : ImagePreloader {
         return SingletonFactory.getSingletonInstance(ImagePreloader);
      }

      private function get STARTUP_INFO() : StartupInfo {
         return StartupInfo.getInstance();
      }

      private var _movieClips:Object = {};
      
      
      [Bindable]
      /**
       * Label of a module currently being downloaded.
       */
      public var currentModuleLabel:String = "";
      [Bindable]
      /**
       * Progress of a module currently being downloaded.
       */
      public var currentModuleProgress:String = "";

      private function ensureSwfLoadersCount(assetsCount: int): void
      {
         if (_swfLoaders.length >= assetsCount)
         {
            return;
         }
         var missingCount: int = assetsCount - _swfLoaders.length;
         for (var i: int = 0; i < missingCount; i++)
         {
            var _swfLoader: Loader;
            _swfLoader = new Loader();
            _swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfLoaded);
            _swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            var mLoader: LoaderObject = new LoaderObject(_swfLoader);
            _swfLoaders.push(mLoader);
            loadersHash[_swfLoader] = mLoader;
         }
      }
      
      private function setCurrentModuleLabel(event:ModuleEvent = null) : void
      {
         if (!event)
         {
            currentModuleLabel = _currentModule;
            currentModuleProgress = "0 %";
         }
         else {
            var percentage:int = event.bytesLoaded * 100 / event.bytesTotal;
            var formatter:NumberFormatter = new NumberFormatter();
            formatter.precision = 1;
            
            currentModuleLabel = _currentModule;
            currentModuleProgress = percentage.toString() + " % - " +
               formatter.format(event.bytesLoaded / 1024) + "k/" +
               formatter.format(event.bytesTotal / 1024) + "k";
         }
      }
      
      
      /* ##################### */
      /* ### IMAGE GETTERS ### */
      /* ##################### */
      
      private var _framesCache:Object = new Object();

      /**
       * For use in tests to add images.
       */
      client_internal function addFrames
         (name: String, frames: Vector.<BitmapData> = null): void {
         Objects.paramNotNull("name", name);
         _framesCache[name] = frames;
      }

      /**
       * For use in tests to clear all images when they are not needed anymore.
       */
      client_internal function clearFrames(): void {
         _framesCache = new Object();
      }
      
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
      }

      /* ################ */
      /* ### DOWNLOAD ### */
      /* ################ */
      
      
      private function getModules() : Array
      {
         switch (STARTUP_INFO.mode) {
            case StartupMode.GAME:
               return AssetsBundle.getGameModules();
            case StartupMode.BATTLE:
               return AssetsBundle.getBattleModules();
            case StartupMode.MAP_EDITOR:
               return AssetsBundle.getMapEditorModules();
         }
         throw new Error("Unsupported game mode: " + STARTUP_INFO.mode);
         return null;   // unreachable
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
         _assetsModuleInfo = ModuleManager.getModule(
            STARTUP_INFO.assetsUrl + "assets/" + getModuleFileName('AssetsConfig')
         );
         
         _assetsModuleInfo.addEventListener(
            ModuleEvent.READY,
            function(event:ModuleEvent) : void {
               Config.assetsConfig =
                  PropertiesTransformer.objectToCamelCase(_assetsModuleInfo.factory.create().config);
               _modulesTotal = getModules().length;
               downloadNextModule();
            }
         );
         _assetsModuleInfo.load();
         
      }
      private function getModuleFileName(moduleName:String): String {
         var fileName:String = moduleName + ".swf";
         if (STARTUP_INFO.assetsSums != null)
            fileName = STARTUP_INFO.assetsSums[fileName];
         return fileName
      }
      private function downloadNextModule() : void
      {
         
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
         _moduleInfo = ModuleManager.getModule(
            STARTUP_INFO.assetsUrl + "assets/" + getModuleFileName(_currentModule)
         );
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
         for each (var mLoader: LoaderObject in _swfLoaders)
         {
            loadersHash[mLoader.loader] = null;
            mLoader.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, swfLoaded);
            mLoader.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            mLoader.loader = null;
            mLoader = null;
         }
         _swfHash = null;
         _swfNames = null;
         dispatchCompleteEvent();
      }
      
      
      //private var _swfLoader:Loader = null;
      private var _swfLoaders: Array = [];
      private var _swfHash:Object = null;
      private var _swfHashLength:int = 0;
      private var _swfNames:Vector.<String> = null;
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
         ensureSwfLoadersCount(_swfHashLength);
         for (var i: int = 0; i < Math.min(_swfLoaders.length, _swfHashLength); i++)
         {
            activeLoaders++;
            loadNextSWF(_swfLoaders[i]);
         }
      }

      private var activeLoaders: int = 0;
      /*
      * Hash of {LoaderObject.loader => LoaderObject} pairs.
      */
      private var loadersHash: Dictionary = new Dictionary();

      private function loadNextSWF(mLoader: LoaderObject) : void
      {
         if (_swfNames.length == 0)
         {
            activeLoaders--;
            if (activeLoaders == 0)
            {
               _swfHash = null;
               _swfNames = null;
               downloadNextModule();
            }
            return;
         }
         mLoader.currentName = _swfNames.pop();
         var movieClipData: ByteArray = new (_swfHash[mLoader.currentName])();
         mLoader.loader.loadBytes(movieClipData);
      }
      private function swfLoaded(event:Event) : void
      {
         var mLoader: LoaderObject = LoaderObject(
            loadersHash[event.target.loader]);
         var instance:* = mLoader.loader.content;
         if (instance is MovieClip)
         {
            MovieClip(instance).stop();
            _movieClips[mLoader.currentName.substring(0,
               mLoader.currentName.length - 4)] = instance;
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
            getVisualAsset(mLoader.currentName.substring(0,
               mLoader.currentName.length - 4));
         }
         else
         {
            throw new Error("Unexpected asset type: " + getQualifiedClassName(instance));
         }
         loadNextSWF(mLoader);
      }
      private function ioErrorHandler(event:IOErrorEvent) : void
      {
         
         throw new IOError(
            event.text + "\nLoaded module: " + _currentModule + "\nContent type: " + 
            Loader(event.target).contentLoaderInfo.contentType
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
            var clip:MovieClip = _movieClips[name];
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
         var modulesLoaded:Number = _modulesTotal - getModules().length - 1;
         var currentProgress:Number = (modulesLoaded + event.bytesLoaded / event.bytesTotal) * (1 / _modulesTotal);
         event.bytesTotal = 100;
         event.bytesLoaded = currentProgress * 100;
         dispatchEvent(event);
      }
   }
}

import flash.display.Loader;

class LoaderObject
{
   public function LoaderObject(_loader: Loader)
   {
      loader = _loader;
   }
   public var loader: Loader;
   public var currentName: String;
}
