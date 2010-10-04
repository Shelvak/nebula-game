package ext.flex.mx.collections
{
   import mx.collections.ICollectionView;
   
   public interface ICollectionView extends mx.collections.ICollectionView
   {
      /**
       * Indicates if this collection is empty.
       */
      function get isEmpty() : Boolean;
      
      /**
       * Returns last item in the list or <code>null</code> if there are no items.
       */
      function getLastItem() : Object;
      
      /**
       * Returns first item in the list or <code>null</code> if there are no items.
       */
      function getFirstItem() : Object;
   }
}