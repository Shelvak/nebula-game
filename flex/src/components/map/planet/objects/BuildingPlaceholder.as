package components.map.planet.objects
{
   
   import components.map.planet.TileState;
   
   import models.building.Building;
   import models.tile.Tile;

   import mx.core.UIComponent;

   import spark.components.Group;
   import spark.primitives.BitmapImage;
   
   
   /**
    * This is a component that is shown when user wants to build a new building and looks
    * for a place to build it. 
    */
   public class BuildingPlaceholder extends CObjectPlaceholder
   {
      override protected function commitModel() : void  {
         super.commitModel();
         initInterferingTiles();
      }
      
      public function getBuilding() : Building {
         return Building(model);
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      private var _basement:PlanetObjectBasementTiled;
      override protected function createBasement(): UIComponent {
         const gap:int = Building.GAP_BETWEEN;
         const addSize:int = gap * 2;
         const basement:PlanetObjectBasementTiled =
                  new PlanetObjectBasementTiled(
                     TileState.BUILD_RESTRICT,
                     model.width  + addSize,
                     model.height + addSize
                  );
         basement.bottom = -Tile.IMAGE_HEIGHT * gap;
         basement.right  = -Tile.IMAGE_WIDTH * gap;
         return basement;
      }
      
      
      /* ################### */
      /* ### TILES UNDER ### */
      /* ################### */

      private var _interferingTiles: Vector.<Vector.<Boolean>>;
      private function initInterferingTiles(): void {
         if (model == null) {
            return;
         }
         var width: int = model.width + Building.GAP_BETWEEN * 2;
         var height: int = model.height + Building.GAP_BETWEEN * 2;
         _interferingTiles = new Vector.<Vector.<Boolean>>(width, true);
         for (var lx: int = 0; lx < width; lx++) {
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
      public function get interferingTiles(): Vector.<Vector.<Boolean>> {
         return _interferingTiles;
      }

      /**
       * Call this when you are done modifying the <code>interferingTiles</code> array to apply the changes.
       */
      public function applyInterferingTiles(): void {
         f_interferingTilesChanged = true;
         invalidateProperties();
      }

      /**
       * Marks all tiles as interfering with building process (if <code>value == true</code>) or
       * not (if <code>value = false</code>).
       */
      public function resetInterferingTiles(value: Boolean = true): void {
         if (model == null) {
            return;
         }
         var width: int = model.width + Building.GAP_BETWEEN * 2;
         var height: int = model.height + Building.GAP_BETWEEN * 2;
         for (var lx: int = 0; lx < width; lx++) {
            for (var ly: int = 0; ly < height; ly++) {
               _interferingTiles[lx][ly] = value;
            }
         }
         applyInterferingTiles();
      }

      private var f_interferingTilesChanged: Boolean = true;
      protected override function commitProperties(): void {
         super.commitProperties();
         if (!f_interferingTilesChanged || model == null) {
            return;
         }
         var width: int = model.width + Building.GAP_BETWEEN * 2;
         var height: int = model.height + Building.GAP_BETWEEN * 2;
         for (var lx: int = 0; lx < width; lx++) {
            for (var ly: int = 0; ly < height; ly++) {
               _basement.tileStates[lx][ly] = _interferingTiles[lx][ly]
                                                 ? TileState.BUILD_RESTRICT
                                                 : TileState.BUILD_OK;
            }
         }
         _basement.applyTileStates();
         f_interferingTilesChanged = false;
      }
   }
}