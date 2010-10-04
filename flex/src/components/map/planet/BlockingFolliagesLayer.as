package components.map.planet
{
   import components.gameobjects.planet.BlockingFolliageMapObject;
   
   import models.folliage.BlockingFolliage;
   
   
   public class BlockingFolliagesLayer extends PlanetVirtualLayer
   {
      override protected function get componentClass() : Class
      {
         return BlockingFolliageMapObject;
      }
      
      
      override protected function get modelClass() : Class
      {
         return BlockingFolliage;
      }
      
      
      override protected function get objectsListName() : String
      {
         return "blockingFolliages";
      }
   }
}