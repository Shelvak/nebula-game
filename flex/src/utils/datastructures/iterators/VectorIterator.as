package utils.datastructures.iterators
{
   public class VectorIterator extends BaseIterator
   {
      private var _vector:Vector,
                  _currentIndex:int;
      
      
      /**
       * @param vector an istance of Vector to iterate over
       */
      public function VectorIterator(vector:Vector)
      {
         super();
         _vector = vector;
         reset();
      }
      
      
      public override function next() : *
      {
         _currentIndex++;
         return _vector[_currentIndex];
      }
      
      
      public override function reset() : void
      {
         _currentIndex = -1;
      }
      
      
      public override function get hasNext() : Boolean
      {
         return _currentIndex + 1 < _vector.length;
      }
   }
}