package utils.datastructures.iterators
{
   public class VectorIterator extends BaseIterator
   {
      private var _vector:Object;
      
      
      /**
       * @param vector an istance of Vector to iterate over
       */
      public function VectorIterator(vector:Object)
      {
         super();
         _vector = vector;
      }
      
      
      protected override function getItemAt(index:int) : *
      {
         return _vector[index];
      }
      
      
      protected override function removeItemAt(index:int) : *
      {
         return _vector.splice(index, 1)[0];
      }
      
      
      protected override function get length() : int
      {
         return _vector.length;
      }
   }
}