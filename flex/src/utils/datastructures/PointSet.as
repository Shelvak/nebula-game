package utils.datastructures
{
   import components.technologytree.TechPoint;
   
   public class PointSet extends Set
   {
      public function PointSet()
      {
         super(
            function(item: TechPoint): String
            {
               return item.xPos+','+item.yPos;
            }
         );
      }
   }
}