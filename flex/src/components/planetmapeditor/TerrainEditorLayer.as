package components.planetmapeditor
{
   import components.map.planet.PlanetVirtualLayer;
   import components.map.planet.objects.IInteractivePlanetMapObject;
   import components.map.planet.objects.IPrimitivePlanetMapObject;

   import models.planet.MPlanetObject;

   import mx.collections.ArrayCollection;

   import mx.collections.ListCollectionView;


   public class TerrainEditorLayer extends PlanetVirtualLayer
   {
      

      /* ############## */
      /* ### NO-OPS ### */
      /* ############## */

      override protected function get componentClass(): Class {
         return null;
      }

      override protected function get modelClass(): Class {
         return null;
      }

      override protected function get objectsList(): ListCollectionView {
         return new ArrayCollection();
      }

      override protected function removeAllObjects(): void {
      }

      override public function objectSelected(object: IInteractivePlanetMapObject): void {
      }

      override public function objectDeselected(object: IInteractivePlanetMapObject): void {
      }

      override public function addObject(object: MPlanetObject): void {
      }

      override public function objectRemoved(object: IPrimitivePlanetMapObject): void {
      }

      override public function openObject(object: IPrimitivePlanetMapObject): void {
      }
   }
}
