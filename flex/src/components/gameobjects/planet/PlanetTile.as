package components.gameobjects.planet
{
   import components.gameobjects.skins.PlanetTileSkin;
   import components.map.space.IMapSpaceObject;
   
   import controllers.ui.NavigationController;
   
   import models.location.LocationMinimal;
   import models.planet.Planet;
   import models.planet.PlanetLocation;
   
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   
   
   /**
    * Selected state of the planet.
    */
   [SkinState("selected")]
   
   public class PlanetTile extends SkinnableContainer implements IMapSpaceObject
   {
      public function PlanetTile()
      {
         super();
         setStyle("skinClass", PlanetTileSkin);
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _model:Planet;
      [Bindable]
      /**
       * Planet model.
       */
      public function set model(value:Planet) : void
      {
         if (_model != value)
         {
            _model = value;
            if (_model)
            {
               width = Planet.IMAGE_WIDTH * _model.size / 100;
               height = Planet.IMAGE_HEIGHT * _model.size / 100;
            }
            f_modelChanged = true;
            invalidateProperties();
         }
      }
      /**
       * @private
       */
      public function get model() : Planet
      {
         return _model;
      }
      
      
      /**
       * Proxy to <code>Planet.location</code>.
       */
      public function get location () :PlanetLocation
      {
         if (model)
         {
            return model.location;
         }
         
         return null;
      }
      
      
      public function get currentLocation() : LocationMinimal
      {
         return model.currentLocation;
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
               labelName.text = _model.name;
               image.rotation = _model.location.angle + 180;
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
      public var image:PlanetImage;
      
      
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