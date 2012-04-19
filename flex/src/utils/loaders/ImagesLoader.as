package utils.loaders
{
   import com.greensock.events.LoaderEvent;
   import com.greensock.loading.ImageLoader;
   import com.greensock.loading.LoaderMax;
   import com.greensock.loading.data.LoaderMaxVars;

   import components.popups.ErrorPopUp;

   import controllers.startup.ChecksumsLoader;

   import controllers.startup.StartupInfo;

   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.utils.Timer;

   import spark.components.Button;

   import utils.Objects;
   import utils.locale.Localizer;


   public class ImagesLoader
   {
      private static const TIME_BETWEEN_RETRIES: Number = 5000;

      private var _urlProvider: IUrlProvider;
      private var _imageUrls: Array;
      private var _imagesToLoad: Array;
      private var _onComplete: Function;
      private var _onFail: Function;
      private var _maxNumOfRetries: int;
      private var _errorOnFail: Boolean;

      /**
       * @param urlProvider
       * @param onComplete invoked when all images have been loaded successfully
       * @param errorOnFail should an error be thrown if images could not be loaded
       * @param onFail invoked if loading of some ar all images has failed and
       *               errorOnFail == false
       * @param numOfRetries number of times to retry loading of failed
       *                     images again before failing | <b> &gt;= 0</b>
       */
      public function ImagesLoader(urlProvider: IUrlProvider,
                                   onComplete: Function,
                                   errorOnFail: Boolean = true,
                                   onFail: Function = null,
                                   numOfRetries: int = 4) {
         _urlProvider = Objects.paramNotNull("urlProvider", urlProvider);
         _imageUrls = _urlProvider.getUrlsToLoad();
         _imagesToLoad = _imageUrls.slice();
         _onComplete = Objects.paramNotNull("onComplete", onComplete);
         _maxNumOfRetries = Objects.paramPositiveNumber("numOfRetries", numOfRetries);
         _errorOnFail = errorOnFail;
         _onFail = onFail;
         startLoading();
      }

      private const _loadedImages: Object = new Object();
      public function get loadedImages(): Object {
         return _loadedImages;
      }
      public function getImage(url: String): BitmapData {
         return _loadedImages[url];
      }

      private var _failedImages: Array;
      private var _loader: LoaderMax;
      private var _attempt: int = 0;

      private function startLoading(): void {
         disposeLoaderAndTimer();
         _attempt++;
         if (_attempt > _maxNumOfRetries + 1) {
            validateChecksums();
         }
         _failedImages = new Array();
         _loader = new LoaderMax(
            new LoaderMaxVars()
               .autoDispose(true)
               .skipFailed(true)
               .onChildComplete(loader_onChildComplete)
               .onChildFail(loader_onChildFail)
               .onComplete(loader_onComplete)
         );
         for each (var url: String in _imagesToLoad) {
            _loader.append(new ImageLoader(url));
         }
         _loader.load();
      }

      private function disposeLoaderAndTimer():void {
         if (_loader != null) {
            _loader.dispose(true);
            _loader = null;
         }
         if (_timer != null) {
            _timer.stop();
            _timer.removeEventListener(
               TimerEvent.TIMER_COMPLETE, timer_timerCompleteHandler, false
            );
            _timer = null;
         }
      }

      private function loader_onChildComplete(event: LoaderEvent): void {
         const loader: ImageLoader = ImageLoader(event.target);
         const url: String = loader.url;
         _imagesToLoad.splice(_imagesToLoad.indexOf(url), 1);
         loadedImages[url] = Bitmap(loader.rawContent).bitmapData;
      }

      private function loader_onChildFail(event: LoaderEvent): void {
         const loader: ImageLoader = ImageLoader(event.target);
         _failedImages.push(new FailedImage(loader.url, event.text));
      }

      private function loader_onComplete(event: LoaderEvent): void {
         if (_failedImages.length == 0) {
            disposeLoaderAndTimer();
            if (_onComplete != null) {
               _onComplete.call();
            }
         }
         else {
            waitAndRetry();
         }
      }

      private var _timer: Timer;

      private function createTimer(): void {
         if (_timer == null) {
            _timer = new Timer(TIME_BETWEEN_RETRIES, 1);
         }
      }

      private function waitAndRetry(): void {
         createTimer();
         _timer.addEventListener(
            TimerEvent.TIMER_COMPLETE,
            timer_timerCompleteHandler, false, 0, true
         );
         _timer.start();
      }

      private function timer_timerCompleteHandler(event: TimerEvent): void {
         startLoading();
      }


      private var _checksumsLoader: ChecksumsLoader;
      private function get startupInfo(): StartupInfo {
         return StartupInfo.getInstance();
      }

      private function validateChecksums(): void {
         if (startupInfo.unbundledAssetsSums == null) {
            fail();
         }
         else {
            _checksumsLoader = new ChecksumsLoader(startupInfo);
            _checksumsLoader.addEventListener(
               Event.COMPLETE, checksumsLoader_completeHandler, false, 0, true
            );
            _checksumsLoader.load();
         }
      }

      private function checksumsLoader_completeHandler(event: Event): void {
         _checksumsLoader.removeEventListener(
            Event.COMPLETE, checksumsLoader_completeHandler, false
         );
         _checksumsLoader = null;
         var newImagesUrls: Array = _urlProvider.getUrlsToLoad();
         for (var i: int = 0; i < _imageUrls.length; i++) {
            if (_imageUrls[i] != newImagesUrls[i]) {
               const popUp: ErrorPopUp = new ErrorPopUp();
               popUp.title = getString("title.outdatedClient");
               popUp.message = getString("message.outdatedClient");
               popUp.retryButtonLabel = getString("label.refresh");
               popUp.showCancelButton = false;
               popUp.showRetryButton = true;
               popUp.retryButtonClickHandler = popupRetryButton_clickHandler;
               popUp.show();
               disposeLoaderAndTimer();
               return;
            }
         }
         disposeLoaderAndTimer();
         fail();
      }

      private function popupRetryButton_clickHandler(button: Button): void {
         ExternalInterface.call("refresh");
      }

      private function getString(property: String): String {
         return Localizer.string("Popups", property);
      }

      private function fail(): void {
         if (_errorOnFail) {
            throw new ArgumentError(
               "Loading of following images has failed:\n"
                  + _failedImages.join("\n   ")
            );
         }
         if (_onFail != null) {
            _onFail.call();
         }
      }
   }
}


class FailedImage
{
   public function FailedImage(imageUrl: String, errorText: String): void {
      super();
      _imageUrl = imageUrl;
      _errorText = errorText;
   }

   private var _imageUrl: String;
   private var _errorText: String;

   public function toString(): String {
      return "[imageUrl: '" + _imageUrl + "', errorText: '" + _errorText + "']";
   }
}
