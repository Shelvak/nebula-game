package utils.datastructures.iterators
{
   import utils.ClassUtil;

   public class ArrayIterator extends BaseIterator
   {
      private var _array:Array;
      
      
      /**
       * @param array instance of an Array to iterate over
       */
      public function ArrayIterator(array:Array)
      {
         super();
         ClassUtil.checkIfParamNotNull("array", array);
         _array = array;
      }
      
      
      protected override function getItemAt(index:int) : *
      {
         return _array[index];
      }
      
      
      protected override function removeItemAt(index:int) : *
      {
         return _array.splice(index, 1)[0];
      }
      
      
      protected override function get length() : int
      {
         return _array.length;
      }
   }
}