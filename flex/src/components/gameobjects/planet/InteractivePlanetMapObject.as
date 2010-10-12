package components.gameobjects.planet
{
   import components.base.SpinnerContainer;
   import components.skins.InteractivePlanetMapObjectSkin;
   
   import models.events.BaseModelEvent;
   
   import mx.graphics.BitmapFillMode;
   
   import spark.components.supportClasses.SkinnableComponent;
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
   
   
   public class InteractivePlanetMapObject extends SkinnableComponent implements IInteractivePlanetMapObject
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
         setStyle("skinClass", InteractivePlanetMapObjectSkin);
      }
      
      
      /**
       * @copy components.gameobjects.planet.PrimitivePlanetMapObject#initProperties()
       */
      protected function initProperties() : void
      {
         width  = model.imageWidth;
         height = model.imageHeight;
         setMainImageSource();
         setDepth();
         
         addModelEventListeners(model);
         
         fFadedChanged = true;
         fPendingChanged = true;
         invalidateProperties();
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
      [Bindable]
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
      [Bindable]
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
      
      
      private var fFadedChanged:Boolean = false;
      private var fPendingChanged:Boolean = false;
      private var fSelectedChanged:Boolean = false;
      protected override function commitProperties() : void
      {
         super.commitProperties();
         
         if (fFadedChanged)
         {
            setAlpha();
         }
         
         if (fPendingChanged)
         {
            setSpinnnerContainerBusyProp();
         }
         
         if (fSelectedChanged)
         {
            setBasementVisibility();
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
      
      
      
      
      /* ############ */
      /* ### SKIN ### */
      /* ############ */
      
      
      [SkinPart(required="true")]
      /**
       * Image component that holds picture of the object.
       */
      public var mainImage:BitmapImage;
      
      
      /**
       * Sets <code>source</code> property of <code>mainImage</code>.
       */
      private function setMainImageSource() : void
      {
         if (mainImage)
         {
            mainImage.source = model.imageData;
         }
      }
      
      
      [SkinPart(required="true")]
      /**
       * This will be used for indication of <code>pending</code> state.
       */
      public var spinnerContainer:SpinnerContainer;
      
      
      /**
       * Sets <code>busy</code> property of <code>spinnerContainer</code>.
       * Sets to <code>false</code> if <code>model</code> has not been set yet.
       */
      private function setSpinnnerContainerBusyProp() : void
      {
         if (spinnerContainer)
         {
            spinnerContainer.busy = model.pending;
         }
      }
      
      
      [SkinPart(required="true")]
      /**
       * This lets user see the basement of the object. Is only displayed when
       * the object is selected.
       */
      public var basement:PlanetObjectBasement;
      
      
      /**
       * Sets <code>visible</code> property of <code>basement</code>.
       */
      private function setBasementVisibility() : void
      {
         if (basement)
         {
            basement.visible = selected;
         }
      }
      
      
      protected override function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName, instance);
         
         switch(instance)
         {
            case spinnerContainer:
               setSpinnnerContainerBusyProp();
               break;
            
            case basement:
               setBasementVisibility();
               break;
            
            case mainImage:
               setMainImageSource();
               mainImage.smooth = true;
               mainImage.fillMode = BitmapFillMode.CLIP;
               break;
         }
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