package components.gameobjects.building
{
   import components.gameobjects.planet.InteractivePlanetMapObject;
   import components.skins.MapBuildingSkin;
   
   import flash.display.Graphics;
   import flash.geom.Point;
   
   import models.building.Building;
   import models.building.events.BuildingEvent;
   import models.events.BaseModelEvent;
   import models.parts.events.UpgradeEvent;
   import models.planet.PlanetObject;
   
   import mx.controls.ProgressBar;
   import mx.core.UIComponent;
   import mx.events.ResizeEvent;
   import mx.graphics.BitmapFillMode;
   
   import spark.components.Group;
   import spark.primitives.BitmapImage;
   
   
   /**
    * Building component that will be on the PlanetMap.
    */
   public class MapBuilding extends InteractivePlanetMapObject
   {
      /**
       * Distance from the bottom of component level indicator will be positioned. 
       */
      public static const LEVEL_INDICATOR_OFFSET:int = 0;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      /**
       * Constructor.
       */
      public function MapBuilding ()
      {
         super();
         setStyle("skinClass", MapBuildingSkin);
      }
      
      
      override protected function initProperties() : void
      {
         super.initProperties();
         setSkinAlpha();
         setAlphaImageSource();
         positionLevelIndicator();
      }
      
      
      /* ################# */
      /* ### RENDERING ### */
      /* ################# */
      
      
      /**
       * A mask object that will be used to mask main image when construction of a building
       * is in process.
       */
      private var _imageMask:UIComponent = null;
      
      
      override protected function updateDisplayList(uw:Number, uh:Number) : void
      {
         super.updateDisplayList(uw, uh);
         if (!model)
         {
            return;
         }
         
         // Update construction progress and hit points bars
         if (pbarHPBar)
         {
            pbarHPBar.setProgress(getBuilding().hp, getBuilding().maxHp);
         }
         if (pbarConstructionProgressBar)
         {
            pbarConstructionProgressBar.setProgress(getBuilding().upgradePart.upgradeProgress, 1);
         }
         
         // Model is already set, construction has not yet completed and we have
         // imgMainImage and grpImagesContainer skin parts initialized
         if (grpImagesContainer && mainImage && !getBuilding().upgradePart.upgradeCompleted)
         {
            // Initialized _imageMask if this has not been done yet
            if (!_imageMask)
            {
               _imageMask = new UIComponent();
               grpImagesContainer.addElement(_imageMask);
               mainImage.mask = _imageMask;
            }
            
            // Now redraw and position the mask
            var newHeight:Number = height * getBuilding().upgradePart.upgradeProgress;
            newHeight = Math.max(0,      newHeight);
            newHeight = Math.min(height, newHeight);
            _imageMask.move(0, height - newHeight);
            var g:Graphics = _imageMask.graphics;
            g.clear();
            g.beginFill(0x000000);
            g.drawRect(0, 0, width, newHeight);
            g.endFill();
         }
            
         // Destroy _imgImageMask if it is still present as it is not needed anymore
         else if (_imageMask)
         {
            if (grpImagesContainer)
            {
               grpImagesContainer.removeElement(_imageMask);
            }
            if (mainImage)
            {
               mainImage.mask = null;
            }
            _imageMask = null;
         }
      }
      
      
      /**
       * @return typed reference to <code>model</code>.
       */
      public function getBuilding() : Building
      {
         return model as Building;
      }
      
      
      /* ############ */
      /* ### SKIN ### */
      /* ############ */
      
      
      private function setSkinAlpha() : void
      {
         if (skin)
         {
            if (getBuilding().isGhost)
            {
               skin.alpha = 0.5;
            }
            else
            {
               skin.alpha = 1;
            }
         }
      }
      
      
      [SkinPart(required="true")]
      /**
       * Container that holds <code>imgMainImage</code> and <code>imgAlphaImage</code>.
       * Component needs access to this skin part as it will have to hold mask component
       * for <code>imgMainImage</code>
       */
      public var grpImagesContainer:Group;
      
      
      [SkinPart(required="true")]
      /**
       * This also holds image of building but should be semi-transparent and under the main\
       * image. It will be shown when construction of a building is in progress.
       */
      public var alphaImage:BitmapImage;
      
      
      /**
       * Sets <code>source</code> property of <code>alphaImage</code>. <code>model</code>
       * must have been set before calling this method.
       */
      private function setAlphaImageSource() : void
      {
         if (alphaImage)
         {
            alphaImage.source = model.imageData;
         }
      }
      
      
      [SkinPart(required="true")]
      /**
       * Hit points indicator. 
       */
      public var pbarHPBar:ProgressBar;
      
      
      [SkinPart(required="true")]
      /**
       * Construction progress indicator. 
       */
      public var pbarConstructionProgressBar:ProgressBar;
      
      
      [SkinPart(required="true")]
      /**
       * Level indicator.
       */
      public var levelIndicator:LevelDisplay;
      
      
      /**
       * Moves level indicator its correct position.
       */
      private function positionLevelIndicator() : void
      {
         if (levelIndicator)
         {
            var corner:Point = PlanetObject.getBasementBottomCorner(model.width, model.height);
            corner.x += model.imageWidth - model.realBasementWidth - levelIndicator.width / 2;
            corner.y += model.imageHeight - model.realBasementHeight - levelIndicator.height - LEVEL_INDICATOR_OFFSET;
            levelIndicator.move(corner.x, corner.y);
         }
      }
      
      
      override protected function attachSkin() : void
      {
         super.attachSkin();
         setSkinAlpha();
      }
      
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName, instance);
         switch(instance)
         {
            case alphaImage:
               alphaImage.smooth = true;
               alphaImage.fillMode = BitmapFillMode.CLIP;
               setAlphaImageSource();
               break;
            
            case levelIndicator:
               positionLevelIndicator();
               levelIndicator.addEventListener(ResizeEvent.RESIZE, levelIndicator_resizeHandler);
               break;
         }
         invalidateDisplayList();
      }
      
      
      /* ###################### */
      /* ### EVENT HANDLERS ### */
      /* ###################### */
      
      
      override protected function addModelEventListeners(model:PlanetObject) : void
      {
         super.addModelEventListeners(model);
         var building:Building = model as Building;
         building.upgradePart.addEventListener(
            UpgradeEvent.UPGRADE_PROGRESS,
            model_upgradeProgressHandler
         );
         building.addEventListener(
            BuildingEvent.HP_CHANGE,
            model_hpChangeHandler
         );
         building.addEventListener(
            BaseModelEvent.ID_CHANGE,
            model_idChangeHandler
         );
      }
      
      
      override protected function removeModelEventListeners(model:PlanetObject) : void
      {
         super.removeModelEventListeners(model);
         var building:Building = model as Building;
         building.upgradePart.removeEventListener(
            UpgradeEvent.UPGRADE_PROGRESS,
            model_upgradeProgressHandler
         );
         building.removeEventListener(
            BuildingEvent.HP_CHANGE,
            model_hpChangeHandler
         );
         building.removeEventListener(
            BaseModelEvent.ID_CHANGE,
            model_idChangeHandler
         );
      }
      
      
      private function model_upgradeProgressHandler(event:UpgradeEvent) : void
      {
         invalidateDisplayList();
      }
      
      
      private function model_idChangeHandler(event:BaseModelEvent) : void
      {
         setSkinAlpha();
      }
      
      
      private function model_hpChangeHandler(event:BuildingEvent) : void
      {
         invalidateDisplayList();
      }
      
      
      private function levelIndicator_resizeHandler(event:ResizeEvent) : void
      {
         positionLevelIndicator();
      }
   }
}