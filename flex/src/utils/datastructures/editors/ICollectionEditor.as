package utils.datastructures.editors
{
   import interfaces.IEqualsComparable;
   
   import utils.datastructures.iterators.IIterator;
   
   
   /**
    * An editor of a collection which supports operations like adding and removing elements. 
    */
   public interface ICollectionEditor
   {
      /**
       * Adds the given item to the end of a collection.
       * 
       * @return <code>item</code>
       */
      function addItem(item:*) : *;
      
      
      /**
       * Iterates over a collection using the given iterator and adds all items to collection bound
       * to this editor.
       * 
       * @param it iterator over another collection. Will be reset. <b>Not null</b>. 
       */
      function addAll(it:IIterator) : void;
      
      
      /**
       * Removes given item from a collection. Items are compared using <code>equals()</code> method
       * of <code>IEqualsComparable</code> interface or strict equality (===) operator if an item in
       * a collection does not implement <code>IEqualsComparable</code>. In case of <code>equals()</code>
       * only the first item to return <code>true</code> is removed.
       * 
       * @param item item to remove. Can be null.
       * @param silent if <code>false</code>, will throw <code>ArgumentError</code> when item to
       * remove is not in a collection.
       * 
       * @return item removed or <code>null</code> if an item was not removed.
       */
      function removeItem(item:*, silent:Boolean = false) : *;
      
      
      /**
       * Removes all elements in a collection.
       */
      function removeAll() : void;
      
      
      /**
       * Number of elements in a collection bound to this editor.
       */
      function get length() : int;
      
      
      /**
       * Returns <code>true</code> if a collection bound to this editor has any elements.
       */
      function get hasItems() : Boolean;
   }
}