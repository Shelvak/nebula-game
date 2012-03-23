package models
{
   import mx.collections.ArrayCollection;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;

   import utils.Objects;
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
      private var _modelsHash: Object = new Object();

      private function addModelToHash(model: BaseModel): void {
         if (model.id > 0) {
            if (_modelsHash[model.id] != null)
            {
               throw new ArgumentError("Failed to add model to collection, model with same id already exists\n" +
                  "Old model: " + _modelsHash[model.id] + "\n" +
                  "New model: " + model);
            }
            _modelsHash[model.id] = model;
         }
      }

      private function removeModelFromHash(model: BaseModel): void {
         if (model.id > 0) {
            delete _modelsHash[model.id];
         }
      }

      private function getModelFromHash(id: int): BaseModel {
         return _modelsHash[id];
      }

      public function ModelsCollection(source: Array = null) {
         super(source);
         for each (var model: BaseModel in source) {
            addModelToHash(model);
         }
         addEventListener(
            CollectionEvent.COLLECTION_CHANGE, this_collectionChangeEvent
         )
      }

      private function this_collectionChangeEvent(event: CollectionEvent): void {
         if (event.kind == CollectionEventKind.RESET) {
            _modelsHash = new Object();
         }
      }

      [Bindable(event="collectionChange")]
      public function get isEmpty(): Boolean {
         return length == 0;
      }

      /**
       * Returns first model in this collection or <code>null</code> if its is empty.
       */
      public function getFirst(): * {
         return !isEmpty ? getItemAt(0) : null;
      }

      /**
       * Returns last model in this collection or <code>null</code> if its is empty.
       */
      public function getLast(): * {
         return !isEmpty ? getItemAt(length - 1) : null;
      }

      /**
       * Looks for model with given id and returns that model or <code>null</code> if one could not
       * be found.
       */
      public function find(id: int): * {
         return getModelFromHash(Objects.paramIsId("id", id));
      }

      public override function addItemAt(item: Object, index: int): void {
         Objects.requireType(item, BaseModel);
         addModelToHash(BaseModel(item));
         super.addItemAt(item, index);
      }

      public override function removeItemAt(index: int): Object {
         const model: BaseModel = BaseModel(super.removeItemAt(index));
         removeModelFromHash(model);
         return model;
      }

      /**
       * @return <code>true</code> if model has been added or <code>false</code>
       * if updated
       */      
      public function addOrUpdate(model:Object, type: Class) : Boolean
      {
         const existingModel: BaseModel = find(model["id"]);
         if (existingModel == null) {
            addItem(Objects.create(type, model));
            return true;
         }
         else {
            Objects.update(existingModel, model);
            return false;
         }
      }

      /**
       * Looks for model with specific ID as the given one and then
       * updates it (calls <code>Objects.update()</code>).
       */
      public function update(model: Object): void {
         const modelToUpdate: Object = find(model.id);
         if (modelToUpdate) {
            Objects.update(modelToUpdate, model);
         }
         else {
            throw new ArgumentError(
               "Could not find " + 'model' + ": can't update"
            );
         }
      }

      /**
       * Removes model with given id or throws error if such model does not exist.
       */
      public function remove(id: int, silent: Boolean = false): * {
         return Collections.removeFirst(
            this,
            function (model: BaseModel): Boolean {
               return model.id == id;
            },
            silent
         );
      }

      /**
       * Removes model equal to (uses <code>equals()</code> method) the given one.
       */
      public function removeExact(model:BaseModel, silent:Boolean = false) : * {
         return Collections.removeFirstEqualTo(this, model, silent);
      }

      /**
       * Will return a collection not bound to this one and containing only those models for which
       * <code>filterFunction</code> returned <code>true</code>.
       */
      public function filter(filterFunction: Function): ModelsCollection {
         const source: Array = new Array();
         for each (var model: BaseModel in this) {
            if (filterFunction(model)) {
               source.push(model);
            }
         }
         return new ModelsCollection(source);
      }

      /**
       * Shuffles this collection.
       */
      public function shuffle(random: Rndm = null): void {
         if (random == null) {
            random = Rndm.instance;
         }

         for (var i: int = 0; i < length; i++) {
            var randomNumber: int = random.integer(0, length - 1);
            var tmp: Object = getItemAt(i);
            setItemAt(getItemAt(randomNumber), i);
            setItemAt(tmp, randomNumber);
         }
      }
   }
}