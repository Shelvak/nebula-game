package utils.datastructures
{
   import interfaces.IEqualsComparable;
   
   import mx.collections.ArrayCollection;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   
   import namespaces.client_internal;
   
   import utils.Objects;
   
   
   /**
    * 
    */
   public class HashingCollection extends ArrayCollection
   {
      /**
       * @param hashFunctions a list of hash functions to use. Each function must have a <b>unique</b> name.
       * <b>Not null. Not empty.</b>
       * @param sampleItem a non null instance that will be used as a sample item. Check
       * <code>sampleItem</code> property for more information. <b>Not null.</b>
       * @param source see <code>ArrayCollection.constructor()</code>
       * 
       * @see ArrayCollection#ArrayCollection()
       */
      public function HashingCollection(hashFunctions:Vector.<HashFunction>,
                                        sampleItem:*,
                                        source:Array = null)
      {
         super(source);
         Objects.paramNotNull("hashFunctions", hashFunctions);
         Objects.paramNotNull("sampleItem", sampleItem);
         if (hashFunctions.length == 0)
         {
            throw new ArgumentError("[param hashFunctions] must contain at least one item");
         }
         // no two functions with the same name are allowed
         var hashFunction:HashFunction;
         var len:int = hashFunctions.length;
         for (var i:int = 0; i < len; i++)
         {
            for (var j:int = i + 1; j < len; j++)
            {
               if (hashFunctions[i].name == hashFunctions[j].name)
               {
                  throw new ArgumentError("Each hash function requires a unique name. Duplicates found: " +
                                          getHashFunctionNames(hashFunctions).join(", "));
               }
            }
         }
         _sampleItem = sampleItem;
         _hashFunctions = new Object();
         for each (hashFunction in hashFunctions)
         {
            _hashFunctions[hashFunction.name] = hashFunction;
         }
         addEventListener(CollectionEvent.COLLECTION_CHANGE, this_collectionChangeHandler,
                          false, int.MAX_VALUE, true);
         
         // hash all items in the source array
         for each (var item:* in source)
         {
            for each (hashFunction in hashFunctions)
            {
               addItemToHash(hashFunction.name, item);
            }
         }
      }
      
      
      /**
       * Map of <code>HashFunction</code> instances. Each object is mapped to its unique name. 
       */
      private var _hashFunctions:Object;
      
      
      private var _sampleItem:*;
      /**
       * Sample instance of items in this collection which is used by all lookup methods. Follow these steps
       * if you want to use one of those methods:
       * <ol>
       *    <li>Set properties on a sample item. Keep in mind that different properties are used when 
       *        hashing by different hash functions.</li>
       *    <li>Invoke <code>getItem()</code> to obtain an item. You can also pass your own sample object to
       *        this methods as a second parameter. In that case the first step is not required.</li>
       * </ol>
       * This property is never <code>null</code>.
       */
      public function get sampleItem() : *
      {
         return _sampleItem;
      }
      
      
      /**
       * Returns an item which is mapped to a key that is retrieved calling a hash function passing
       * <code>sampleItem</code> as the first and only argument.
       * 
       * @param hashFunctionName name of a hash function to use for getting a key.
       * @param sampleItem an item with all properties (different for each distinct hash function) set that
       * will be used to build a key. If you don't pass this argument,
       * <code>HashingCollection.sampleItem</code> is used and you must set properties on that object before
       * calling this method in order to receive correct results.
       * 
       * @return an item mapped to key produced by the hash function or <code>null</code> if there is no
       * item mapped to that key.
       */
      public function getItem(hashFunctionName:String, sampleItem:* = null) : *
      {
         if (sampleItem == null)
         {
            sampleItem = this.sampleItem;
         }
         var hashFunction:HashFunction = _hashFunctions[hashFunctionName];
         if (hashFunction == null)
         {
            throw new ArgumentError("Hash function with name \"" + hashFunctionName + "\" not found.\n" +
                                    "Hash functions available:\n" +
                                    getHashFunctionNames(_hashFunctions).join(", "));
         }
         return hashFunction.client_internal::itemsHash[hashFunction.func.call(null, sampleItem)];
      }
      
      
      private function addItemToHash(hashFunctionName:String, item:*) : void
      {
         var hashFunction:HashFunction = _hashFunctions[hashFunctionName];
         hashFunction.client_internal::itemsHash[hashFunction.func.call(null, item)] = item;
      }
      
      
      private function removeItemFromHash(hashFunctionName:String, item:*) : void
      {
         
      }
      
      
      /* ########################### */
      /* ### SELF EVENT HANDLERS ### */
      /* ########################### */
      
      
      private function this_collectionChangeHandler(event:CollectionEvent) : void
      {
         with (CollectionEventKind)
         {
            switch (event.kind)
            {
               case ADD:
                  break;
               case MOVE:
                  break;
               case REMOVE:
                  break;
               case REPLACE:
                  break;
               case UPDATE:
                  break;
               case REFRESH:
                  break;
               case RESET:
                  break;
            }
         }
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function getHashFunctionNames(hashFunctions:Object) : Array
      {
         var names:Array = new Array();
         for each (var hashFunction:HashFunction in hashFunctions)
         {
            names.push(hashFunction.name);
         }
         return names;
      }
   }
}