package utils.datastructures.iterators
{
   /**
    * An iterator over a collection.
    */
   public interface IIterator
   {
      /**
       * Resets the iterator before the first element in the collection.
       */
      function reset() : void;
      
      
      /**
       * Returns <code>true</code> if iteration has more elements.
       */
      function get hasNext() : Boolean;
      
      
      /**
       * Moves the cursor to the next element the iteration and returns it.
       */
      function next() : *;
      
      
      /**
       * Iterates over the collection and invokes the given callback on each element. Resets iterator
       * after that so that it could be used again.
       * 
       * @param callback a function to call for each element in the interation. The callback will be
       * passed an element as the only argument.
       */
      function forEach(callback:Function) : void;
   }
}