package components.planetmapeditor
{
   import components.map.planet.PlanetVirtualLayer;
   import components.map.planet.objects.InteractivePlanetMapObject;

   import models.planet.MPlanetObject;

   import mx.collections.ListCollectionView;


   public class ObjectsEditorLayer extends PlanetVirtualLayer
   {
      override protected function get componentClass(): Class {
         return InteractivePlanetMapObject;
      }

      override protected function get modelClass(): Class {
         return MPlanetObject;
      }

      override protected function get objectsList(): ListCollectionView {
         return planet.objects;
      }
   }
}
