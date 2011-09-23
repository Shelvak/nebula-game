package models
{
   import mx.collections.ArrayCollection;
   
   import utils.datastructures.Collections;
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
       * @param list any iterable object
       * 
       * @see ModelsCollection
       */
      public static function createFrom(list: *) : ModelsCollection
      {
         var source:Array = new Array();
         for each (var item:Object in list)
         {
            source.push(item);
         }
         return new ModelsCollection(source);
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
      
      
      /**
       * Returns first model in this collection or <code>null</code> if its is empty.
       */
      public function getFirst() : *
      {
         return !isEmpty ? getItemAt(0) : null;
      }
      
      
      /**
       * Returns last model in this collection or <code>null</code> if its is empty.
       */
      public function getLast() : *
      {
         return !isEmpty ? getItemAt(length - 1) : null;
      }
      
      
      /**
       * Looks for model with given id and returns its index or <code>-1</code> if such model
       * does not exist.
       */
      public function findIndex(id:int) : int {
         return Collections.findFirstIndexWithId(this, id);
      }
      
      
      /**
       * Looks for model equal to given one (uses <code>equals()</code>) and returns its index or
       * <code>-1</code> if such model does not exist.
       */
      public function findIndexExact(model:BaseModel) : int {
         return Collections.findFirstIndexEqualTo(this, model);
      }
      
      
      /**
       * Looks for model with given id and returns that model or <code>null</code> if one could not
       * be found.
       */
      public function find(id:int) : * {
         return Collections.findFirstWithId(this, id);
      }
      
      
      /**
       * Looks for for model equal to given one (uses <code>equals()</code>) and returns that model
       * or <code>null</code> if one could not be found.
       */
      public function findExact(model:BaseModel) : * {
         return Collections.findFirstEqualTo(this, model);
      }
      
      
      /**
       * Adds the given model to this collection or updates a model already in the collection
       * (uses <code>equals()</code> method).
       * 
       * @throws Error if <code>item</code> is not a <code>BaseModel</code>
       * 
       * @see mx.collections.ArrayCollection#addItemAt()
       */
      public override function addItemAt(item:Object, index:int) : void {
         checkItemType(item);
         super.addItemAt(item, index);
      }
      
      
      /**
       * 
       * @param model
       * @return <code>true</code> if model has been added or <code>false</code> if updated 
       */      
      public function addOrUpdate(model:BaseModel) : Boolean
      {
         var idx:int = findIndexExact(model);
         if (idx < 0)
         {
            addItem(model);
            return true;
         }
         else
         {
            BaseModel(getItemAt(idx)).copyProperties(model);
            return false;
         }
      }
      
      
      /**
       * Looks for exact (uses <code>equals()</code> method) medel as the given one and then
       * updates it (calls <code>copyProperties()</code>).
       * 
       * @throws ArgumentError if model to update could not be found
       */
      public function update(model:BaseModel) : void
      {
         var modelToUpdate:BaseModel = findExact(model);
         if (modelToUpdate)
         {
            modelToUpdate.copyProperties(model);
         }
         else
         {
            throw new ArgumentError("Could not find " + model + ": can't update");
         }
      }
      
      
      /**
       * Removes model with given id or throws error if such model does not exist.
       */
      public function remove(id:int, silent:Boolean = false) : *
      {
         return Collections.removeFirst(
            this,
            function(model:BaseModel) : Boolean {
               return model.id == id;
            },
            silent
         );
      }
      
      
      /**
       * Removes model equal to (uses <code>equals()</code> method) the given one or throws error if
       * such model does not exist.
       */
      public function removeExact(model:BaseModel, silent:Boolean = false) : * {
         return Collections.removeFirstEqualTo(this, model, silent);
      }
      
      
      /**
       * Will return a collection not bound to this one and containing only those models for which
       * <code>filterFunction</code> returned <code>true</code>.
       */
      public function filter(filterFunction:Function) : ModelsCollection
      {
         var source:Array = new Array();
         for each (var model:BaseModel in this)
         {
            if (filterFunction(model))
            {
               source.push(model);
            }
         }
         return new ModelsCollection(source);
      }
      
      
      /**
       * Suffles this collection.
       */
      public function shuffle(random:Rndm = null) : void
      {
         if (random == null)
         {
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
      
      
      private function checkItemType(item:Object) : void
      {
         if ( !(item is BaseModel) )
         {
            throw new Error(item + " is not an instance of BaseModel");
         }
      }
   }
}