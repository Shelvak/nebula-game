package ext.flex.mx.collections
{
   import flash.errors.IllegalOperationError;
   
   import mx.collections.ArrayCollection;
   
   import utils.ClassUtil;
   import utils.random.Rndm;
   
   public class ArrayCollection extends mx.collections.ArrayCollection implements IList
   {
      /**
       * @copy mx.collections.ArrayCollection#ArrayCollection()
       */
      public function ArrayCollection(source:Array = null)
      {
         super(source);
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      [Bindable(event="collectionChange")]
      public function get isEmpty() : Boolean
      {
         return length == 0;
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      public function getLastItem() : Object
      {
         return !isEmpty ? getItemAt(length - 1) : null;
      }
      
      
      public function getFirstItem() : Object
      {
         return !isEmpty ? getItemAt(0) : null;
      }
      
      
      public function removeItem(item:Object) : Object
      {
         ClassUtil.checkIfParamNotNull("item", item);
         if (!contains(item))
         {
            throwItemCantBeRemovedError(item);
         }
         return removeItemAt(getItemIndex(item));
      }
      
      
      /**
       * This method will create new collection which will have only those items for which
       * <code>filterFunction</code> returns <code>true</code>. To use this method, deriving
       * class must have no-args constructor.
       * 
       * @param see <code>ArrayCollection.filterFunction</code>
       * 
       * @return new collection of the same type as <code>this</code>. The returned collection can
       * be modified (original collection will not be changed) and will not be updated if original
       * collection has been modified.
       * 
       * @see ArrayCollection#filterFunction
       */
      public function filterItems(filterFunction:Function) : *
      {
         var result:ext.flex.mx.collections.ArrayCollection = ClassUtil.getInstance(this);
         for each (var item:Object in this)
         {
            if (filterFunction(item))
            {
               result.addItem(item);
            }
         }
         return result;
      }
      
      
      /**
       * Suffles this collection.
       */
      public function shuffle(random:Rndm=null) : void
      {
         if (random == null) {
            random = Rndm.instance;
         }
         
         for (var i:int = 0; i < length; i++)
         {
            var randomNumber:int = random.integer(0, length - 1);
            var tmp:Object = getItemAt(i);
            setItemAt(getItemAt(randomNumber), i);
            setItemAt(tmp, randomNumber);
         }
      }
      
      
      /**
       * Makes a shallow copy of this collection and returns it. Actual type of the collection
       * returned is that of <code>this</code> object. Therefore, to use this method, deriving
       * class must have no-args constructor.
       */
      public function shallowCopy() : *
      {
         var list:ext.flex.mx.collections.ArrayCollection = ClassUtil.getInstance(this);
         list.addAll(this);
         return list;
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      /**
       * @throws IllegalOperationError
       */
      private function throwItemCantBeRemovedError(item:Object) : void
      {
         throw new IllegalOperationError("Item " + item + " could not be found and therefore " +
                                         "can't be removed from the collection");
      }
   }
}