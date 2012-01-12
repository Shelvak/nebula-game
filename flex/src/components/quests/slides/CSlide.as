package components.quests.slides
{
   import com.greensock.events.LoaderEvent;
   import com.greensock.loading.ImageLoader;
   import com.greensock.loading.LoaderMax;
   import com.greensock.loading.data.LoaderMaxVars;
   import com.greensock.loading.display.ContentDisplay;

   import flash.display.Bitmap;
   import flash.display.BitmapData;

   import models.quest.events.MMainQuestSlideEvent;
   import models.quest.slides.MSlide;

   import spark.components.Group;
   import spark.primitives.BitmapImage;

   import utils.Events;
   import utils.Objects;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;


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
            imageLoaders.push(new ImageLoader(imageUrl));
         }
         const loader:LoaderMax = new LoaderMax(
            new LoaderMaxVars()
                  .loaders(imageLoaders)
                  .onComplete(loader_completeHandler)
                  .onFail(loader_failHandler)
         );
         _model.loading = true;
         loader.autoDispose = true;
         loader.load();
      }

      private function loader_completeHandler(event:LoaderEvent): void {
         const loader:LoaderMax = LoaderMax(event.target);
         const images:Object = new Object();
         for each (var imageLoader:ImageLoader in loader.getChildren()) {
            images[imageLoader.url] =
               Bitmap(ContentDisplay(imageLoader.content).rawContent)
                  .bitmapData;
         }
         imagesLoaded(images);
         _model.loading = false;
      }

      private function loader_failHandler(event:LoaderEvent): void {
         _model.loading = false;
         trace("LoaderMax failed:", event.text);
      }

      protected function imagesLoaded(images:Object): void {
         imgBackground.source = images[getBackgroundImageUrl()];
      }
   }
}
