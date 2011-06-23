package components.map.planet.objects
{
   
   import components.battle.HpBar;
   import components.skins.BuildButtonSkin;
   
   import config.Config;
   
   import flash.display.Graphics;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   
   import models.OwnerColor;
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
   
   import namespaces.property_name;
   
   import spark.primitives.BitmapImage;
   
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   import utils.locale.Localizer;
   
   
   /**
    * Building component that will be on the PlanetMap.
    */
   public class MapBuilding extends InteractivePlanetMapObject
   {
      private static const LEVEL_INDICATOR_OFFSET:int = 0;
      
      
      private static const DISABLED_FILTERS:Array = [
         new ColorMatrixFilter([
            .2,  0,  0, 0, 0, // R
             0, .2,  0, 0, 0, // G
             0,  0, .2, 0, 0, // B
             0,  0,  0, 1, 0  // A
         ]) 
      ]; 
      
      
      /**
       * @return typed reference to <code>model</code>.
       */
      public function getBuilding() : Building
      {
         return Building(model);
      }
      
      
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
            invalidateProperties();
         }
      }
      
      
      private var f_buildingUpgradeProgressed:Boolean = true,
                  f_buildingUpgradePropChanged:Boolean = true,
                  f_buildingIdChanged:Boolean = true,
                  f_buildingTypeChanged:Boolean = true,
                  f_buildingStateChanged:Boolean = true,
                  f_buildingLevelChanged:Boolean = true,
                  f_buildingHpChanged:Boolean = true,
                  f_selectionChanged:Boolean = true;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         var b:Building = getBuilding();
         if (b == null)
         {
            return;
         }
         if (f_buildingIdChanged)
         {
            if (b.isGhost)
            {
               mainImageContainer.alpha = 0.5;
            }
            else
            {
               mainImageContainer.alpha = 1;
            }
         }
         if (f_buildingIdChanged || f_buildingTypeChanged)
         {
            _levelIndicator.visible = !b.isGhost && !b.npc;
            _npcIndicator.visible = !b.isGhost && b.npc;
         }
         if (f_buildingStateChanged ||
             f_buildingUpgradePropChanged ||
             f_buildingIdChanged)
         {
            if (b.upgradePart.upgradeCompleted && !b.isGhost && b.state == Building.INACTIVE)
            {
               if (mainImageContainer.filters != DISABLED_FILTERS)
               {
                  mainImageContainer.filters = DISABLED_FILTERS;
               }
            }
            else
            {
               mainImageContainer.filters = null;
            }
         }
         if (f_buildingLevelChanged)
         {
            _levelIndicator.currentLevel = b.level;
         }
         if (f_buildingHpChanged)
         {
            _hpBar.setProgress(b.hp, b.hpMax);
            _hpBar.label = b.hp + "/" + b.hpMax;
         }
         if (f_buildingIdChanged || f_selectionChanged || f_buildingHpChanged)
         {
            _hpBar.visible = !b.isGhost && b.hp > 0 && (b.isDamaged || selected);
         }
         if (f_buildingUpgradePropChanged || f_buildingUpgradeProgressed)
         {
            _constructionProgressBar.label = Localizer.string
               ("Buildings", "property.timeToFinish.long", [b.upgradePart.timeToFinishString]);
         }
         if (f_buildingUpgradePropChanged || f_buildingIdChanged)
         {
            _constructionProgressBar.visible = !b.isGhost && !b.upgradePart.upgradeCompleted;
         }
         f_buildingIdChanged = f_buildingTypeChanged = f_buildingStateChanged =
         f_buildingLevelChanged = f_selectionChanged = false;
      }
      
      
      /* ############### */
      /* ### VISUALS ### */
      /* ############### */
      
      
      /**
       * A mask object that will be used to mask main image when construction of a building
       * is in process.
       */
      private var _imageMask:UIComponent = null;
      
      
      private var f_levelIdicatorResized:Boolean = true;
      
      
      override protected function updateDisplayList(uw:Number, uh:Number) : void
      {
         super.updateDisplayList(uw, uh);
         var b:Building = getBuilding();
         //I gues that if you switch one map to another some buildings get cleaned and then map building
         //component crashes, so this check whould fix that. (by Jho 2011.02.06)
         if (b && b.upgradePart)
         {
            if (f_buildingUpgradeProgressed || f_buildingUpgradePropChanged || f_buildingHpChanged)
            {
               _constructionProgressBar.setProgress(b.upgradePart.upgradeProgress, 1);
               if (!b.upgradePart.upgradeCompleted)
               {
                  // Initialized _imageMask and _imageAlpha if this has not been done yet
                  if (!_imageMask)
                  {
                     _imageMask = new UIComponent();
                     addElement(_imageMask);
                     mainImageContainer.mask = _imageMask;
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
                     mainImageContainer.mask = null;
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
            f_buildingUpgradeProgressed = f_buildingUpgradePropChanged = f_levelIdicatorResized =
               f_buildingHpChanged = false;
         }
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
      
      private var _npcIndicator: BitmapImage;
      
      
      override protected function createChildren() : void
      {
         super.createChildren();
         
		 var b: Building = getBuilding();
         if (b.npc)
         {
            styleName = "npc";
            basement.color = OwnerColor.UNDEFINED;
         }
         else
         {
            basement.color = OwnerColor.PLAYER;
         }
         
         mainImageContainer.depth = 200;
         
         _levelIndicator = new LevelDisplay();
         _levelIndicator.depth = 900;
         _levelIndicator.maxLevel = Config.getBuildingMaxLevel(b.type);
         addElement(_levelIndicator);
         
         _npcIndicator = new BitmapImage();
         _npcIndicator.depth = 900;
         _npcIndicator.source = ImagePreloader.getInstance().getImage(
            AssetNames.getLevelDisplayImageName('npc'));
		 _npcIndicator.visible = !b.isGhost && b.npc;;
         addElement(_npcIndicator);
         
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
         _npcIndicator.x = corner.x;
         _npcIndicator.y = corner.y;
         
      }
      
      
      /* ############################ */
      /* ### MODEL EVENT HANDLERS ### */
      /* ############################ */
      
      
      override protected function addModelEventListeners(model:PlanetObject) : void
      {
         super.addModelEventListeners(model);
         var b:Building = Building(model);
         b.upgradePart.addEventListener(UpgradeEvent.UPGRADE_PROGRESS, model_upgradeProgressHandler, false, 0, true);
         b.upgradePart.addEventListener(UpgradeEvent.UPGRADE_PROP_CHANGE, model_upgradePropChangeHandler, false, 0, true);
         b.addEventListener(BuildingEvent.HP_CHANGE, model_hpChangeHandler, false, 0, true);
         b.addEventListener(BuildingEvent.TYPE_CHANGE, model_typeChangeHandler, false, 0, true);
         b.addEventListener(BaseModelEvent.ID_CHANGE, model_idChangeHandler, false, 0, true);
         b.addEventListener(UpgradeEvent.LEVEL_CHANGE, model_levelChangeHandler, false, 0, true);
         b.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, model_propertyChangeHandler, false, 0, true);
      }
      
      
      override protected function removeModelEventListeners(model:PlanetObject) : void
      {
         super.removeModelEventListeners(model);
         var b:Building = Building(model);
         b.upgradePart.removeEventListener(UpgradeEvent.UPGRADE_PROGRESS, model_upgradeProgressHandler, false);
         b.upgradePart.removeEventListener(UpgradeEvent.UPGRADE_PROP_CHANGE, model_upgradePropChangeHandler, false);
         b.removeEventListener(BuildingEvent.HP_CHANGE, model_hpChangeHandler, false);
         b.removeEventListener(BuildingEvent.TYPE_CHANGE, model_typeChangeHandler, false);
         b.removeEventListener(BaseModelEvent.ID_CHANGE, model_idChangeHandler, false);
         b.removeEventListener(UpgradeEvent.LEVEL_CHANGE, model_levelChangeHandler, false);
         b.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, model_propertyChangeHandler, false);
      }
      
      
      private function model_upgradeProgressHandler(event:UpgradeEvent) : void
      {
         f_buildingUpgradeProgressed = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      
      private function model_upgradePropChangeHandler(event:UpgradeEvent) : void
      {
         f_buildingUpgradePropChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      
      private function model_idChangeHandler(event:BaseModelEvent) : void
      {
         f_buildingIdChanged = true;
         invalidateProperties();
      }
      
      
      private function model_typeChangeHandler(event:BuildingEvent) : void
      {
         f_buildingTypeChanged = true;
         invalidateProperties();
      }
      
      
      private function model_levelChangeHandler(event:UpgradeEvent) : void
      {
         f_buildingLevelChanged = true;
         invalidateProperties();
      }
      
      
      private function model_hpChangeHandler(event:BuildingEvent) : void
      {
         f_buildingHpChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      
      private function model_propertyChangeHandler(event:PropertyChangeEvent) : void
      {
         if (event.property == Building.property_name::state)
         {
            f_buildingStateChanged = true;
            invalidateProperties();
         }
      }
      
      
      /* ############################### */
      /* ### CHILDREN EVENT HANDLERS ### */
      /* ############################### */
      
      
      private function addLevelIndicatorEventHandlers(indicator:LevelDisplay) : void
      {
         indicator.addEventListener(ResizeEvent.RESIZE, levelIndicator_resizeHandler, false, 0, true);
      }
      
      
      private function levelIndicator_resizeHandler(event:ResizeEvent) : void
      {
         f_levelIdicatorResized = true;
         invalidateProperties();
      }
   }
}