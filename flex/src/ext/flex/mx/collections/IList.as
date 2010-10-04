package ext.flex.mx.collections
{
   import mx.collections.IList;
   
   public interface IList extends mx.collections.IList, ICollectionView
   {
      /**
       * Removes given item form the list.
       * 
       * @param item item to remove (can't be <code>null</code>)
       * 
       * @return item which has been removed
       * 
       * @throws IllegalOperationError if the item could not be found in the list and therefore
       * could not be removed from it  
       */
      function removeItem(item:Object) : Object;
      
      
      /**
       * @copy mx.collections.ArrayCollection.addAll()
       */
      function addAll(addList:mx.collections.IList) : void;
      
      
      /**
       * @copy mx.collections.ArrayCollection.addAllAt()
       */
      function addAllAt(addList:mx.collections.IList, index:int) : void;
   }
}