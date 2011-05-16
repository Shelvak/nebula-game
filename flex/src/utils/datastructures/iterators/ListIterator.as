package utils.datastructures.iterators
{
   import mx.collections.IList;
   
   import utils.Objects;
   
   
   public class ListIterator extends BaseIterator
   {
      private var _list:IList;
      
      
      public function ListIterator(list:IList)
      {
         super();
         Objects.paramNotNull("list", list);
         _list = list;
      }
      
      
      protected override function getItemAt(index:int) : *
      {
         return _list.getItemAt(index);
      }
      
      
      protected override function removeItemAt(index:int) : *
      {
         return _list.removeItemAt(index);
      }
      
      
      protected override function get length() : int
      {
         return _list.length;
      }
   }
}