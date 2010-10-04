package components.map.planet
{
   import animation.AnimationTimer;
   
   import utils.assets.AssetNames;
   
   import com.greensock.TweenLite;
   import com.greensock.data.TweenLiteVars;
   import com.greensock.easing.Linear;
   
   import components.base.BaseContainer;
   import components.map.CMap;
   
   import config.Config;
   
   import flash.events.Event;
   import flash.events.TimerEvent;
   
   import mx.collections.ArrayCollection;
   import mx.events.FlexEvent;
   
   import spark.primitives.BitmapImage;
   
   public class CloudsLayer extends BaseContainer
   {
      private static const MAX_GENERATE:int = 3;
      private static const MIN_GENERATE:int = 1;
      
      private static const GENERATION_PERIOD_BASE:uint = 1000;
      private static const GENERATION_PERIOD_DISPERSION:uint = 500;
      
      private static const CLOUD_SPEED_BASE:uint = 1;
      private static const CLOUD_SPEED_DISPERSION:uint = 0;
      
      private static const FADE_SPEED:int = 1000;
      
      private static const SHADOW_HORIZONTAL_SHIFT:int = 45;
      private static const SHADOW_VERTICAL_SHIFT:int = 320;
      
      
      
      
      private var _map:PlanetMap;
    
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      public function CloudsLayer() : void
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
         addEventListener(FlexEvent.CREATION_COMPLETE, this_creationCompleteHandler);
      }
      
      
      public function initializeLayer(map:PlanetMap) : void
      {
         cleanup();
         _map = map;
         _clouds = new ArrayCollection();
         _cloudsSchedule = new ArrayCollection();
         _ticksTillNextSchedule = GENERATION_PERIOD_BASE;
//         addTimerEventHandlers();
      }
      
      
      public function cleanup() : void
      {
//         removeTimerEventHandlers();
         for each (var cloud:Cloud in _clouds)
         {
            TweenLite.killTweensOf(cloud.cloud);
            TweenLite.killTweensOf(cloud.shadow);
            removeElement(cloud.cloud);
            removeElement(cloud.shadow);
         }
         _map = null;
         _clouds = null;
         _cloudsSchedule = null;
      }
      
      
      /* ######################## */
      /* ### CLOUD GENERATION ### */
      /* ######################## */
      
      
      private var _clouds:ArrayCollection;
      private var _cloudsSchedule:ArrayCollection;
      
      
      private var _ticksTillNextSchedule:int;
      private function tick() : void
      {
         decrementSchedule();
         if (_ticksTillNextSchedule == 0)
         {
            scheduleClouds();
            _ticksTillNextSchedule = GENERATION_PERIOD_BASE;
         }
         else
         {
            _ticksTillNextSchedule--;
         }
      }
      
      
      private function decrementSchedule() : void
      {
         for (var i:int = 0; i < _cloudsSchedule.length; i++)
         {
            _cloudsSchedule[i]--;
         }
         _cloudsSchedule.filterFunction = function(item:Object) : Boolean
         {
            return (item as int) <= 0;
         };
         _cloudsSchedule.refresh();
         for each (i in _cloudsSchedule)
         {
            generateCloud();
         }
         _cloudsSchedule.removeAll();
         _cloudsSchedule.filterFunction = null;
         _cloudsSchedule.refresh();
      }
      
      
      private function scheduleClouds() : void
      {
         var cloudsToSchedule:int =
            Math.round(Math.random() * (MAX_GENERATE - MIN_GENERATE)) + MIN_GENERATE;
         for (var i:int = 0; i < cloudsToSchedule; i++)
         {
            _cloudsSchedule.addItem(
               Math.round((Math.random() - 0.5) * GENERATION_PERIOD_DISPERSION)
               + GENERATION_PERIOD_BASE
            );
         }
      }
      
      
      private function generateCloud() : void
      {
         var lyMax:int = _map.logicalHeight - 1;
         var lyMin:int = 8;
         var lxMax:int = _map.logicalWidth - 4;
         var lxMin:int = 2;
         var logicalX:int = Math.round(Math.random() * (lxMax - lxMin)) + lxMin;
         var logicalY:int = Math.round(Math.random() * (lyMax - lyMin)) + lyMin;
         var realX:Number = _map.getRealTileX(logicalX, logicalY);
         var realY:Number = _map.getRealTileY(logicalX, logicalY);
//         var realXEnd:Number = _map.getRealTileX(lxMax, logicalY);
//         var realYEnd:Number = _map.getRealTileY(lxMax, logicalY);
//         var floatTime:Number = _map.width / ((Math.random() - 0.5) * CLOUD_SPEED_DISPERSION + CLOUD_SPEED_BASE);
         var variation:int = Math.round(Math.random() * (Config.getCloudsVariations() - 1));
         
         var cloudImg:BitmapImage = new BitmapImage();
         var shadowImg:BitmapImage = new BitmapImage();
         var cloud:Cloud = new Cloud(cloudImg, shadowImg);
         _clouds.addItem(cloud);
         
         cloudImg.source = IMG.getImage(AssetNames.getCloudImageName(variation));
//         cloudImg.scaleX = 0.5; cloudImg.scaleY = 0.5;
         cloudImg.x = realX;
         cloudImg.y = realY;
//         var cloudParams:TweenLiteVars = new TweenLiteVars();
//         cloudParams.addProp("x", realXEnd);
//         cloudParams.addProp("y", realYEnd);
//         cloudParams.ease = Linear.easeNone;
         
         shadowImg.source = IMG.getImage(AssetNames.getCloudShadowImageName(variation));
//         shadowImg.scaleX = 0.5; shadowImg.scaleY = 0.5;
         shadowImg.x = realX - SHADOW_HORIZONTAL_SHIFT;
         shadowImg.y = realY + SHADOW_VERTICAL_SHIFT;
//         var shadowParams:TweenLiteVars = new TweenLiteVars();
//         shadowParams.addProp("x", realXEnd - SHADOW_HORIZONTAL_SHIFT);
//         shadowParams.addProp("y", realYEnd + SHADOW_VERTICAL_SHIFT);
//         shadowParams.onComplete = removeCloud;
//         shadowParams.onCompleteParams = [cloud];
//         shadowParams.ease = Linear.easeNone;
         
         addElement(cloudImg);
         addElement(shadowImg);
         
//         TweenLite.to(cloudImg, floatTime, cloudParams);
//         TweenLite.to(shadowImg, floatTime, shadowParams);
      }
      
      
      private function removeCloud(cloud:Cloud) : void
      {
         removeElement(cloud.cloud);
         removeElement(cloud.shadow);
      }
      
      
      /* ###################### */
      /* ### EVENT HANDLERS ### */
      /* ###################### */
      
      
      private function addTimerEventHandlers() : void
      {
         AnimationTimer.forPlanet.addEventListener(TimerEvent.TIMER, timer_timerEvent);
      }
      
      
      private function removeTimerEventHandlers() : void
      {
         AnimationTimer.forPlanet.removeEventListener(TimerEvent.TIMER, timer_timerEvent);
      }
      
      
      private function timer_timerEvent(event:TimerEvent) : void
      {
         tick();
      }
      
      
      private function this_creationCompleteHandler(event:FlexEvent) : void
      {
         for (var i:int = 0; i < Math.round(Math.random() * 4) + 5; i++)
         {
            generateCloud();
         }
      }
   }
}


import spark.primitives.BitmapImage;
import spark.primitives.supportClasses.GraphicElement;


class Cloud
{
   public var cloud:BitmapImage;
   public var shadow:BitmapImage;
   
   public function Cloud(cloud:BitmapImage, shadow:BitmapImage)
   {
      this.cloud = cloud;
      this.shadow = shadow;
   }
}