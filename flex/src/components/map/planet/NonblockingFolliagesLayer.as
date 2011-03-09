package components.map.planet
{
   import animation.AnimationTimer;
   
   
   import models.folliage.NonblockingFolliage;
   import models.planet.PlanetObject;
   import components.map.planet.objects.IPrimitivePlanetMapObject;
   import components.map.planet.objects.PrimitivePlanetMapObject;
   
   
   public class NonblockingFolliagesLayer extends PlanetVirtualLayer
   {
      override protected function get componentClass() : Class
      {
         return PrimitivePlanetMapObject;
      }
      
      
      override protected function get modelClass() : Class
      {
         return NonblockingFolliage;
      }
      
      
      override protected function get objectsListName() : String
      {
         return "nonblockingFolliages";
      }
      
      
      protected override function addObjectImpl(object:PlanetObject):IPrimitivePlanetMapObject
      {
         var component:PrimitivePlanetMapObject = super.addObjectImpl(object) as PrimitivePlanetMapObject;
         component.setTimer(AnimationTimer.forPlanet);
         return component;
      }
   }
}