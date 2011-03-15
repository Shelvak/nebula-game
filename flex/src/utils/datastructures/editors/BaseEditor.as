package utils.datastructures.editors
{
   import flash.errors.IllegalOperationError;
   
   import interfaces.IEqualsComparable;
   
   import utils.ClassUtil;
   import utils.datastructures.iterators.IIterator;
   import utils.datastructures.iterators.IIteratorFactory;
   
   
   internal class BaseEditor implements ICollectionEditor
   {
      private var _it:IIterator;
      
      
      public function BaseEditor(collection:*)
      {
         super();
         ClassUtil.checkIfParamNotNull("collection", collection);
         _it = IIteratorFactory.getIterator(collection);
      }
      
      
      public function addItem(item:*) : *
      {
         throwAbstractMethodError();
      }
      
      
      public function addAll(it:IIterator) : void
      {
         ClassUtil.checkIfParamNotNull("it", it);
         while (it.hasNext)
         {
            addItem(it.next());
         }
         it.reset();
      }
      
      
      public function removeItem(item:*, silent:Boolean = false) : *
      {
         _it.reset();
         while (_it.hasNext)
         {
            var $item:* = _it.next();
            if ($item === item ||
                $item is IEqualsComparable && IEqualsComparable($item).equals(item))
            {
               return _it.remove();
            }
         }
         if (silent)
         {
            return null;
         }
         else
         {
            throwItemNotFoundError(item);
         }
      }
      
      
      public function removeAll() : void
      {
         throwAbstractMethodError();
      }
      
      
      public function get length() : int
      {
         throwAbstractMethodError();
         return 0;   // unreachable
      }
      
      
      public function get hasItems() : Boolean
      {
         return length > 0;
      }
      
      
      private function throwAbstractMethodError() : void
      {
         throw new IllegalOperationError("This method is abstract!");
      }
      
      
      private function throwItemNotFoundError(item:*) : void
      {
         throw new ArgumentError("Unable to perform operation: item " + item + " not found");
      }
   }
}