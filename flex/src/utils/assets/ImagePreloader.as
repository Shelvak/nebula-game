package utils.assets
{
   import assets.AssetsBundle;

   import components.popups.ModuleLoadFailPopUp;

   import config.Config;

   import controllers.sounds.SoundsController;

   import controllers.startup.ChecksumsLoader;
   import controllers.startup.StartupInfo;
   import controllers.startup.StartupMode;

   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.errors.IOError;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.media.Sound;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;

   import mx.formatters.NumberFormatter;
   import mx.modules.IModuleInfo;

   import namespaces.client_internal;

   import spark.components.Button;

   import utils.Objects;
   import utils.PropertiesTransformer;
   import utils.SingletonFactory;
   import utils.SystemInfo;
   import utils.locale.Localizer;


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

      private var _movieClips:Object = new Object();
      
      
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
      
      private function setCurrentModuleLabel(event:ExtendedModuleEvent = null) : void
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

      private function getSoundModules(): Array
      {
         switch (STARTUP_INFO.mode) {
            case StartupMode.GAME:
               return AssetsBundle.getSoundModules();
            case StartupMode.BATTLE:
               return [];
            case StartupMode.MAP_EDITOR:
               return [];
         }
         throw new Error("Unsupported game mode: " + STARTUP_INFO.mode);
         return null;   // unreachable
      }
      
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
      private var currentChecksumResult:String = "";
      private var _modulesTotal:int;
      private var _moduleInfo: ModuleInfo = null;
      private var _lastHttpStatus: int = 0;
      
      
      /**
       * Starts download process.  
       */ 
      public function startDownload () :void
      {
         _currentModule = 'AssetsConfig';
         const moduleName: String = getModuleFileName(_currentModule);
         currentChecksumResult = moduleName;

         _moduleInfo = new ModuleInfo(STARTUP_INFO.assetsUrl + "assets/" + moduleName);
         _moduleInfo.addEventListener(
            ExtendedModuleEvent.READY, assetsConfigReadyHandler
         );
         addHttpStatusHandler(_moduleInfo);
         addFailHandler(_moduleInfo);
         _moduleInfo.load();
      }
      
      private function assetsConfigReadyHandler(event: ExtendedModuleEvent): void
      {
         _moduleInfo.removeEventListener(
            ExtendedModuleEvent.READY, assetsConfigReadyHandler
         );
         const module:Object = _moduleInfo.factory.create();
         Config.assetsConfig =
            PropertiesTransformer.objectToCamelCase(module["config"]);
         _modulesTotal = getModules().length;
         downloadNextModule();
      }

      private function addHttpStatusHandler(module: ModuleInfo): void {
         module.addEventListener(ExtendedModuleEvent.HTTP_STATUS, httpStatusEventHandler);
      }

      private function removeHttpStatusHandler(module: ModuleInfo): void {
         module.removeEventListener(ExtendedModuleEvent.HTTP_STATUS, httpStatusEventHandler);
      }

      private function addFailHandler(module: ModuleInfo): void
      {
         if (!retryIndefinitely && failedTimes == TIMES_TO_RETRY)
         {
            module.addEventListener(ExtendedModuleEvent.ERROR, maxDownloadFailedHandler);
         }
         else
         {
            module.addEventListener(ExtendedModuleEvent.ERROR, moduleErrorHandler);
         }
      }

      private function httpStatusEventHandler(event: ExtendedModuleEvent): void {
         removeHttpStatusHandler(ModuleInfo(event.module));
         _lastHttpStatus = event.httpStatus;
      }

      private function maxDownloadFailedHandler(e: ExtendedModuleEvent): void
      {
         _moduleInfo.removeEventListener(ExtendedModuleEvent.ERROR, maxDownloadFailedHandler);
         failedTimes = 0;
         errorText = e.errorText;
         if (STARTUP_INFO.assetsSums == null) {
            throwModuleDownloadFailedError();
         }
         reloadChecksums();
      }
      
      private function moduleErrorHandler(e: ExtendedModuleEvent = null): void
      {
         if (e != null) {
            _moduleInfo.removeEventListener(
               ExtendedModuleEvent.ERROR, moduleErrorHandler
            );
            if (!retryIndefinitely) {
               failedTimes++;
            }
            errorText = e.errorText;
         }
         var t: Timer = new Timer(1000, 1);
         t.addEventListener(TimerEvent.TIMER, reloadModule);
         t.start();
      }
      
      private function reloadModule(e: TimerEvent): void
      {
         e.currentTarget.removeEventListener(TimerEvent.TIMER, reloadModule);
         var moduleName: String = getModuleFileName(_currentModule);
         _moduleInfo.removeEventListener(ExtendedModuleEvent.PROGRESS, progressHandler);
         _moduleInfo.removeEventListener(ExtendedModuleEvent.READY, moduleReadyHandler);
         _moduleInfo.removeEventListener(ExtendedModuleEvent.READY, assetsConfigReadyHandler);
         removeHttpStatusHandler(_moduleInfo);
         _moduleInfo.release();

         _moduleInfo = new ModuleInfo(STARTUP_INFO.assetsUrl + "assets/" + moduleName);
         if (_currentModule == "AssetsConfig")
         {
            _moduleInfo.addEventListener(ExtendedModuleEvent.READY, assetsConfigReadyHandler);
         }
         else
         {
            _moduleInfo.addEventListener(ExtendedModuleEvent.READY, moduleReadyHandler);
            _moduleInfo.addEventListener(ExtendedModuleEvent.PROGRESS, progressHandler);
         }
         addHttpStatusHandler(_moduleInfo);
         addFailHandler(_moduleInfo);
         _moduleInfo.load();
      }

      /* ######################### */
      /* ### REFRESH CHECKSUMS ### */
      /* ######################### */

      private var errorText: String;
      private var failedTimes: int = 0;
      private var retryIndefinitely: Boolean = false;
      private static const TIMES_TO_RETRY: int = 10;

      private var _checksumsLoader: ChecksumsLoader;

      private function reloadChecksums(): void {
         _checksumsLoader = new ChecksumsLoader(STARTUP_INFO);
         _checksumsLoader.addEventListener(Event.COMPLETE,
            checksumsLoader_completeHandler,
            false, 0, true);
         _checksumsLoader.load();
      }

      private function checksumsLoader_completeHandler(event: Event): void {
         _checksumsLoader.removeEventListener(Event.COMPLETE,
            checksumsLoader_completeHandler,
            false);
         _checksumsLoader = null;
         if (STARTUP_INFO.assetsSums[_currentModule + '.swf'] != currentChecksumResult)
         {
            ExternalInterface.call("refresh");
         }
         else
         {
            if (_lastHttpStatus >= 400) {
               throwModuleDownloadFailedError();
            }
            else {
               const popup:ModuleLoadFailPopUp = new ModuleLoadFailPopUp();
               popup.title = getString("title");
               popup.message = getString("message", [_currentModule]);
               popup.retryButtonLabel = getString("retryLabel");
               popup.retryButtonClickHandler =
                  function (button: Button): void {
                     failedTimes = 0;
                     retryIndefinitely = true;
                     moduleErrorHandler();
                  };
               popup.show();
            }
         }
      }

      private function getString(property: String,
                                 parameters: Array = null): String {
         return Localizer.string(
            "LoadingScreen",
            "loadModule.failPopup." + property,
            parameters
         );
      }

      private function throwModuleDownloadFailedError(): void
      {
         throw new ArgumentError("Bundle '" + _currentModule + "' not found in: "
            + currentChecksumResult + "\n" +
            "Module download error: " + errorText);
      }

      private function getModuleFileName(moduleName:String): String {
         var fileName:String = moduleName + ".swf";
         if (STARTUP_INFO.assetsSums != null)
            fileName = STARTUP_INFO.assetsSums[fileName];
         return fileName
      }
      private function downloadNextModule() : void
      {
         failedTimes = 0;
         retryIndefinitely = false;
         if (_moduleInfo != null)
         {
            removeHttpStatusHandler(_moduleInfo);
            _moduleInfo.unload();
            _moduleInfo = null;
         }
         if (getModules().length == 0 && getSoundModules().length == 0)
         {
            finalizeDownload ();
            return;
         }

         var isSoundModule: Boolean = false;
         if (getModules().length == 0)
         {
            _currentModule = getSoundModules().pop();
            isSoundModule = true;
         }
         else
         {
            _currentModule = getModules().pop();
         }
         setCurrentModuleLabel();
         var moduleName: String = getModuleFileName(_currentModule);
         _moduleInfo = new ModuleInfo(STARTUP_INFO.assetsUrl + "assets/" + moduleName);
         if (isSoundModule)
         {
            _moduleInfo.addEventListener(ExtendedModuleEvent.READY, soundModuleReadyHandler);
         }
         else
         {
            _moduleInfo.addEventListener(ExtendedModuleEvent.READY, moduleReadyHandler);
         }
         _moduleInfo.addEventListener(ExtendedModuleEvent.PROGRESS, progressHandler);
         currentChecksumResult = moduleName;
         addFailHandler(_moduleInfo);
         addHttpStatusHandler(_moduleInfo);
         _moduleInfo.load();
      }
      
      private function progressHandler(e: ExtendedModuleEvent): void
      {
         setCurrentModuleLabel(e);
         dispatchProgressEvent(e);
      }
      
      private function moduleReadyHandler(e: ExtendedModuleEvent): void
      {
         e.module.removeEventListener(ExtendedModuleEvent.PROGRESS, progressHandler);
         e.module.removeEventListener(ExtendedModuleEvent.READY, moduleReadyHandler);
         dispatchProgressEvent(e);
         unpackModule(e.module);
      }

      private function soundModuleReadyHandler(e: ExtendedModuleEvent): void
      {
         e.module.removeEventListener(ExtendedModuleEvent.PROGRESS, progressHandler);
         e.module.removeEventListener(ExtendedModuleEvent.READY, moduleReadyHandler);
         dispatchProgressEvent(e);
         unpackSoundModule(e.module);
      }
      /**
       * Called when all modules have been downloaded and unpacked.
       */
      private function finalizeDownload() : void
      {
         SoundsController.loadSounds(sounds);
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
         _swfHash = moduleInfo.factory.create().getAssetsHash();
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

      private var sounds: Object = {};

      /**
       * Unpacks a sound module
       */
      private function unpackSoundModule(moduleInfo:IModuleInfo) : void
      {
         _swfHash = moduleInfo.factory.create().getAssetsHash();
         for (var name:String in _swfHash)
         {
            sounds[name] = new _swfHash[name]() as Sound;
         }
         downloadNextModule();
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
         const mLoader: LoaderObject =
                  LoaderObject(loadersHash[event.target.loader]);
         const instance:* = mLoader.loader.content;
         if (instance is MovieClip)
         {
            MovieClip(instance).stop();
            const key: String = mLoader.currentName.substring(
               0, mLoader.currentName.length - 4
            );
            _movieClips[key] = instance;
            /**
             * For Flash Player 10.x
             * 
             * Adobe changed something in 10.3 version. If I deffer unpacking of
             * frames in a MovieClip until they are actually needed,
             * goToAndStop() does not work anymore. The MovieClip completely
             * ignores number of a frame I pass and it stays on the 1st frame
             * all the time. So all unpacked frames of an animation become the
             * first frame and our animations do not seem to work anymore. All
             * this does not happen if I unpack the frames right after the SWF
             * has been loaded.
             */
            if (SystemInfo.playerMajorVersion < 11) {
               getVisualAsset(key);
            }
         }
         else {
            throw new Error(
               "Unexpected asset type " + getQualifiedClassName(instance) + " for loader "
                  + mLoader.currentName);
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
      
      
      private function dispatchProgressEvent(event:ExtendedModuleEvent) : void
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
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.system.Security;
import flash.system.SecurityDomain;
import flash.utils.ByteArray;

import mx.core.IFlexModuleFactory;
import mx.events.ModuleEvent;
import mx.events.Request;
import mx.modules.IModuleInfo;


class LoaderObject
{
   public function LoaderObject(_loader: Loader)
   {
      loader = _loader;
   }
   public var loader: Loader;
   public var currentName: String;
}


class ExtendedModuleEvent extends ModuleEvent {
   public static const SETUP: String = ModuleEvent.SETUP;
   public static const UNLOAD: String = ModuleEvent.UNLOAD;
   public static const ERROR: String = ModuleEvent.ERROR;
   public static const PROGRESS: String = ModuleEvent.PROGRESS;
   public static const READY: String = ModuleEvent.READY;
   public static const HTTP_STATUS: String = "httpStatus";
   public function ExtendedModuleEvent(type:String, module:ModuleInfo) {
      super(type, false, false, 0, 0, null, module);
   }

   public var httpStatus:int;
}

// Those are modified copies of internal classes of mx.modules.ModuleManager
// to allow access to HTTPStatus event of a Loader.


////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: ModuleInfo
//
////////////////////////////////////////////////////////////////////////////////


/**
 *  @private
 *  The ModuleInfo class encodes the loading state of a module.
 *  It isn't used directly, because there needs to be only one single
 *  ModuleInfo per URL, even if that URL is loaded multiple times,
 *  yet individual clients need their own dedicated events dispatched
 *  without re-dispatching to clients that already received their events.
 *  ModuleInfoProxy holds the public IModuleInfo implementation
 *  that can be externally manipulated.
 */
class ModuleInfo extends EventDispatcher implements IModuleInfo
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function ModuleInfo(url:String)
    {
        super();

        _url = url;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var factoryInfo:FactoryInfo;

    /**
     *  @private
     */
    private var loader:Loader;

    /**
     *  @private
     */
    private var parentModuleFactory:IFlexModuleFactory;

    //----------------------------------
    //  error
    //----------------------------------

    /**
     *  @private
     *  Storage for the error property.
     */
    private var _error:Boolean = false;

    /**
     *  @private
     */
    public function get error():Boolean
    {
        return _error;
    }

    //----------------------------------
    //  factory
    //----------------------------------

    /**
     *  @private
     */
    public function get factory():IFlexModuleFactory
    {
        return factoryInfo ? factoryInfo.factory : null;
    }

    //----------------------------------
    //  loaded
    //----------------------------------

    /**
     *  @private
     *  Storage for the loader property.
     */
    private var _loaded:Boolean = false;

    /**
     *  @private
     */
    public function get loaded():Boolean
    {
        return _loaded;
    }

    //----------------------------------
    //  ready
    //----------------------------------

    /**
     *  @private
     *  Storage for the ready property.
     */
    private var _ready:Boolean = false;

    /**
     *  @private
     */
    public function get ready():Boolean
    {
        return _ready;
    }

    //----------------------------------
    //  setup
    //----------------------------------

    /**
     *  @private
     *  Storage for the setup property.
     */
    private var _setup:Boolean = false;

    /**
     *  @private
     */
    public function get setup():Boolean
    {
        return _setup;
    }

    //----------------------------------
    //  size
    //----------------------------------

    /**
     *  @private
     */
    public function get size():int
    {
        return factoryInfo ? factoryInfo.bytesTotal : 0;
    }

    //----------------------------------
    //  url
    //----------------------------------

    /**
     *  @private
     *  Storage for the url property.
     */
    private var _url:String;

    /**
     *  @private
     */
    public function get url():String
    {
        return _url;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    public function load(applicationDomain:ApplicationDomain = null,
                         securityDomain:SecurityDomain = null,
                         bytes:ByteArray = null,
                         moduleFactory:IFlexModuleFactory = null):void
    {
        if (_loaded)
            return;

        _loaded = true;

        if (_url.indexOf("published://") == 0)
            return;

        var r:URLRequest = new URLRequest(_url);

        var c:LoaderContext = new LoaderContext();
        c.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);

        if (Security.sandboxType == Security.REMOTE)
            c.securityDomain = SecurityDomain.currentDomain;

        loader = new Loader();

        loader.contentLoaderInfo.addEventListener(
            Event.INIT, initHandler);
        loader.contentLoaderInfo.addEventListener(
            Event.COMPLETE, completeHandler);
        loader.contentLoaderInfo.addEventListener(
            ProgressEvent.PROGRESS, progressHandler);
        loader.contentLoaderInfo.addEventListener(
            HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
        loader.contentLoaderInfo.addEventListener(
            IOErrorEvent.IO_ERROR, errorHandler);
        loader.contentLoaderInfo.addEventListener(
            SecurityErrorEvent.SECURITY_ERROR, errorHandler);

        loader.load(r, c);
    }

    /**
     *  @private
     */
    public function release():void
    {
        // If the module is ready, then keep it in the
        // module dictionary.
        if (!_ready)
        {
            // Otherwise we just drop it
            unload();
        }
    }

    /**
     *  @private
     */

    private function clearLoader():void
    {
        if (loader)
        {
            if (loader.contentLoaderInfo)
            {
                loader.contentLoaderInfo.removeEventListener(
                    Event.INIT, initHandler);
                loader.contentLoaderInfo.removeEventListener(
                    Event.COMPLETE, completeHandler);
                loader.contentLoaderInfo.removeEventListener(
                    ProgressEvent.PROGRESS, progressHandler);
                loader.contentLoaderInfo.removeEventListener(
                    HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
                loader.contentLoaderInfo.removeEventListener(
                    IOErrorEvent.IO_ERROR, errorHandler);
                loader.contentLoaderInfo.removeEventListener(
                    SecurityErrorEvent.SECURITY_ERROR, errorHandler);
            }

            try
            {
                if (loader.content)
                {
                    loader.content.removeEventListener("ready", readyHandler);
                    loader.content.removeEventListener("error", moduleErrorHandler);
                }
            }
            catch(error:Error)
            {
                // we might get unloaded because of a security error
                // which will disallow access to loader.content
                // so if we get an error here, just ignore it.
            }


            if (_loaded)
            {
                try
                {
                    loader.close();
                }
                catch(error:Error)
                {
                }
            }

            try
            {
                loader.unload();
            }
            catch(error:Error)
            {
            }

            loader = null;
        }
    }
    /**
     *  @private
     */
    public function unload():void
    {
        clearLoader();

        if (_loaded)
            dispatchEvent(new ExtendedModuleEvent(ExtendedModuleEvent.UNLOAD, this));

        factoryInfo = null;
        parentModuleFactory = null;
        _loaded = false;
        _setup = false;
        _ready = false;
        _error = false;
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    public function initHandler(event:Event):void
    {
        //trace("child load of " + _url + " fired init");

        factoryInfo = new FactoryInfo();

        try
        {
            factoryInfo.factory = loader.content as IFlexModuleFactory;
        }
        catch(error:Error)
        {
        }

        if (!factoryInfo.factory)
        {
            var moduleEvent:ExtendedModuleEvent = new ExtendedModuleEvent(ExtendedModuleEvent.ERROR, this);
            moduleEvent.bytesLoaded = 0;
            moduleEvent.bytesTotal = 0;
            moduleEvent.errorText = "SWF is not a loadable module";
            dispatchEvent(moduleEvent);
            return;
        }

        loader.content.addEventListener("ready", readyHandler);
        loader.content.addEventListener("error", moduleErrorHandler);
        loader.content.addEventListener(Request.GET_PARENT_FLEX_MODULE_FACTORY_REQUEST,
                                        getFlexModuleFactoryRequestHandler, false, 0, true);

        try
        {
            factoryInfo.applicationDomain =
                loader.contentLoaderInfo.applicationDomain;
        }
        catch(error:Error)
        {
        }
        _setup = true;

        dispatchEvent(new ExtendedModuleEvent(ExtendedModuleEvent.SETUP, this));
    }

    /**
     *  @private
     */
    public function progressHandler(event:ProgressEvent):void
    {
        var moduleEvent:ExtendedModuleEvent = new ExtendedModuleEvent(ExtendedModuleEvent.PROGRESS, this);
        moduleEvent.bytesLoaded = event.bytesLoaded;
        moduleEvent.bytesTotal = event.bytesTotal;
        dispatchEvent(moduleEvent);
    }

    public function httpStatusHandler(event:HTTPStatusEvent):void
    {
       var moduleEvent:ExtendedModuleEvent = new ExtendedModuleEvent(ExtendedModuleEvent.HTTP_STATUS, this);
       moduleEvent.httpStatus = event.status;
       dispatchEvent(moduleEvent);
    }

    /**
     *  @private
     */
    public function completeHandler(event:Event):void
    {
        //trace("child load of " + _url + " is complete");

        var moduleEvent:ExtendedModuleEvent = new ExtendedModuleEvent(ExtendedModuleEvent.PROGRESS, this);
        moduleEvent.bytesLoaded = loader.contentLoaderInfo.bytesLoaded;
        moduleEvent.bytesTotal = loader.contentLoaderInfo.bytesTotal;
        dispatchEvent(moduleEvent);
    }

    /**
     *  @private
     */
    public function errorHandler(event:ErrorEvent):void
    {
        _error = true;

        var moduleEvent:ExtendedModuleEvent = new ExtendedModuleEvent(ExtendedModuleEvent.ERROR, this);
        moduleEvent.bytesLoaded = 0;
        moduleEvent.bytesTotal = 0;
        moduleEvent.errorText = event.text;
        dispatchEvent(moduleEvent);

        //trace("child load of " + _url + " generated an error " + event);
    }

    /**
     *  @private
     */
    public function getFlexModuleFactoryRequestHandler(request:Request):void
    {
        request.value = parentModuleFactory;
    }

    /**
     *  @private
     */
    public function readyHandler(event:Event):void
    {
        //trace("child load of " + _url + " is ready");

        _ready = true;

        factoryInfo.bytesTotal = loader.contentLoaderInfo.bytesTotal;

        var moduleEvent:ExtendedModuleEvent = new ExtendedModuleEvent(ExtendedModuleEvent.READY, this);
        moduleEvent.bytesLoaded = loader.contentLoaderInfo.bytesLoaded;
        moduleEvent.bytesTotal = loader.contentLoaderInfo.bytesTotal;

        clearLoader();

        dispatchEvent(moduleEvent);
    }

    /**
     *  @private
     */
    public function moduleErrorHandler(event:Event):void
    {
        //trace("Error: child load of " + _url + ");

        _ready = true;

        factoryInfo.bytesTotal = loader.contentLoaderInfo.bytesTotal;

        clearLoader();

        var errorEvent:ExtendedModuleEvent;

        if (event is ExtendedModuleEvent)
            errorEvent = ExtendedModuleEvent(event);
        else
            errorEvent = new ExtendedModuleEvent(ExtendedModuleEvent.ERROR, this);

        dispatchEvent(errorEvent);
    }

   public function get data(): Object {
      return null;
   }

   public function set data(value: Object): void {
   }

   public function publish(factory: IFlexModuleFactory): void {
   }
}


////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: FactoryInfo
//
////////////////////////////////////////////////////////////////////////////////

/**
 *  @private
 *  Used for weak dictionary references to a GC-able module.
 */
class FactoryInfo
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function FactoryInfo()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  factory
    //----------------------------------

    /**
     *  @private
     */
    public var factory:IFlexModuleFactory;

    //----------------------------------
    //  applicationDomain
    //----------------------------------

    /**
     *  @private
     */
    public var applicationDomain:ApplicationDomain;

    //----------------------------------
    //  bytesTotal
    //----------------------------------

    /**
     *  @private
     */
    public var bytesTotal:int = 0;
}