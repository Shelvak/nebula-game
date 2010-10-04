package utils.datastructures
{

   public class IntSet extends Set
   {
      public function IntSet()
      {
         super (
            function (i: int): String
            {
               return i.toString();
            }
         );
      }
   }
}