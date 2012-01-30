package components.map.planet.objects
{
   import models.planet.MPlanetObject;
   import models.planet.events.MPlanetObjectEvent;

   import mx.core.UIComponent;

   import spark.components.Group;
   import spark.primitives.BitmapImage;

   import utils.Objects;


   public class CObjectPlaceholder extends Group implements IPrimitivePlanetMapObject
   {
      public function CObjectPlaceholder() {
         super();
         mouseEnabled = false;
         mouseChildren = false;
         focusEnabled = false;
      }

      public function cleanup(): void {
         _model = null;
         _mainImage = null;
      }

      private var _model: MPlanetObject;
      public function get model(): MPlanetObject {
         return _model;
      }

      public function initModel(model: MPlanetObject): void {
         if (_model != model) {
            if (_model != null) {
               _model.removeEventListener(
                  MPlanetObjectEvent.IMAGE_CHANGE,
                  model_imageChangeHandler, false
               );
            }
            _model = model;
            if (_model != null) {
               _model.addEventListener(
                  MPlanetObjectEvent.IMAGE_CHANGE,
                  model_imageChangeHandler, false, 0, true
               );
            }
            f_modelChanged = true;
            invalidateProperties();
         }
      }

      private function model_imageChangeHandler(event: MPlanetObjectEvent): void {
         setImageSourceAndDimensions();
      }

      private function setImageSourceAndDimensions(): void {
         if (_model != null) {
            width = _model.imageWidth;
            height = _model.imageHeight;
            _mainImage.source = _model.imageData;
         }
      }

      private var f_modelChanged: Boolean = true;

      override protected function commitProperties(): void {
         super.commitProperties();
         if (f_modelChanged) {
            commitModel();
         }
         f_modelChanged = false;
      }

      protected function commitModel(): void {
         setImageSourceAndDimensions();
      }

      
      /* ################################# */
      /* ### IPrimitivePlanetMapObject ### */
      /* ################################# */

      public function setDepth(): void {
      }
      

      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */

      protected function createBasement(): UIComponent {
         Objects.throwAbstractMethodError();
         return null;   // unreachable
      }

      private var _mainImage:BitmapImage;
      protected override function createChildren(): void {
         super.createChildren();

         const basement: UIComponent = createBasement();
         basement.alpha = 0.3;
         addElement(basement);

         _mainImage = new BitmapImage();
         addElement(_mainImage);
      }
   }
}
