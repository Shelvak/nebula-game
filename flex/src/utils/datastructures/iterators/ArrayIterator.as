package utils.datastructures.iterators
{
   import utils.ClassUtil;

   public class ArrayIterator extends BaseIterator
   {
      private var _array:Array,
                  _currentIndex:int;
      
      
      /**
       * @param array instance of an Array to iterate over
       */
      public function ArrayIterator(array:Array)
      {
         super();
         ClassUtil.checkIfParamNotNull("array", array);
         _array = array;
         reset();
      }
      
      
      public override function next() : *
      {
         _currentIndex++;
         return _array[_currentIndex];
      }
      
      
      public override function reset() : void
      {
         _currentIndex = -1;
      }
      
      
      public override function get hasNext() : Boolean
      {
         return _currentIndex + 1 < _array.length;
      }
   }
}