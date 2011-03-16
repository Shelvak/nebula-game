package utils.datastructures.iterators
{
   import flash.errors.IllegalOperationError;

   internal class BaseIterator implements IIterator
   {
      private var _currentIndex:int,
                  _removeCalled:Boolean;
      
      
      public function BaseIterator()
      {
         super();
         reset();
      }
      
      
      public function reset() : void
      {
         _currentIndex = -1;
         _removeCalled = true;
      }
      
      
      public function get hasNext() : Boolean
      {
         return _currentIndex + 1 < length;
      }
      
      
      /**
       * Must return total number of elements in the iteration.
       */
      protected function get length() : int
      {
         throwAbstractMethodError();
         return 0;   // unreachable
      }
      
      
      public function next() : *
      {
         _currentIndex++;
         _removeCalled = false;
         return getItemAt(_currentIndex);
      }
      
      
      /**
       * Override this instead of <code>next()</code>. This method should return an element at
       * the given <code>index</code> of a collection beeing iterated over.
       */
      protected function getItemAt(index:int) : *
      {
         throwAbstractMethodError();
      }
      
      
      public function remove() : *
      {
         if (_removeCalled)
         {
            throw new IllegalOperationError("Only one remove() operation allowed after next()");
         }
         var itemRemoved:* = removeItemAt(_currentIndex);
         _currentIndex--;
         _removeCalled = true;
         return itemRemoved;
      }
      
      
      /**
       * Override this instead of <code>remove()</code>: you just need to remove an element from the
       * collection at the given index.
       */
      protected function removeItemAt(index:int) : *
      {
         throwAbstractMethodError();
      }
      
      
      public function forEach(callback:Function) : void
      {
         var item:Object;
         while (hasNext)
         {
            item = next();
            callback.call(null, item);
         }
         reset();
      }
      
      
      private function throwAbstractMethodError() : void
      {
         throw new IllegalOperationError("This method is abstract!");
      }
   }
}