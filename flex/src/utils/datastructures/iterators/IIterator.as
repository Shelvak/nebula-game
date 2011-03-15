package utils.datastructures.iterators
{
   /**
    * An iterator over a collection. Don't modify the collection directly and use the iterator
    * at the same time because in that case behaviour of an iterator is not specified.
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
       * Removes current element of the iteration from a collection and returns it. You can only call this
       * method once after each <code>next()</code> operation.
       */
      function remove() : *;
      
      
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