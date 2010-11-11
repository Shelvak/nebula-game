package utils.datastructures
{
   import flash.utils.Dictionary;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.collections.SortField;
   
   import utils.random.Rndm;

   /**
    * Hash with predicatable iteration order.
    * 
    * @author Jonas 'Jho' Abromaitis <jonas@nebula44.com>
    * @author Artūras 'arturaz' Šlajus <x11@arturaz.net>
    */   
   dynamic public class Hash extends Proxy
   {
      private var keys: ArrayCollection = new ArrayCollection();
      private var keysSorted: Boolean = false;
      private var data: Object = new Object();
      
      public function Hash()
      {
         super();
      }
      
      public function removeKey(key: String): void
      {
         data[key] = null;
         keys.removeItemAt(keys.getItemIndex(key));
      }
      
      override flash_proxy function getProperty(key:*): * {
         return getValue(key);
      }
      
      override flash_proxy function setProperty(key:*, value:*): void {
         if (value == null) {
            removeKey(key);
         }
         else {
            setValue(key, value);
         }
      }
      
      override flash_proxy function nextNameIndex (index:int):int {         
         if (index < keys.length) {
            return index + 1;
         }
         else {
            return 0;
         }
      }
      
      override flash_proxy function nextName(index:int):String {
         ensureKeyOrder();
         return keys[index - 1];
      }
      
      override flash_proxy function nextValue(index:int):* {
         ensureKeyOrder();
         return data[keys[index - 1]];
      }
      
      public function set sortField(value: SortField): void
      {
         _sortField = value;
         keysSorted = false;
      }
      
      private var _sortField: SortField = new SortField();
      
      private function ensureKeyOrder():void {
         if (! keysSorted) {
            keys.sort = new Sort();
            keys.sort.fields = [_sortField];
            keys.refresh();
            
            keysSorted = true;
         }
      }
      
      public function removeValue(value: *): void
      {
         for each (var key: String in keys)
         {
            if (data[key] == value)
            {
               removeKey(key);
            }
         }
      }
      
      public function setValue(key: String, value:*): void
      {
         data[key] = value;
         keys.addItem(key);
         keysSorted = false;
      }
      
      public function getValue(key: String): *
      {
         return data[key];
      }
      
      public function getRandomKey(rnd: Rndm): String
      {
         var index: int = rnd.integer(0, keys.length-1);
         return (keys.getItemAt(index) as String);
      }
      
      public function getRandomValue(rnd: Rndm): *
      {
         return data[getRandomKey(rnd)];
      }
   }
}