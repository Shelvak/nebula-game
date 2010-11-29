package components.gameobjects.planet
{
   import components.base.Spinner;
   import components.base.SpinnerContainer;
   
   import models.events.BaseModelEvent;
   
   import mx.graphics.BitmapFillMode;
   
   import spark.components.Group;
   import spark.primitives.BitmapImage;
   
   
   public class InteractivePlanetMapObject extends Group implements IInteractivePlanetMapObject
   {
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      /**
       * Constructor.
       */
      public function InteractivePlanetMapObject()
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      
      /**
       * @copy components.gameobjects.planet.PrimitivePlanetMapObject#initProperties()
       */
      protected function initProperties() : void
      {
         width  = model.imageWidth;
         height = model.imageHeight;
         addModelEventListeners(model);
         setDepth();
      }
      
      
      public function cleanup() : void
      {
         if (_spinner)
         {
            _spinnerContainer.removeElement(_spinner);
            _spinnerContainer = null;
            _spinner.cleanup();
            _spinner = null;
         }
         if (model)
         {
            removeModelEventListeners(model);
            _model = null;
         }
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      include "mixin_defaultModelPropImpl.as";
      include "mixin_zIndexChangeHandler.as";
      
      
      private var _selected:Boolean = false;
      public function set selected(v:Boolean) : void
      {
         if (_selected != v)
         {
            _selected = v;
            f_selectedChanged = true;
            invalidateProperties();
         }
      }
      public function get selected() : Boolean
      {
         return _selected;
      }
      
      
      private var _faded:Boolean = false;
      public function set faded(v:Boolean) :void
      {
         if (_faded != v)
         {
            _faded = v;
            f_fadedChanged = true;
            invalidateProperties();
         }
      }
      public function get faded():Boolean
      {
         return _faded;
      }
      
      
      public function setDepth() : void
      {
         depth = model.zIndex;
      }
      
      
      private var f_fadedChanged:Boolean = true,
                  f_pendingChanged:Boolean = true,
                  f_selectedChanged:Boolean = true;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (f_fadedChanged)
         {
            if (faded)
            {
               alpha = 0.4;
            }
            else
            {
               alpha = 1;
            }
         }
         if (f_pendingChanged && _spinner)
         {
            if (model.pending)
            {
               _spinnerContainer.visible = true;
               _spinner.play();
            }
            else
            {
               _spinner.stop();
               _spinnerContainer.visible = false;
            }
         }
         if (f_selectedChanged)
         {
            basement.visible = selected;
         }
         f_fadedChanged = f_pendingChanged = f_selectedChanged = false;
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      /**
       * Image component that holds picture of the object.
       */
      protected var mainImage:BitmapImage;
      
      
      /**
       * This will be used for indication of <code>pending</code> state.
       */
      private var _spinner:Spinner;
      
      
      /**
       * BtimapImage (Spinner) has to be wrapped by a container to function properly.
       */      
      private var _spinnerContainer:Group;
      
      
      /**
       * This lets user see the basement of the object. Is only displayed when
       * the object is selected.
       */
      protected var basement:PlanetObjectBasement;
      
      
      protected override function createChildren() : void
      {
         super.createChildren();
         
         basement = new PlanetObjectBasement();
         basement.logicalWidth = model.width;
         basement.logicalHeight = model.height;
         basement.right = basement.bottom = 0;
         basement.alpha = 0.3;
         basement.depth = -1000;
         addElement(basement);
         
         mainImage = new BitmapImage();
         mainImage.smooth = true;
         mainImage.fillMode = BitmapFillMode.CLIP;
         mainImage.source = model.imageData;
         addElement(mainImage);
         
         _spinner = new Spinner();
         _spinnerContainer = new Group();
         _spinnerContainer.addElement(_spinner);
         _spinnerContainer.verticalCenter =
         _spinnerContainer.horizontalCenter = 0;
         _spinnerContainer.depth = 1000;
         addElement(_spinnerContainer);
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      public function select() : void
      {
         selected = true;
      }
      
      
      public function deselect() : void
      {
         selected = false;
      }
      
      
      public function toggleSelection() : void
      {
         selected = !selected;
      }
      
      
      /* ############################# */
      /* ### MODEL EVENTS HANDLERS ### */
      /* ############################# */
      
      
      protected function addModelEventListeners(model:PlanetObject) : void
      {
         addModelZIndexChangeHandler(model);
         model.addEventListener(BaseModelEvent.PENDING_CHANGE, model_pendingChangeHandler);
      }
      
      
      protected function removeModelEventListeners(model:PlanetObject) : void
      {
         removeModelZIndexChangeHandler(model);
         model.removeEventListener(BaseModelEvent.PENDING_CHANGE, model_pendingChangeHandler);
      }
      
      
      private function model_pendingChangeHandler(event:BaseModelEvent) : void
      {
         f_pendingChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
   }
}