package ext.flex.mx.collections
{
   import flash.errors.IllegalOperationError;
   
   import interfaces.ICleanable;
   
   import mx.collections.IList;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;

   
   /**
    * A collection backed by another collection: this collection is notified if <code>master</code>
    * collection (original (wrapped) collection) gets modified and original collection is modified
    * if you modify this collection. Sorts and filters are not applied to original collection.
    * However, if a sort or filter is applied to original collection, <code>slave</code> (this
    * (wrapper) collection) gets modified.
    * 
    * <p>This collection will not maintain order of items neither if <code>slave</code> is modified
    * nor if <code>master</code> is modified directly: all items will be added to the end of
    * <code>slave</code> if <code>master</code> is modified and all items will be added to the end
    * of <code>master</code> if you modify <code>slave</code>. Therefore, calling following methods
    * at any time will result with <code>IllegalOperationError</code>:
    * <ul>
    *    <li>addItemAt()</li>
    *    <li>addAllAt()</li>
    *    <li>removeItemAt()</li>
    *    <li>setItemAt()</li>
    * </ul>
    * For reasons described above applying sorts and filter to <code>master</code> collection is
    * <b>not recommended</b>.
    * </p>
    * 
    * <p>If this collection can't be modified (you pass <code>false</code> as a second parameter
    * for the constructor), calling following methods and reading following properties will result
    * in <code>IllegalOperationError</code>:
    * <ul>
    *    <li>addItem()</li>
    *    <li>addAll()</li>
    *    <li>removeItem()</li>
    *    <li>removeAll()</li>
    *    <li>master</li>
    * </ul>
    * </p>
    */
   public class ArrayCollectionSlave extends ArrayCollection implements ICleanable
   {
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      /**
       * Creates slave collection wrapping the given <code>master</code> collection.
       * 
       * @param master a collection which will be wrapped and used a source for data
       * @param modifiable if <code>false</code> is passed, you won't be able to modify this
       * collection (<code>master</code> collection can still be modified)
       */
      public function ArrayCollectionSlave(master:mx.collections.IList, modifiable:Boolean = true)
      {
         super();
         _master = master;
         _modifiable = modifiable;
         f_allowModification = f_modifySlave = true;
         addAll(_master);
         f_allowModification = f_modifySlave = false;
         addMasterCollectionEventHandlers(_master);
      }
      
      
      public function cleanup() : void
      {
         if (_master)
         {
            removeMasterCollectionEventHandlers(_master);
            _master = null;
         }
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _master:mx.collections.IList;
      /**
       * Original collection wrapped by <code>this</code>.
       */
      public function get master() : mx.collections.IList
      {
         return _master;
      }
      
      
      private var _modifiable:Boolean = true;
      /**
       * Indicates if this collection can be modified.
       */
      public function get modifiable() : Boolean
      {
         return _modifiable;
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      private var f_allowModification:Boolean = false;
      private var f_modifySlave:Boolean = false;
      
      
      public override function addItemAt(item:Object, index:int) : void
      {
         internalModificationCheck();
         super.addItemAt(item, index);
      }
      
      
      public override function addAllAt(addList:mx.collections.IList, index:int) : void
      {
         internalModificationCheck();
         super.addAllAt(addList, index);
      }
      
      
      public override function setItemAt(item:Object, index:int) : Object
      {
         internalModificationCheck();
         return super.setItemAt(item, index);
      }
      
      
      public override function removeItemAt(index:int) : Object
      {
         internalModificationCheck();
         return super.removeItemAt(index);
      }
      
      
      public override function addItem(item:Object) : void
      {
         externalModificationCheck();
         if (f_modifySlave)
         {
            super.addItem(item);
         }
         else
         {
            _master.addItem(item);
         }
      }
      
      
      public override function addAll(addList:mx.collections.IList) : void
      {
         externalModificationCheck();
         if (f_modifySlave)
         {
            super.addAll(addList);
         }
         else
         {
            for each (var item:Object in addList)
            {
               _master.addItem(item);
            }
         }
      }
      
      
      public override function removeItem(item:Object) : Object
      {
         externalModificationCheck();
         if (f_modifySlave)
         {
            return super.removeItem(item);
         }
         else
         {
            return _master.removeItemAt(_master.getItemIndex(item));
         }
      }
      
      
      public override function removeAll() : void
      {
         externalModificationCheck();
         if (f_modifySlave)
         {
            super.removeAll();
         }
         else
         {
            var itemsToRemove:Array = new Array();
            for each (var item:Object in this)
            {
               itemsToRemove.push(item);
            }
            for each (item in itemsToRemove)
            {
               _master.removeItemAt(_master.getItemIndex(item));
            }
         }
      }
      
      
      /* ######################################## */
      /* ### MASTER COLLECTION EVENT HANDLERS ### */
      /* ######################################## */
      
      
      private function addMasterCollectionEventHandlers(master:mx.collections.IList) : void
      {
         master.addEventListener(CollectionEvent.COLLECTION_CHANGE, master_collectionChangeHandler);
      }
      
      
      private function removeMasterCollectionEventHandlers(master:mx.collections.IList) : void
      {
         master.removeEventListener(CollectionEvent.COLLECTION_CHANGE, master_collectionChangeHandler);
      }
      
      
      private function master_collectionChangeHandler(event:CollectionEvent) : void
      {
         f_allowModification = f_modifySlave = true;
         var items:mx.collections.ArrayCollection = new mx.collections.ArrayCollection(event.items);
         switch(event.kind)
         {
            case CollectionEventKind.ADD:
               addAll(items);
               break;
            case CollectionEventKind.REMOVE:
               for each (var item:Object in items)
               {
                  if (contains(item))
                  {
                     removeItem(item);
                  }
               }
               break;
            case CollectionEventKind.REPLACE:
               for each (var eventItem:PropertyChangeEvent in items)
               {
                  if (contains(eventItem.oldValue))
                  {
                     removeItem(eventItem.oldValue);
                  }
                  addItem(eventItem.newValue);
               }
               break;
            case CollectionEventKind.REFRESH:
            case CollectionEventKind.RESET:
               removeAll();
               addAll(_master);
               break;
         }
         refresh();
         f_allowModification = f_modifySlave = false;
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function externalModificationCheck() : void
      {
         if (!f_allowModification && !_modifiable)
         {
            throw new IllegalOperationError("This collection is not modifiable");
         }
      }
      
      
      private function internalModificationCheck() : void
      {
         if (!f_allowModification)
         {
            throw new IllegalOperationError("Method is not supported");
         }
      }
   }
}