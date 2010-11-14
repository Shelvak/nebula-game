package components.gameobjects.solarsystem
{
   import components.gameobjects.skins.SSObjectTileSkin;
   import components.map.space.IMapSpaceObject;
   
   import controllers.ui.NavigationController;
   
   import models.location.LocationMinimal;
   import models.location.LocationMinimalSolarSystem;
   import models.location.LocationType;
   import models.planet.Planet;
   import models.solarsystem.SSObject;
   
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   
   
   /**
    * Selected state of the planet.
    */
   [SkinState("selected")]
   
   public class SSObjectTile extends SkinnableContainer implements IMapSpaceObject
   {
      public function SSObjectTile()
      {
         super();
         setStyle("skinClass", SSObjectTileSkin);
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _model:SSObject;
      [Bindable]
      /**
       * Planet model.
       */
      public function set model(value:SSObject) : void
      {
         if (_model != value)
         {
            _model = value;
            if (_model)
            {
               width = SSObject.IMAGE_WIDTH * _model.size / 100;
               height = SSObject.IMAGE_HEIGHT * _model.size / 100;
            }
            f_modelChanged = true;
            invalidateProperties();
         }
      }
      /**
       * @private
       */
      public function get model() : SSObject
      {
         return _model;
      }
      
      
      /**
       * Proxy to <code>SSObject.position</code>.
       */
      public function get position() : int
      {
         if (model)
         {
            return model.position;
         }
         return 0;
      }
      
      
      /**
       * Proxy to <code>SSObject.angle</code>.
       */
      public function get angle() : Number
      {
         if (model)
         {
            return model.angle;
         }
         return 0;
      }
      
      
      /**
       * Proxy to <code>SSObject.angleRadians</code>.
       */
      public function get angleRadians() : Number
      {
         if (model)
         {
            return model.angleRadians;
         }
         return 0;
      }
      
      
      public function get locationCurrent() : LocationMinimal
      {
         var locWrapper:LocationMinimalSolarSystem = new LocationMinimalSolarSystem(new LocationMinimal());
         locWrapper.type = LocationType.SOLAR_SYSTEM;
         locWrapper.id = model.solarSystemId;
         locWrapper.position = model.position;
         locWrapper.angle = model.angle;
         return locWrapper.location;
      }
      
      
      private var _selected: Boolean = false;
      /**
       * Allows selecting/deselecting this planet.
       */
      public function set selected (v: Boolean) :void
      {
         _selected = v;
         invalidateSkinState ();
      }
      /**
       * @private
       */ 
      public function get selected () :Boolean
      {
         return _selected;
      }
      
      
      private var f_modelChanged:Boolean = true;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (f_modelChanged)
         {
            if (_model)
            {
               labelName.text = model.name;
               image.rotation = model.angle + 180;
            }
            else
            {
               labelName.text = "";
               image.rotation = 0;
            }
         }
         f_modelChanged = false;
      }
      
      
      /**
       * Selets this planet tile: sets <code>selected</code> to <code>true</code>.
       * If this planet tile was already selected, dispatches <code>PlanetsCommand.SHOW</code>
       * command.
       */
      public function select() : void
      {
         if (selected)
         {
            NavigationController.getInstance().toPlanet(model);
         }
         else
         {
            selected = true;
         }
      }
      
      
      /* ############ */
      /* ### SKIN ### */
      /* ############ */
      
      
      [SkinPart(required="true")]
      /**
       * Image of a planet.
       */
      public var image:SSObjectImage;
      
      
      [SkinPart(required="true")]
      /**
       * Name of the planet. 
       */
      public var labelName:Label;
      
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName, instance);
         if (instance == image)
         {
            image.verticalCenter = 0;
            image.horizontalCenter = 0;
            image.transformX = width / 2;
            image.transformY = height / 2;
            image.width = width;
            image.height = height;
         }
      }
      
      
      override protected function getCurrentSkinState () :String
      {
         if (selected)
         {
            return "selected";
         }
         else
         {
            return "normal";
         }
      }
   }
}