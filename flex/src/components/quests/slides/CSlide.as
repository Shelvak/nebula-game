package components.quests.slides
{
   import com.greensock.events.LoaderEvent;
   import com.greensock.loading.ImageLoader;
   import com.greensock.loading.LoaderMax;
   import com.greensock.loading.data.LoaderMaxVars;
   import com.greensock.loading.display.ContentDisplay;

   import components.popups.ErrorPopUp;

   import controllers.startup.ChecksumsLoader;
   import controllers.startup.StartupInfo;

   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.utils.Timer;

   import models.quest.events.MMainQuestSlideEvent;
   import models.quest.slides.MSlide;

   import spark.components.Button;

   import spark.components.Group;
   import spark.primitives.BitmapImage;

   import utils.Events;
   import utils.Objects;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   import utils.locale.Localizer;


   [Event(name="visibleChange", type="components.quests.slides.CSlideEvent")]
   [Event(name="modelChange", type="components.quests.slides.CSlideEvent")]

   public class CSlide extends Group
   {
      public function CSlide() {
         super();
      }

      protected function getImage(name:String): BitmapData {
         return ImagePreloader.getInstance().getImage(
            AssetNames.MAIN_QUEST_IMAGES_FOLDER + name
         );
      }

      protected function getImageUrlsToLoad(): Array {
         return [getBackgroundImageUrl()];
      }

      protected function getBackgroundImageUrl(): String {
         Objects.throwAbstractMethodError();
         return null;   // unreachable
      }

      private var imgBackground:BitmapImage;

      private var f_childrenCreated:Boolean = false;
      protected function get childrenAlreadyCreated():Boolean {
         return f_childrenCreated;
      }
      protected override function createChildren(): void {
         super.createChildren();
         if (f_childrenCreated) {
            return;
         }
         f_childrenCreated = true;

         imgBackground = new BitmapImage();
         addElementAt(imgBackground, 0);
         imgBackground.left = 0;
         imgBackground.right = 0;
         imgBackground.top = 0;
         imgBackground.bottom = 0;
      }

      private var _model:MSlide;
      [Bindable(event="modelChange")]
      public function set model(value: MSlide): void {
         if (_model != value) {
            if (_model != null) {
               _model.removeEventListener(
                  MMainQuestSlideEvent.VISIBLE_CHANGE,
                  model_visibleChangeHandler, false
               );
            }
            _model = value;
            if (_model != null) {
               _model.addEventListener(
                  MMainQuestSlideEvent.VISIBLE_CHANGE,
                  model_visibleChangeHandler, false, 0, true
               );
            }
            updateVisibility();
            Events.dispatchSimpleEvent(
               this, CSlideEvent, CSlideEvent.MODEL_CHANGE
            );
            f_modelChanged = true;
            invalidateProperties();
         }
      }
      public function get model(): MSlide {
         return _model;
      }

      private function model_visibleChangeHandler(event:MMainQuestSlideEvent): void {
         updateVisibility();
      }

      private function updateVisibility(): void {
         visible = _model != null ? _model.visible : false;
      }

      private var f_modelChanged:Boolean = true;
      protected override function commitProperties(): void {
         super.commitProperties();
         if (f_modelChanged) {
            modelCommit();
         }
         f_modelChanged = false;
      }

      protected function modelCommit(): void {
         loadImages();
      }

      private function loadImages(): void {
         const imageLoaders:Array = new Array();
         for each (var imageUrl:String in getImageUrlsToLoad()) {
            try {
               imageLoaders.push(new ImageLoader(imageUrl));
            }
            catch (e: Error) {
               throw new Error("Error while creating ImageLoader for " +
                  imageUrl + "!\n\n" + e.name + "\n\n" + e.message);
            }
         }
         activeLoaderChilds = getImageUrlsToLoad().length;
         loader = new LoaderMax(
            new LoaderMaxVars()
               .loaders(imageLoaders)
               .onChildComplete(loader_childCompleteHandler)
               .onFail(loader_failHandler)
               .onChildFail(loader_childFailHandler)
         );
         _model.loading = true;
         loader.autoDispose = true;
         loader.load(true);
      }

      private var activeLoaderChilds: int = 0;
      private var failedCount: int = 0;
      private static const MAX_FAILED_COUNT: int = 10;
      private var loader: LoaderMax;

      private function loader_completeHandler(failed: Boolean = false): void {
         activeLoaderChilds--;
         if (activeLoaderChilds > 0 && !failed)
         {
            return;
         }
         const images:Object = new Object();
         for each (var imageLoader:ImageLoader in loader.getChildren()) {
            try {
               images[imageLoader.url] =
                  Bitmap(ContentDisplay(imageLoader.content).rawContent)
                     .bitmapData;
            }
            catch (e: Error)
            {
               failedImageUrl = imageLoader.url;
               fErrorMessage = e.message;
               checkChecksums();
            }
         }
         imagesLoaded(images);
         loader = null;
         _model.loading = false;
      }
      
      private function checkChecksums(): void
      {
         if (STARTUP_INFO.unbundledAssetsSums == null)
         {
            throwBundleFailedError();
         }
         oldImagesUrls = getImageUrlsToLoad();
         reloadChecksums();
      }

      /* ######################### */
      /* ### REFRESH CHECKSUMS ### */
      /* ######################### */
      
      private var failedImageUrl: String;
      private var fErrorMessage: String;

      private function get STARTUP_INFO() : StartupInfo {
         return StartupInfo.getInstance();
      }

      private var oldImagesUrls: Array;
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
         var checksumChanged: Boolean = false;
         var newImagesUrls: Array = getImageUrlsToLoad();
         for (var i: int = 0; i < oldImagesUrls.length; i++)
         {
            if (oldImagesUrls[i] != newImagesUrls[i])
            {
               checksumChanged = true;
            }
         }
         if (checksumChanged)
         {
            var popUp: ErrorPopUp = new ErrorPopUp();
            popUp.retryButtonLabel = Localizer.string('Popups', 'label.refresh');
            popUp.showCancelButton = false;
            popUp.showRetryButton = true;
            popUp.message = Localizer.string('Popups', 'message.outdatedClient');
            popUp.title = Localizer.string('Popups', 'title.outdatedClient');
            popUp.retryButtonClickHandler = function (button: Button = null): void
            {
               ExternalInterface.call("refresh");
            };
            popUp.show();
         }
         else
         {
            throwBundleFailedError();
         }
      }

      private function throwBundleFailedError(): void
      {
         throw new ArgumentError("Quest screen background: " + failedImageUrl +
            " not found!\n" + fErrorMessage);
      }

      private function loader_failHandler(event:LoaderEvent): void {
         _model.loading = false;
         trace("LoaderMax failed:", event.text);
      }
      
      private function loader_childCompleteHandler(event:LoaderEvent): void {
         loader_completeHandler();
      }

      private function loader_childFailHandler(event:LoaderEvent): void {
         failedCount++;
         if (failedCount != MAX_FAILED_COUNT)
         {
            var t: Timer = new Timer(1000, 1);
            function reloadLoader(e: TimerEvent): void
            {
               loadImages();
               t.removeEventListener(TimerEvent.TIMER, reloadLoader);
               t = null;
            }
            t.addEventListener(TimerEvent.TIMER, reloadLoader);
            t.start();
         }
         else
         {
            loader_completeHandler(true);
         }
      }

      protected function imagesLoaded(images:Object): void {
         imgBackground.source = images[getBackgroundImageUrl()];
      }
   }
}
