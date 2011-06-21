package components.map.space
{
   import components.gameobjects.solarsystem.SSPlanetsStatusIcons;
   import components.gameobjects.solarsystem.SSShipsStatusIcons;
   
   import models.IMStaticSpaceObject;
   import models.solarsystem.events.SolarSystemEvent;
   import models.solarsystem.SolarSystem;
   
   import mx.graphics.BitmapFillMode;
   
   import spark.components.Group;
   import spark.components.Label;
   import spark.layouts.HorizontalAlign;
   import spark.layouts.HorizontalLayout;
   import spark.layouts.VerticalAlign;
   import spark.layouts.VerticalLayout;
   import spark.primitives.BitmapImage;
   
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   
   public class CSolarSystem extends CStaticSpaceObject
   {
      private function get IMG() : ImagePreloader
      {
         return ImagePreloader.getInstance();
      }
      
      
      public function CSolarSystem()
      {
         super();
      }
      
      
      /* ############################ */
      /* ### MODEL EVENT HANDLERS ### */
      /* ############################ */
      
      
      public override function set staticObject(value:IMStaticSpaceObject) : void
      {
         if (super.staticObject != value)
         {
            if (super.staticObject != null)
            {
               SolarSystem(super.staticObject).removeEventListener(
                  SolarSystemEvent.SHIELD_OWNER_CHANGE,
                  solarSystem_shieldOwnerChangeHandler
               );
            }
            if (value != null)
            {
               SolarSystem(value).addEventListener(
                  SolarSystemEvent.SHIELD_OWNER_CHANGE,
                  solarSystem_shieldOwnerChangeHandler
               );
            }
            super.staticObject = value;
         }
      }
      
      
      private function solarSystem_shieldOwnerChangeHandler(event:SolarSystemEvent) : void
      {
         f_ssShieldChanged = true;
         invalidateProperties();
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var f_ssShieldChanged:Boolean = true;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (f_ssShieldChanged && staticObject != null)
         {
            if (SolarSystem(staticObject).isShielded)
            {
               if (_bmpShield == null)
               {
                  _bmpShield = new BitmapImage();
                  with (_bmpShield)
                  {
                     fillMode = BitmapFillMode.SCALE;
                     top = -5;
                     horizontalCenter = 0;
                     width  = SolarSystem.IMAGE_WIDTH + 10;
                     height = SolarSystem.IMAGE_HEIGHT + 10;
                     _bmpShield.source = IMG.getImage(AssetNames.SS_SHIELD_IMAGE_NAME);
                  }
                  _imgGroup.addElementAt(_bmpShield, 1);
               }
            }
            else
            {
               if (_bmpShield != null)
               {
                  _imgGroup.removeElementAt(1);
                  _bmpShield = null;
               }
            }
         }
         f_ssShieldChanged = false;
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      private var _planetIcons:SSPlanetsStatusIcons,
                  _shipsIcons:SSShipsStatusIcons,
                  _imgGroup:Group,
                  _bmpImage:BitmapImage,
                  _bmpShield:BitmapImage,
                  _lblName:Label;
      
      
      protected override function createChildren() : void
      {
         super.createChildren();
         
         var vLayout:VerticalLayout;
         var ss:SolarSystem = SolarSystem(staticObject);
         
         _bmpImage = new BitmapImage();
         with (_bmpImage)
         {
            smooth   = true;
            fillMode = BitmapFillMode.SCALE;
            width    = SolarSystem.IMAGE_WIDTH;
            height   = SolarSystem.IMAGE_HEIGHT;
            source   = SolarSystem(staticObject).imageData;
            horizontalCenter = 0;
         }
         _lblName = new Label();
         _lblName.text = ss.name;
         _lblName.setStyle("color", 0x9D9D9D);
         _lblName.horizontalCenter = 0;
         _lblName.top = _bmpImage.height + 10;
         _imgGroup = new Group();
         addElement(_imgGroup);
         with (_imgGroup)
         {
            left           = 0;
            right          = 0;
            verticalCenter = 0;
            addElement(_bmpImage);
            addElement(_lblName);
         }
         
         vLayout = new VerticalLayout();
         vLayout.verticalAlign = HorizontalAlign.CENTER;
         vLayout.gap = 2;
         _planetIcons = new SSPlanetsStatusIcons();
         with (_planetIcons)
         {
            top         = 0;
            left        = 0;
            layout      = vLayout;
            solarSystem = ss;
         }
         addElement(_planetIcons);
         
         vLayout = new VerticalLayout();
         vLayout.horizontalAlign = HorizontalAlign.CENTER;
         vLayout.gap = 2;
         _shipsIcons = new SSShipsStatusIcons();
         with (_shipsIcons)
         {
            top         = 0;
            right       = 0;
            layout      = vLayout;
            solarSystem = ss;
         }
         addElement(_shipsIcons);
      }
   }
}