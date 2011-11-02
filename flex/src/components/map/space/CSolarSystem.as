package components.map.space
{
   import components.gameobjects.solarsystem.SSPlanetsStatusIcons;
   import components.gameobjects.solarsystem.SSShipsStatusIcons;
   
   import models.map.IMStaticSpaceObject;
   import models.solarsystem.SolarSystem;
   import models.solarsystem.events.SolarSystemEvent;
   
   import mx.graphics.BitmapFillMode;
   
   import spark.components.Group;
   import spark.components.Label;
   import spark.layouts.HorizontalAlign;
   import spark.layouts.VerticalLayout;
   import spark.primitives.BitmapImage;
   
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   
   public class CSolarSystem extends CStaticSpaceObject
   {
      private function get IMG() : ImagePreloader {
         return ImagePreloader.getInstance();
      }
      
      
      public function CSolarSystem() {
         super();
      }
      
      /* ############################ */
      /* ### MODEL EVENT HANDLERS ### */
      /* ############################ */      
      
      private function solarSystem_shieldOwnerChangeHandler(event:SolarSystemEvent) : void {
         f_ssShieldChanged = true;
         invalidateProperties();
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      public override function set staticObject(value:IMStaticSpaceObject) : void {
         if (super.staticObject != value) {
            if (super.staticObject != null) {
               SolarSystem(super.staticObject).removeEventListener(
                  SolarSystemEvent.SHIELD_OWNER_CHANGE,
                  solarSystem_shieldOwnerChangeHandler, false
               );
            }
            if (value != null) {
               SolarSystem(value).addEventListener(
                  SolarSystemEvent.SHIELD_OWNER_CHANGE,
                  solarSystem_shieldOwnerChangeHandler, false, 0, true
               );
            }
            super.staticObject = value;
            f_staticObjectChanged = true;
            invalidateProperties();
         }
      }
      
      private var f_staticObjectChanged:Boolean = true;
      private var f_ssShieldChanged:Boolean = true;
      
      protected override function commitProperties() : void {
         super.commitProperties();
         
         var solarSystem:SolarSystem = SolarSystem(staticObject);
         if ((f_staticObjectChanged || f_ssShieldChanged) && solarSystem != null) {
            if (solarSystem.isShielded) {
               if (_bmpShield == null) {
                  _bmpShield = new BitmapImage();
                  _bmpShield.fillMode = BitmapFillMode.SCALE;
                  _bmpShield.top = -5;
                  _bmpShield.horizontalCenter = 0;
                  _bmpShield.width  = SolarSystem.IMAGE_WIDTH + 10;
                  _bmpShield.height = SolarSystem.IMAGE_HEIGHT + 10;
                  _bmpShield.source = IMG.getImage(AssetNames.SS_SHIELD_IMAGE_NAME);
                  _imgGroup.addElementAt(_bmpShield, 1);
               }
            }
            else {
               if (_bmpShield != null) {
                  _imgGroup.removeElementAt(1);
                  _bmpShield = null;
               }
            }
         }
         if (f_staticObjectChanged && solarSystem != null) {
            _bmpImage.source = solarSystem.imageData;
            _lblName.text = solarSystem.name;
            _planetIcons.solarSystem = solarSystem;
            _shipsIcons.solarSystem = solarSystem;
         }
         
         f_ssShieldChanged = false;
         f_staticObjectChanged = false;
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      private var _planetIcons:SSPlanetsStatusIcons;
      private var _shipsIcons:SSShipsStatusIcons;
      private var _imgGroup:Group;
      private var _bmpImage:BitmapImage;
      private var _bmpShield:BitmapImage;
      private var _lblName:Label;
      
      protected override function createChildren() : void {
         super.createChildren();
         
         var vLayout:VerticalLayout;
         
         _bmpImage = new BitmapImage();
         _bmpImage.smooth = true;
         _bmpImage.fillMode = BitmapFillMode.SCALE;
         _bmpImage.width = SolarSystem.IMAGE_WIDTH;
         _bmpImage.height = SolarSystem.IMAGE_HEIGHT;
         _bmpImage.horizontalCenter = 0;
         _lblName = new Label();
         _lblName.setStyle("color", 0x9D9D9D);
         _lblName.horizontalCenter = 0;
         _lblName.top = _bmpImage.height + 10;
         _imgGroup = new Group();
         addElement(_imgGroup);
         _imgGroup.left = 0;
         _imgGroup.right = 0;
         _imgGroup.verticalCenter = 0;
         _imgGroup.addElement(_bmpImage);
         _imgGroup.addElement(_lblName);
         
         vLayout = new VerticalLayout();
         vLayout.verticalAlign = HorizontalAlign.CENTER;
         vLayout.gap = 2;
         _planetIcons = new SSPlanetsStatusIcons();
         _planetIcons.top = 0;
         _planetIcons.left = 0;
         _planetIcons.layout = vLayout;
         addElement(_planetIcons);
         
         vLayout = new VerticalLayout();
         vLayout.horizontalAlign = HorizontalAlign.CENTER;
         vLayout.gap = 2;
         _shipsIcons = new SSShipsStatusIcons();
         _shipsIcons.top = 0;
         _shipsIcons.right = 0;
         _shipsIcons.layout = vLayout;
         addElement(_shipsIcons);
      }
   }
}