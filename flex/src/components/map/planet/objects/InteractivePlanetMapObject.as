package components.map.planet.objects
{
   import mx.graphics.BitmapFillMode;

   import spark.components.Group;
   import spark.primitives.BitmapImage;


   public class InteractivePlanetMapObject extends Group implements IInteractivePlanetMapObject
   {
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */

      public function InteractivePlanetMapObject() {
         super();
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      protected function initProperties(): void {
         width = model.imageWidth;
         height = model.imageHeight;
         addModelEventListeners(model);
         setDepth();
      }

      public function cleanup(): void {
         if (model) {
            removeModelEventListeners(model);
            _model = null;
         }
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      include "mixin_defaultModelPropImpl.as";
      include "mixin_zIndexChangeHandler.as";

      private var _selected: Boolean = false;
      public function set selected(v: Boolean): void {
         if (_selected != v) {
            _selected = v;
            f_selectedChanged = true;
            invalidateProperties();
         }
      }
      public function get selected(): Boolean {
         return _selected;
      }

      private var _faded: Boolean = false;
      public function set faded(v: Boolean): void {
         if (_faded != v) {
            _faded = v;
            f_fadedChanged = true;
            invalidateProperties();
         }
      }
      public function get faded(): Boolean {
         return _faded;
      }

      public function setDepth(): void {
         depth = model.zIndex;
      }

      private var f_fadedChanged: Boolean = true;
      private var f_selectedChanged: Boolean = true;
      private var f_imageChanged: Boolean = true;

      protected override function commitProperties(): void {
         super.commitProperties();
         if (f_fadedChanged) {
            if (faded) {
               alpha = 0.4;
            }
            else {
               alpha = 1;
            }
         }
         if (f_selectedChanged) {
            basement.visible = selected;
         }
         if (f_imageChanged && model != null) {
            mainImage.source = model.imageData;
         }
         f_fadedChanged = f_selectedChanged = f_imageChanged = false;
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */

      /**
       * Container that holds <code>mainImage</code>.
       */
      protected var mainImageContainer: Group;

      /**
       * Image component that holds picture of the object. If you need to apply any filters or
       * transformations for on the <code>mainImage</code>, apply then on <code>mainImageContainer</code>
       * instead.
       */
      protected var mainImage: BitmapImage;

      /**
       * This lets user see the basement of the object. Is only displayed when
       * the object is selected.
       */
      protected var basement: PlanetObjectBasement;

      protected override function createChildren(): void {
         super.createChildren();

         basement = new PlanetObjectBasement();
         basement.logicalWidth = model.width;
         basement.logicalHeight = model.height;
         basement.right = basement.bottom = 0;
         basement.alpha = 0.3;
         basement.depth = -1000;
         basement.color = PlanetObjectBasementColor.DEFAULT;
         addElement(basement);

         mainImageContainer = new Group();
         addElement(mainImageContainer);

         mainImage = new BitmapImage();
         mainImage.smooth = true;
         mainImage.fillMode = BitmapFillMode.CLIP;
         mainImageContainer.addElement(mainImage);
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */

      public function select(): void {
         selected = true;
      }

      public function deselect(): void {
         selected = false;
      }


      /* ############################# */
      /* ### MODEL EVENTS HANDLERS ### */
      /* ############################# */

      protected function addModelEventListeners(model: MPlanetObject): void {
         addModelZIndexChangeHandler(model);
         model.addEventListener(
            MPlanetObjectEvent.IMAGE_CHANGE, model_imageChangeHandler,
            false, 0, true
         );
      }

      protected function removeModelEventListeners(model: MPlanetObject): void {
         removeModelZIndexChangeHandler(model);
         model.removeEventListener(
            MPlanetObjectEvent.IMAGE_CHANGE, model_imageChangeHandler, false
         );
      }

      private function model_imageChangeHandler(event: MPlanetObjectEvent): void {
         f_imageChanged = true;
         invalidateProperties();
      }
   }
}