package models
{
   import flash.errors.IllegalOperationError;
   
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   
   import utils.ClassUtil;
   import utils.random.Rndm;
   
   /**
    * <b>IMPORTANT! If you don't need <code>findModel()</code> nor <code>findExactModel()</code>, do
    * not use this class. Use <code>ArrayCollection</code> instead.</b>
    * <p>If above is not the case, bare in your mind these terrible things:
    * <ul>
    *    <li><code>findModel()</code> and <code>findExactModel()</code> need O(n) time</li>
    *    <li><code>addItem()</code> and <code>addItemAt()</code> also need O(n) time because
    *        they use <code>findExactModel()</code></li>
    *    <li>When instantiating <code>ModelsCollection</code>, create an array with all needed items
    *        and then create the collection passing that array for the constructor, unless you do not
    *        have a lot of items (100 or so would be fine, but you can forget about 500 and more)</li>
    * </ul>
    * </p>
    */
   public class ModelsCollection extends ArrayCollection
   {
      /**
       * Use this as a shortcut for:
       * <pre>
       * var source:Array = new Array();
       * for each (var item:Object in list)
       * {
       * &nbsp;&nbsp;&nbsp;source.push(item);
       * }
       * return new ModelsCollection(source);
       * </pre>
       * See documentation of the class to find out why doing somethig like
       * <code>new ModelsCollection().addAll(list)</code> is a bad thing.
       * 
       * @param list an <code>Array</code>, <code>Vector</code>, <code>IList</code> or
       * <code>ICollectionView</code>; will not be modified
       * 
       * @see ModelsCollection
       */
      public static function createFrom(list:*) : ModelsCollection
      {
         var source:Array = new Array();
         for each (var item:Object in list)
         {
            source.push(item);
         }
         return new ModelsCollection(source);
      }
      
      
      /**
       * Looks for and returns a <code>BaseModel</code> with a given id in a
       * given list.
       * 
       * @param list a list containing instances of <code>BaseModel</code>
       * @param id id of a model
       * 
       * @return <code>BaseModel</code> with a given id or <code>null</code>
       * if one could not be found. 
       */
      public static function findModel(list:IList, id:int) : *
      {
         for each (var item:BaseModel in list)
         {
            if (item != null && item.id == id)
            {
               return item;
            }
         }
         return null;
      }
      
      
      /**
       * Looks for and returns a <code>BaseModel</code> equal to the given model.
       * 
       * @param list a list containing instances of <code>BaseModel</code>
       * @param model model to look fore
       * 
       * @return <code>BaseModel</code> equal to <code>model</code> or <code>null</code> if one
       * can't be found.
       */
      public static function findExactModel(list:IList, model:BaseModel) : *
      {
         for each (var item:BaseModel in list)
         {
            if (item != null && item.equals(model))
            {
               return item;
            }
         }
         return null;
      }
      
      
      /**
       * @see mx.collections.ArrayCollection#ArrayCollection()
       * @see ModelsCollection
       */
      public function ModelsCollection(source:Array = null)
      {
         super(source);
      }
      
      
      [Bindable(event="collectionChange")]
      public function get isEmpty() : Boolean
      {
         return length == 0;
      }
      
      
      public function findModel(id:int) : *
      {
         return ModelsCollection.findModel(this, id);
      }
      
      
      public function findExactModel(model:BaseModel) : *
      {
         return ModelsCollection.findExactModel(this, model);
      }
      
      
      /**
       * Adds the given model to this collection or updates a model already in the collection
       * (compared with <code>equals()</code> method).
       * 
       * @throws Error if <code>item</code> is not a <code>BaseModel</code>
       * 
       * @see mx.collections.ArrayCollection#addItemAt()
       */
      public override function addItemAt(item:Object, index:int) : void
      {
         checkItemType(item);
         var newModel:BaseModel = item as BaseModel;
         if (newModel.id == 0)
         {
            super.addItemAt(item, index);
            return;
         }
         var model:BaseModel = findExactModel(newModel);
         if (model)
         {
            model.copyProperties(newModel);
         }
         else
         {
            super.addItemAt(item, index);
         }
      }
      
      
      public function removeModelWithId(id:int) : *
      {
         var model:BaseModel = findModel(id);
         if (model)
         {
            removeItem(findModel(id));
         }
         return model;
      }
      
      
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
      public function filterItems(filterFunction:Function) : ModelsCollection
      {
         var result:ModelsCollection = ClassUtil.getInstance(this);
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
      
      
      private function checkItemType(item:Object) : void
      {
         if ( !(item is BaseModel) )
         {
            throw new Error(item + " is not an instance of BaseModel");
         }
      }
   }
}