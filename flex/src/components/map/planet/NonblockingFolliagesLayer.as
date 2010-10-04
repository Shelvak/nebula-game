package components.map.planet
{
   import animation.AnimationTimer;
   
   import components.gameobjects.planet.IPrimitivePlanetMapObject;
   import components.gameobjects.planet.PrimitivePlanetMapObject;
   
   import models.folliage.NonblockingFolliage;
   import models.planet.PlanetObject;
   
   
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