package components.gameobjects.building
{
   import components.gameobjects.planet.InteractivePlanetMapObject;
   
   import config.Config;
   
   import flash.display.Graphics;
   import flash.geom.Point;
   
   import models.building.Building;
   import models.building.events.BuildingEvent;
   import models.events.BaseModelEvent;
   import models.parts.events.UpgradeEvent;
   import models.planet.PlanetObject;
   
   import mx.controls.ProgressBar;
   import mx.controls.ProgressBarLabelPlacement;
   import mx.controls.ProgressBarMode;
   import mx.core.UIComponent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ResizeEvent;
   import mx.graphics.BitmapFillMode;
   
   import spark.primitives.BitmapImage;
   
   
   [ResourceBundle("Buildings")]
   /**
    * Building component that will be on the PlanetMap.
    */
   public class MapBuilding extends InteractivePlanetMapObject
   {
      private static const LEVEL_INDICATOR_OFFSET:int = 0;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      public function MapBuilding ()
      {
         super();
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      public override function set selected(value:Boolean) : void
      {
         if (super.selected != value)
         {
            super.selected = value;
            f_selectionChanged = true;
            invalidateDisplayList();
         }
      }
      
      
      /* ############### */
      /* ### VISUALS ### */
      /* ############### */
      
      
      /**
       * A mask object that will be used to mask main image when construction of a building
       * is in process.
       */
      private var _imageMask:UIComponent = null;
      
      
      private var f_buildingUpgradeProgressed:Boolean = true,
                  f_buildingUpgradePropChanged:Boolean = true,
                  f_buildingIdChanged:Boolean = true,
                  f_buildingTypeChanged:Boolean = true,
                  f_buildingStateChanged:Boolean = true,
                  f_buildingLevelChanged:Boolean = true,
                  f_selectionChanged:Boolean = true,
                  f_levelIdicatorResized:Boolean = true;
      
      
      override protected function updateDisplayList(uw:Number, uh:Number) : void
      {
         super.updateDisplayList(uw, uh);
         var b:Building = getBuilding();
         if (f_buildingIdChanged)
         {
            if (b.isGhost)
            {
               mainImage.alpha = 0.5;
            }
            else
            {
               mainImage.alpha = 1;
            }
         }
         if (f_buildingIdChanged || f_buildingTypeChanged)
         {
            _levelIndicator.visible = !b.isGhost && !b.npc;
         }
         if (f_buildingStateChanged)
         {
            _levelIndicator.active = b.state != Building.INACTIVE;
         }
         if (f_buildingLevelChanged)
         {
            _levelIndicator.currentLevel = b.level;
         }
         if (f_buildingIdChanged || f_selectionChanged || f_buildingUpgradeProgressed || f_buildingUpgradePropChanged)
         {
            _hpBar.visible = !b.isGhost && (b.isDamaged || !b.upgradePart.upgradeCompleted || selected);
         }
         if (f_buildingUpgradePropChanged)
         {
            _constructionProgressBar.label = resourceManager.getString
               ("Buildings", "property.timeToFinish.long", [b.upgradePart.timeToFinishString]);
         }
         if (f_buildingUpgradePropChanged || f_buildingIdChanged)
         {
            _constructionProgressBar.visible = !b.isGhost && !b.upgradePart.upgradeCompleted;
         }
         if (f_buildingUpgradeProgressed || f_buildingUpgradePropChanged)
         {
            _constructionProgressBar.setProgress(b.upgradePart.upgradeProgress, 1);
            _hpBar.setProgress(b.hp, b.maxHp);
            _hpBar.label = b.hp + " / " + b.maxHp;
            if (!b.upgradePart.upgradeCompleted)
            {
               // Initialized _imageMask and _imageAlpha if this has not been done yet
               if (!_imageMask)
               {
                  _imageMask = new UIComponent();
                  addElement(_imageMask);
                  mainImage.mask = _imageMask;
               }
               if (!_alphaImage)
               {
                  createAlphaImage();
               }
               
               // Now redraw and position the mask
               var newHeight:Number = uh * b.upgradePart.upgradeProgress;
               newHeight = Math.max(1,  newHeight);
               newHeight = Math.min(uh, newHeight);
               // Sometimes somewhere in upgrade process this bocomes a NaN and screws the things up. Maybe we get
               // 0 division by 0 somewhere. That would be most likely since this only seems to happen for buildings
               // that are constructed super fast.
               if (isNaN(newHeight))
               {
                  newHeight = 1;
               }
               _imageMask.move(0, uh - newHeight);
               var g:Graphics = _imageMask.graphics;
               g.clear();
               g.beginFill(0x000000);
               g.drawRect(0, 0, uw, newHeight);
               g.endFill();
            }
            // destroy _imageMask and _alphaImage if they are still present as they are not needed anymore
            else
            {
               if (_imageMask)
               {
                  removeElement(_imageMask);
                  mainImage.mask = null;
                  _imageMask = null;
               }
               if (_alphaImage)
               {
                  removeElement(_alphaImage);
                  _alphaImage = null;
               }
            }
         }
         if (f_levelIdicatorResized)
         {
            positionLevelIndicator();
         }
         
         f_buildingUpgradeProgressed = f_buildingUpgradePropChanged = f_buildingIdChanged =
         f_buildingTypeChanged = f_buildingStateChanged = f_buildingLevelChanged =
         f_selectionChanged = f_levelIdicatorResized = false;
      }
      
      
      /**
       * @return typed reference to <code>model</code>.
       */
      public function getBuilding() : Building
      {
         return model as Building;
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      /**
       * This also holds image of building but should be semi-transparent and under the main
       * image. It will be shown when construction of a building is in progress.
       */
      private var _alphaImage:BitmapImage;
      
      
      /**
       * Hit points indicator. 
       */
      private var _hpBar:ProgressBar;
      
      
      /**
       * Construction progress indicator. 
       */
      private var _constructionProgressBar:ProgressBar;
      
      
      /**
       * Level indicator.
       */
      private var _levelIndicator:LevelDisplay;
      
      
      override protected function createChildren() : void
      {
         if (getBuilding().npc)
         {
            styleName = "npc";
         }
         
         super.createChildren();
         
         mainImage.depth = 200;
         
         _levelIndicator = new LevelDisplay();
         _levelIndicator.depth = 900;
         _levelIndicator.maxLevel = Config.getBuildingMaxLevel(getBuilding().type);
         addElement(_levelIndicator);
         
         _hpBar = new ProgressBar();
         _hpBar.left = _hpBar.right = 30;
         _hpBar.labelPlacement = ProgressBarLabelPlacement.CENTER;
         _hpBar.mode = ProgressBarMode.MANUAL;
         _hpBar.depth = 900;
         addElement(_hpBar);
         
         _constructionProgressBar = new ProgressBar();
         _constructionProgressBar.left = _constructionProgressBar.right = 30;
         _constructionProgressBar.top = 25;
         _constructionProgressBar.labelPlacement = ProgressBarLabelPlacement.CENTER;
         _constructionProgressBar.mode = ProgressBarMode.MANUAL;
         _constructionProgressBar.depth = 900;
         addElement(_constructionProgressBar);
      }
      
      
      private function createAlphaImage() : void
      {
         _alphaImage = new BitmapImage();
         _alphaImage.alpha = 0.5;
         _alphaImage.source = model.imageData;
         _alphaImage.smooth = true;
         _alphaImage.fillMode = BitmapFillMode.CLIP;
         _alphaImage.depth = 100;
         addElement(_alphaImage);
      }
      
      
      private function positionLevelIndicator() : void
      {
         var corner:Point = PlanetObject.getBasementBottomCorner(model.width, model.height);
         corner.x += model.imageWidth - model.realBasementWidth - _levelIndicator.width / 2;
         corner.y += model.imageHeight - model.realBasementHeight - _levelIndicator.height - LEVEL_INDICATOR_OFFSET;
         _levelIndicator.x = corner.x;
         _levelIndicator.y = corner.y;
      }
      
      
      /* ############################ */
      /* ### MODEL EVENT HANDLERS ### */
      /* ############################ */
      
      
      override protected function addModelEventListeners(model:PlanetObject) : void
      {
         super.addModelEventListeners(model);
         var b:Building = Building(model);
         b.upgradePart.addEventListener(UpgradeEvent.UPGRADE_PROGRESS, model_upgradeProgressHandler);
         b.upgradePart.addEventListener(UpgradeEvent.UPGRADE_PROP_CHANGE, model_upgradePropChangeHandler);
         b.addEventListener(BuildingEvent.TYPE_CHANGE, model_typeChangeHandler);
         b.addEventListener(BaseModelEvent.ID_CHANGE, model_idChangeHandler);
         b.addEventListener(UpgradeEvent.LVL_CHANGE, model_levelChangeHandler);
         b.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, model_propertyChangeHandler);
      }
      
      
      override protected function removeModelEventListeners(model:PlanetObject) : void
      {
         super.removeModelEventListeners(model);
         var b:Building = Building(model);
         b.upgradePart.removeEventListener(UpgradeEvent.UPGRADE_PROGRESS, model_upgradeProgressHandler);
         b.upgradePart.removeEventListener(UpgradeEvent.UPGRADE_PROP_CHANGE, model_upgradePropChangeHandler);
         b.removeEventListener(BuildingEvent.TYPE_CHANGE, model_typeChangeHandler);
         b.removeEventListener(BaseModelEvent.ID_CHANGE, model_idChangeHandler);
         b.removeEventListener(UpgradeEvent.LVL_CHANGE, model_levelChangeHandler);
         b.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, model_propertyChangeHandler);
      }
      
      
      private function model_upgradeProgressHandler(event:UpgradeEvent) : void
      {
         f_buildingUpgradeProgressed = true;
         invalidateDisplayList();
      }
      
      
      private function model_upgradePropChangeHandler(event:UpgradeEvent) : void
      {
         f_buildingUpgradePropChanged = true;
         invalidateDisplayList();
      }
      
      
      private function model_idChangeHandler(event:BaseModelEvent) : void
      {
         f_buildingIdChanged = true;
         invalidateDisplayList();
      }
      
      
      private function model_typeChangeHandler(event:BuildingEvent) : void
      {
         f_buildingTypeChanged = true;
         invalidateDisplayList();
      }
      
      
      private function model_levelChangeHandler(event:UpgradeEvent) : void
      {
         f_buildingLevelChanged = true;
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
      
      
      /* ############################### */
      /* ### CHILDREN EVENT HANDLERS ### */
      /* ############################### */
      
      
      private function addLevelIndicatorEventHandlers(indicator:LevelDisplay) : void
      {
         indicator.addEventListener(ResizeEvent.RESIZE, levelIndicator_resizeHandler);
      }
      
      
      private function levelIndicator_resizeHandler(event:ResizeEvent) : void
      {
         f_levelIdicatorResized = true;
         invalidateDisplayList();
      }
   }
}