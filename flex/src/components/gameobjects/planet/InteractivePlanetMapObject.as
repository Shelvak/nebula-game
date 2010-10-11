package components.gameobjects.planet
{
   import components.base.SpinnerContainer;
   
   import models.events.BaseModelEvent;
   
   import mx.graphics.BitmapFillMode;
   
   import spark.components.Group;
   import spark.primitives.BitmapImage;
   
   
   /**
    * Alpha value of component when it is in normal state.
    */
   [Style(name="alphaNormal", type="Number", format="Number")]
   
   /**
    * Alpha value if the component when <code>faded</code>
    * is set to <code>true</code>.
    */
   [Style(name="alphaFaded", type="Number", format="Number")]
   
   
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
      }
      
      
      public function cleanup() : void
      {
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
            fSelectedChanged = true;
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
            fFadedChanged = true;
            invalidateProperties();
         }
      }
      public function get faded():Boolean
      {
         return _faded;
      }
      
      
      /**
       * Sets component's alpha.
       */
      private function setAlpha() : void
      {
         if (faded)
         {
            alpha = spAlphaFaded;
         }
         else
         {
            alpha = spAlphaNormal;
         }
      };
      
      
      public function setDepth() : void
      {
         depth = model.zIndex;
      }
      
      
      private var fFadedChanged:Boolean = true;
      private var fPendingChanged:Boolean = true;
      private var fSelectedChanged:Boolean = true;
      protected override function commitProperties() : void
      {
         super.commitProperties();
         
         if (fFadedChanged)
         {
            setAlpha();
         }
         
         if (fPendingChanged)
         {
            spinnerContainer.busy = model.pending;
         }
         
         if (fSelectedChanged)
         {
            basement.visible = selected;
         }
         
         fFadedChanged = false;
         fPendingChanged = false;
         fSelectedChanged = false;
      }
      
      
      
      
      /* ############# */
      /* ### STYLE ### */
      /* ############# */
      
      
      /**
       * Defines the name of alphaNormal style property.
       */
      public static const SP_ALPHA_NORMAL:String = "alphaNormal";
      private function get spAlphaNormal() : Number
      {
         var value:* = getStyle(SP_ALPHA_NORMAL);
         if (value == undefined)
         {
            value = 1;
         }
         return value;
      }
      
      
      /**
       * Defines the name of alphaFaded style property.
       */
      public static const SP_ALPHA_FADED:String = "alphaFaded";
      private function get spAlphaFaded() : Number
      {
         var value:* = getStyle(SP_ALPHA_FADED);
         if (value == undefined)
         {
            value = 0.4;
         }
         return value;
      }
      
      
      public override function styleChanged(styleProp:String) : void
      {
         switch(styleProp)
         {
            case SP_ALPHA_NORMAL:
            case SP_ALPHA_FADED:
               setAlpha();
               break;
            
            default:
               super.styleChanged(styleProp);
         }
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
      protected var spinnerContainer:SpinnerContainer;
      
      
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
         basement.setStyle("chromeColor", 0x00FF00);
         addElement(basement);
         
         mainImage = new BitmapImage();
         mainImage.smooth = true;
         mainImage.fillMode = BitmapFillMode.CLIP;
         mainImage.source = model.imageData;
         addElement(mainImage);
         
         spinnerContainer = new SpinnerContainer();
         spinnerContainer.width = width;
         spinnerContainer.height = height;
         spinnerContainer.depth = 1000;
         spinnerContainer.timeoutEnabled = false;
         addElement(spinnerContainer);
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
         fPendingChanged = true;
         invalidateProperties();
      }
   }
}