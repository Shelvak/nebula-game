package utils.datastructures.iterators
{
   import mx.collections.IList;
   
   import utils.ClassUtil;

   public class ListIterator extends BaseIterator
   {
      private var _list:IList,
                  _currentIndex:int;
      
      
      public function ListIterator(list:IList)
      {
         super();
         ClassUtil.checkIfParamNotNull("list", list);
         _list = list;
         reset();
      }
      
      
      public override function next() : *
      {
         _currentIndex++;
         return _list.getItemAt(_currentIndex);
      }
      
      
      public override function reset() : void
      {
         _currentIndex = -1;
      }
      
      
      public override function get hasNext() : Boolean
      {
         return _currentIndex + 1 < _list.length;
      }
   }
}