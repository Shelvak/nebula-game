package components.gameobjects.building
{
   import components.gameobjects.planet.InteractivePlanetMapObject;
   import components.skins.MapBuildingSkin;
   
   import config.Config;
   
   import flash.display.Graphics;
   import flash.geom.Point;
   
   import models.building.Building;
   import models.building.events.BuildingEvent;
   import models.events.BaseModelEvent;
   import models.parts.events.UpgradeEvent;
   import models.planet.PlanetObject;
   
   import mx.controls.ProgressBar;
   import mx.core.UIComponent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ResizeEvent;
   import mx.graphics.BitmapFillMode;
   
   import spark.components.Group;
   import spark.primitives.BitmapImage;
   
   
   [ResourceBundle("Buildings")]
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
      
      
      public function MapBuilding ()
      {
         super();
      }
      
      
      /* ############### */
      /* ### VISUALS ### */
      /* ############### */
      
      
      /**
       * A mask object that will be used to mask main image when construction of a building
       * is in process.
       */
      private var _imageMask:UIComponent = null;
      
      
      private var f_buildingUpgradeProgressed:Boolean = true;
      private var f_buildingIdChanged:Boolean = true;
      private var f_buildingHpChanged:Boolean = true;
      private var f_buildingTypeChanged:Boolean = true;
      private var f_buildingStateChanged:Boolean = true;
      
      
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
         if (mainImage && !getBuilding().upgradePart.upgradeCompleted)
         {
            // Initialized _imageMask if this has not been done yet
            if (!_imageMask)
            {
               _imageMask = new UIComponent();
               addElement(_imageMask);
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
            removeElement(_imageMask);
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
      
      
      private function setImagesAlpha() : void
      {
         if (getBuilding().isGhost)
         {
            mainImage.alpha =  0.5;
            alpha = 0.5;
         }
         else
         {
            alpha = 1;
         }
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      /**
       * This also holds image of building but should be semi-transparent and under the main
       * image. It will be shown when construction of a building is in progress.
       */
      protected var alphaImage:BitmapImage;
      
      
      /**
       * Hit points indicator. 
       */
      protected var pbarHPBar:ProgressBar;
      
      
      /**
       * Construction progress indicator. 
       */
      protected var pbarConstructionProgressBar:ProgressBar;
      
      
      /**
       * Level indicator.
       */
      protected var levelIndicator:LevelDisplay;
      
      
      override protected function createChildren() : void
      {
         super.createChildren();
         
         if (!getBuilding().upgradePart.upgradeCompleted)
         {
            createAlphaImage();
         }
         mainImage.depth = 200;
         setImagesAlpha();
         
         levelIndicator = new LevelDisplay();
         var corner:Point = PlanetObject.getBasementBottomCorner(model.width, model.height);
         corner.x += model.imageWidth - model.realBasementWidth - levelIndicator.width / 2;
         corner.y += model.imageHeight - model.realBasementHeight - levelIndicator.height - LEVEL_INDICATOR_OFFSET;
         levelIndicator.x = corner.x;
         levelIndicator.y = corner.y;
         levelIndicator.depth = 900;
         levelIndicator.maxLevel = Config.getBuildingMaxLevel(getBuilding().type);
         addElement(levelIndicator);
      }
      
      
      private function createAlphaImage() : void
      {
         alphaImage = new BitmapImage();
         alphaImage.alpha = 0.5;
         alphaImage.source = model.imageData;
         alphaImage.smooth = true;
         alphaImage.fillMode = BitmapFillMode.CLIP;
         alphaImage.depth = 100;
         addElement(alphaImage);
      }
      
      
      /* ###################### */
      /* ### EVENT HANDLERS ### */
      /* ###################### */
      
      
      override protected function addModelEventListeners(model:PlanetObject) : void
      {
         super.addModelEventListeners(model);
         var building:Building = model as Building;
         building.upgradePart.addEventListener(UpgradeEvent.UPGRADE_PROGRESS, model_upgradeProgressHandler);
         building.addEventListener(BuildingEvent.TYPE_CHANGE, model_typeChangeHandler);
         building.addEventListener(BuildingEvent.HP_CHANGE, model_hpChangeHandler);
         building.addEventListener(BaseModelEvent.ID_CHANGE, model_idChangeHandler);
         building.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, model_propertyChangeHandler);
      }
      
      
      override protected function removeModelEventListeners(model:PlanetObject) : void
      {
         super.removeModelEventListeners(model);
         var building:Building = model as Building;
         building.upgradePart.removeEventListener(UpgradeEvent.UPGRADE_PROGRESS, model_upgradeProgressHandler);
         building.removeEventListener(BuildingEvent.TYPE_CHANGE, model_typeChangeHandler);
         building.removeEventListener(BuildingEvent.HP_CHANGE, model_hpChangeHandler);
         building.removeEventListener(BaseModelEvent.ID_CHANGE, model_idChangeHandler);
         building.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, model_propertyChangeHandler);
      }
      
      
      private function model_upgradeProgressHandler(event:UpgradeEvent) : void
      {
         if (!getBuilding().upgradePart.upgradeCompleted)
         {
            if (!alphaImage)
            {
               createAlphaImage();
            }
         }
         else
         {
            if (alphaImage)
            {
               removeElement(alphaImage);
               alphaImage = null;
            }
         }
         f_buildingUpgradeProgressed = true;
         invalidateDisplayList();
      }
      
      
      private function model_idChangeHandler(event:BaseModelEvent) : void
      {
         f_buildingIdChanged = true;
         setImagesAlpha();
      }
      
      
      private function model_hpChangeHandler(event:BuildingEvent) : void
      {
         f_buildingHpChanged = true;
         invalidateDisplayList();
      }
      
      
      private function model_typeChangeHandler(event:BuildingEvent) : void
      {
         f_buildingTypeChanged = true;
         invalidateDisplayList();
      }
      
      
      private function model_propertyChangeHandler(event:PropertyChangeEvent) : void
      {
         if (event.property == "state")
         {
            f_buildingStateChanged = true;
            invalidateDisplayList();
         }
      }
   }
}