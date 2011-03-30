package utils.datastructures
{
   /**
    * Simple FIFO list backed by <code>Array</code>. 
    */   
   public class SimpleStack
   {
      private var array:Array = new Array();
      
      /**
       * Indicates if the stack is empty.
       */      
      public function get isEmpty() : Boolean
      {
         return array.length == 0;
      }
      
      /**
       * Adds new item on top of the stack.
       * @param item
       * 
       */
      public function push(item:*) : void
      {
         array.push(item);
      }
      
      /**
       * Returns the top item of the stack but does not removes it. You must ensure
       * that there are elements in the stack before calling this method.
       *  
       * @return Top item of the stack.
       * 
       * @see #isEmpty
       */      
      public function top() : *
      {
         return array[array.length - 1];
      }
      
      /**
       * Removes and returns the top item of the stack. You must ensure
       * that there are elements in the stack before calling this method.
       * 
       * @return Item that has juts been removed from the stack.
       * 
       * @see #isEmpty
       */      
      public function pop() : *
      {
         return array.pop();
      }
      
      /**
       * Clears the stack.
       */      
      public function clear() : void
      {
         array = new Array();
      }
   }
}