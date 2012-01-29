package components.map.planet
{
   import animation.AnimationTimer;


   import models.folliage.NonblockingFolliage;
   import models.planet.MPlanetObject;

   import components.map.planet.objects.IPrimitivePlanetMapObject;
   import components.map.planet.objects.PrimitivePlanetMapObject;

   import mx.collections.ListCollectionView;


   public class NonblockingFolliagesLayer extends PlanetVirtualLayer
   {
      override protected function get componentClass(): Class {
         return PrimitivePlanetMapObject;
      }

      override protected function get modelClass(): Class {
         return NonblockingFolliage;
      }

      override protected function get objectsList(): ListCollectionView {
         return planet.nonblockingFolliages;
      }

      protected override function addObjectImpl(object: MPlanetObject): IPrimitivePlanetMapObject {
         var component: PrimitivePlanetMapObject =
                PrimitivePlanetMapObject(super.addObjectImpl(object));
         component.setTimer(AnimationTimer.forPlanet);
         return component;
      }
   }
}