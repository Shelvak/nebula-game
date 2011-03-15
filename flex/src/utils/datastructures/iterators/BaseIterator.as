package utils.datastructures.iterators
{
   import flash.errors.IllegalOperationError;

   internal class BaseIterator implements IIterator
   {
      public function BaseIterator()
      {
      }
      
      
      public function reset() : void
      {
         throwAbstractMethodError();
      }
      
      
      public function get hasNext() : Boolean
      {
         throwAbstractMethodError();
      }
      
      
      public function next() : *
      {
         throwAbstractMethodError();
      }
      
      
      public function forEach(callback:Function):void
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