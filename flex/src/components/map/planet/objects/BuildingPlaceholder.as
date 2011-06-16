package components.map.planet.objects
{
   
   import components.map.planet.TileState;
   
   import models.building.Building;
   import models.tile.Tile;
   
   import spark.components.Group;
   import spark.primitives.BitmapImage;
   
   
   /**
    * This is a component that is shown when user want's to build a new building and looks
    * for a place to build it. 
    */
   public class BuildingPlaceholder extends Group implements IPrimitivePlanetMapObject
   {
      public function BuildingPlaceholder()
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
         focusEnabled = false;
      }
      
      
      include "mixin_defaultModelPropImpl.as";
      
      
      /**
       * @copy components.gameobjects.planet.PrimitivePlanetMapObject#initProperties()
       */
      protected function initProperties() : void
      {
         width  = model.imageWidth;
         height = model.imageHeight;
         initInterferingTiles();
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
         return Building(model);
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      private var _basement:PlanetObjectBasementTiled;
      
      
      protected override function createChildren() : void
      {
         super.createChildren();
         
         _basement = new PlanetObjectBasementTiled(
            TileState.BUILD_RESTRICT,
            getBuilding().width  + Building.GAP_BETWEEN * 2,
            getBuilding().height + Building.GAP_BETWEEN * 2
         );
         _basement.bottom = -Tile.IMAGE_HEIGHT;
         _basement.right  = -Tile.IMAGE_WIDTH;
         _basement.alpha = 0.3;
         addElement(_basement);
         
         var mainImage:BitmapImage = new BitmapImage();
         mainImage.source = getBuilding().imageData;
         addElement(mainImage);
      }
      
      
      /* ################### */
      /* ### TILES UNDER ### */
      /* ################### */
      
      
      private var _interferingTiles:Vector.<Vector.<Boolean>>;
      private function initInterferingTiles() : void
      {
         var width:int = getBuilding().width + Building.GAP_BETWEEN * 2;
         var height:int = getBuilding().height + Building.GAP_BETWEEN * 2;
         _interferingTiles = new Vector.<Vector.<Boolean>>(width, true);
         for (var lx:int = 0; lx < width; lx++)
         {
            _interferingTiles[lx] = new Vector.<Boolean>(height, true);
         }
         resetInterferingTiles();
      }
      /**
       * A 2D array which marks tiles under the placeholder as interfering with building process
       * (<code>true</code>) or not (<code>false</code>).
       * 
       * <p>Once you are done modifying this, invoke <code>applyInterferingTiles()</code> to apply the
       * changes.</p>
       */
      public function get interferingTiles() : Vector.<Vector.<Boolean>>
      {
         return _interferingTiles;
      }
      
      
      /**
       * Call this when you are done modifying the <code>interferingTiles</code> array to apply the changes.
       */
      public function applyInterferingTiles() : void
      {
         f_interferingTilesChanged = true;
         invalidateProperties();
      }
      
      
      /**
       * Marks all tiles as interfering with building process (if <code>value == true</code>) or
       * not (if <code>value = false</code>).
       */
      public function resetInterferingTiles(value:Boolean = true) : void
      {
         var width:int = getBuilding().width + Building.GAP_BETWEEN * 2;
         var height:int = getBuilding().height + Building.GAP_BETWEEN * 2;
         for (var lx:int = 0; lx < width; lx++)
         {
            for (var ly:int = 0; ly < height; ly++)
            {
               _interferingTiles[lx][ly] = value;
            }
         }
         applyInterferingTiles();
      }
      
      
      private var f_interferingTilesChanged:Boolean = true;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (f_interferingTilesChanged && getBuilding() != null)
         {
            var width:int  = getBuilding().width  + Building.GAP_BETWEEN * 2;
            var height:int = getBuilding().height + Building.GAP_BETWEEN * 2;
            for (var lx:int = 0; lx < width; lx++)
            {
               for (var ly:int = 0; ly < height; ly++)
               {
                  _basement.tileStates[lx][ly] = _interferingTiles[lx][ly] ?
                     TileState.BUILD_RESTRICT :
                     TileState.BUILD_OK;
               }
            }
            _basement.applyTileStates();
         }
         f_interferingTilesChanged = false;
      }
   }
}