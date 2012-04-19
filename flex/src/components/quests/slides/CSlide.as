package components.quests.slides
{
   import components.base.paging.PageModelEvent;

   import flash.display.BitmapData;

   import models.quest.slides.MSlide;

   import spark.components.Group;
   import spark.primitives.BitmapImage;

   import utils.Events;
   import utils.Objects;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   import utils.loaders.ImagesLoader;


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

      public function getImageUrlsToLoad(): Array {
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
                  PageModelEvent.VISIBLE_CHANGE,
                  model_visibleChangeHandler, false
               );
            }
            _model = value;
            if (_model != null) {
               _model.addEventListener(
                  PageModelEvent.VISIBLE_CHANGE,
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

      private function model_visibleChangeHandler(event: PageModelEvent): void {
         updateVisibility();
      }

      private function updateVisibility(): void {
         visible = _model != null ? _model.visible : false;
      }

      private var f_modelChanged: Boolean = true;
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

      private var _loader: ImagesLoader;

      private function loadImages(): void {
         _model.loading = true;
         _loader = new ImagesLoader(new UrlProvider(this), loader_onComplete);
      }

      private function loader_onComplete(): void {
         imagesLoaded(_loader.loadedImages);
         _loader = null;
         _model.loading = false;
      }

      protected function imagesLoaded(images: Object): void {
         imgBackground.source = images[getBackgroundImageUrl()];
      }
   }
}

import components.quests.slides.CSlide;

import utils.loaders.IUrlProvider;


class UrlProvider implements IUrlProvider
{
   private var _slide: CSlide;

   public function UrlProvider(slide: CSlide) {
      _slide = slide;
   }

   public function getUrlsToLoad(): Array {
      return _slide.getImageUrlsToLoad();
   }
}