package components.gameobjects.building
{
   import components.gameobjects.planet.IPrimitivePlanetMapObject;
   import components.skins.NewBuildingPlaceholderSkin;
   
   import models.building.Building;
   
   import spark.components.supportClasses.SkinnableComponent;
   import spark.primitives.BitmapImage;
   
   
   /**
    * State when this a building can't be built because it overlaps other buildings or
    * there are rocks or something like that under it.
    */   
   [SkinState("restrict")]
   
   
   /**
    * State when building can be built in its current position.
    */
   [SkinState("normal")]
   
   
   /**
    * This is a component that is shown when user want's to build a new building and looks
    * for a place to build it. 
    */
   public class NewBuildingPlaceholder
      extends SkinnableComponent
      implements IPrimitivePlanetMapObject
   {
      /**
       * Constructor. 
       */
      public function NewBuildingPlaceholder()
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
         setStyle("skinClass", NewBuildingPlaceholderSkin);
      };
      
      
      include "../planet/mixin_defaultModelPropImpl.as";
      
      
      /**
       * @copy components.gameobjects.planet.PrimitivePlanetMapObject#initProperties()
       */
      protected function initProperties() : void
      {
         width  = model.imageWidth;
         height = model.imageHeight;
         setMainImageSource();
      }
      
      
      public function cleanup() : void
      {
         _model = null;
      }
      
      
      public function setDepth() : void
      {
      }
      
      
      public function getBuilding() : Building
      {
         return model as Building;
      }
      
      
      private var _restrictBuilding: Boolean = false;
      /**
       * Indicates if building can be built in the place where it is now. 
       */
      public function set restrictBuilding(v:Boolean) : void
      {
         _restrictBuilding = v;
         invalidateSkinState();
      }
      public function get restrictBuilding() : Boolean
      {
         return _restrictBuilding;
      }
      
      
      /* ############ */
      /* ### SKIN ### */
      /* ############ */
      
      
      [SkinPart(required="true")]
      /**
       * @copy components.gameobjects.planet.InteractivePlanetMapObject#mainImage
       */
      public var mainImage:BitmapImage;
      
      
      /**
       * @copy components.gameobjects.planet.InteractivePlanetMapObject#setMainImageSource()
       */
      private function setMainImageSource() : void
      {
         if (mainImage)
         {
            mainImage.source = model.imageData;
         }
      }
      
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName, instance);
         
         if (instance == mainImage)
         {
            setMainImageSource();
         }
      }
      
      
      override protected function getCurrentSkinState() : String
      {
         if (restrictBuilding)
         {
            return "restrict";
         }
         return "normal";
      }
   }
}