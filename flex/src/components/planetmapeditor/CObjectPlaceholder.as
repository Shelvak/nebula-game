package components.planetmapeditor
{
   import components.map.planet.objects.CObjectPlaceholder;
   import components.map.planet.objects.PlanetObjectBasement;

   import models.building.Building;
   import models.tile.Tile;

   import mx.core.UIComponent;


   public class CObjectPlaceholder
      extends components.map.planet.objects.CObjectPlaceholder
   {

      private var _basement:PlanetObjectBasement = null;

      override protected function createBasement(): UIComponent {
         _basement = new PlanetObjectBasement();
         return _basement;
      }

      override protected function commitModel(): void {
         super.commitModel();
         if (model == null) {
            return;
         }
         var gap:int = 0;
         var addSize:int = 0;
         if (model is Building) {
            gap = Building.GAP_BETWEEN;
            addSize = gap * 2;
         }
         _basement.logicalWidth = model.width + addSize;
         _basement.logicalHeight = model.height + addSize;
         _basement.bottom = -Tile.IMAGE_HEIGHT * gap;
         _basement.right  = -Tile.IMAGE_WIDTH * gap;
      }
   }
}
