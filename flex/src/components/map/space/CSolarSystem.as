package components.map.space
{
   import components.gameobjects.solarsystem.SSPlanetsStatusIcons;
   import components.gameobjects.solarsystem.SSShipsStatusIcons;
   
   import models.solarsystem.SolarSystem;
   
   import mx.graphics.BitmapFillMode;
   
   import spark.components.Group;
   import spark.components.Label;
   import spark.layouts.HorizontalAlign;
   import spark.layouts.HorizontalLayout;
   import spark.layouts.VerticalAlign;
   import spark.layouts.VerticalLayout;
   import spark.primitives.BitmapImage;
   
   
   public class CSolarSystem extends CStaticSpaceObject
   {
      public function CSolarSystem()
      {
         super();
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      private var _planetIcons:SSPlanetsStatusIcons,
                  _shipsIcons:SSShipsStatusIcons,
                  _bmpImage:BitmapImage,
                  _lblName:Label;
      
      
      protected override function createChildren() : void
      {
         super.createChildren();
         
         var vLayout:VerticalLayout;
         var hLayout:HorizontalLayout;
         var ss:SolarSystem = SolarSystem(staticObject);
         
         _bmpImage = new BitmapImage();
         with (_bmpImage)
         {
            smooth   = true;
            fillMode = BitmapFillMode.SCALE;
            width    = SolarSystem.IMAGE_WIDTH;
            height   = SolarSystem.IMAGE_HEIGHT;
            source   = SolarSystem(staticObject).imageData;
         }
         _lblName = new Label();
         _lblName.text = ss.name;
         _lblName.setStyle("color", 0x9D9D9D);
         vLayout = new VerticalLayout();
         vLayout.horizontalAlign = HorizontalAlign.CENTER;
         var group:Group = new Group();
         with (group)
         {
            left           = 0;
            right          = 0;
            verticalCenter = 0;
            layout         = vLayout;
            addElement(_bmpImage);
            addElement(_lblName);
         }
         addElement(group);
         
         hLayout = new HorizontalLayout();
         hLayout.verticalAlign = VerticalAlign.MIDDLE;
         hLayout.gap = 2;
         _planetIcons = new SSPlanetsStatusIcons();
         with (_planetIcons)
         {
            top         = 0;
            left        = 0;
            layout      = hLayout;
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