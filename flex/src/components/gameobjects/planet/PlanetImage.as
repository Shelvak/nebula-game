package components.gameobjects.planet
{
   import components.base.BaseSkinnableComponent;
   import components.gameobjects.skins.PlanetImageSkin;
   
   import models.BaseModel;
   import models.planet.Planet;
   import models.solarsystem.ssobject.PlanetStatus;
   import models.planet.events.PlanetEvent;
   
   import mx.graphics.BitmapFillMode;
   
   import spark.primitives.BitmapImage;
   
   
   [SkinState("neutral")]
   [SkinState("owned")]
   [SkinState("ally")]
   [SkinState("enemy")]
   
   
   public class PlanetImage extends BaseSkinnableComponent
   {
      /**
       * Constructor.
       */
      public function PlanetImage()
      {
         super();
         setStyle("skinClass", PlanetImageSkin);
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _oldModel:Planet = null;
      public override function set model(v:BaseModel) : void
      {
         if (model != v)
         {
            if (!_oldModel)
            {
               _oldModel = getPlanet();
            }
            super.model = v;
            fModelChanged = true;
            invalidateProperties();
            invalidateSkinState();
         }
      }
      
      
      /**
       * Type getter for <code>model</code> property.
       */
      public function getPlanet() : Planet
      {
         return model as Planet;
      }
      
      
      private var fModelChanged:Boolean = false;
      protected override function commitProperties() : void
      {
         super.commitProperties();
         
         if (fModelChanged)
         {
            if (_oldModel)
            {
               removePlanetEventHandlers(_oldModel);
               _oldModel = null;
            }
            image.source = null;
            if (model)
            {
               addPlanetEventHandlers(getPlanet());
               image.source = getPlanet().imageData;
            }
         }
         
         fModelChanged = false;
      }
      
      
      /* ############ */
      /* ### SIZE ### */
      /* ############ */
      
      
      protected override function measure() : void
      {
         measuredWidth = Planet.IMAGE_WIDTH;
         measuredHeight = Planet.IMAGE_HEIGHT;
      }
      
      
      /* ############ */
      /* ### SKIN ### */
      /* ############ */
      
      
      [SkinPart(required="true")]
      /**
       * Image for displaying planet picture.
       */
      public var image:BitmapImage;
      
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName, instance);
         if (instance == image)
         {
            image.smooth = true;
            image.fillMode = BitmapFillMode.SCALE;
         }
      }
      
      
      override protected function getCurrentSkinState() : String
      {
         if (!model)
         {
            return "neutral";
         }
         
         switch(getPlanet().getStatus(ML.player.id))
         {
            case PlanetStatus.ALLY:
               return "ally";
            
            case PlanetStatus.ENEMY:
               return "enemy";
            
            case PlanetStatus.OWNED:
               return "owned";
            
            default:
               return "neutral";
         }
      }
      
      
      /* ############################# */
      /* ### PLANET EVENT HANDLERS ### */
      /* ############################# */
      
      
      private function addPlanetEventHandlers(planet:Planet) : void
      {
         planet.addEventListener(PlanetEvent.OWNER_CHANGE, planet_ownerChangeHandler);
      }
      
      
      private function removePlanetEventHandlers(planet:Planet) : void
      {
         planet.removeEventListener(PlanetEvent.OWNER_CHANGE, planet_ownerChangeHandler);
      }
      
      
      private function planet_ownerChangeHandler(event:PlanetEvent) : void
      {
         invalidateSkinState();
      }
   }
}