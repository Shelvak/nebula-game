package components.quests.slides
{
   import flash.display.BitmapData;

   import models.quest.slides.MSlide;
   import models.quest.events.MMainQuestSlideEvent;

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

      protected function getBackgroundImageId(): int {
//         Objects.throwAbstractMethodError();
         return 0;   // unreachable
      }

      private var imgBackground:BitmapImage;

      private var f_childrenCreated:Boolean = false;
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
         imgBackground.source =
            getImage("slide_background" + getBackgroundImageId());
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
   }
}
