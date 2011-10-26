package components.map.space
{
   import flash.utils.Dictionary;
   
   import mx.utils.ObjectUtil;

   public class StaticObjectComponentClasses
   {
      private const _hash:Dictionary = new Dictionary();
      
      public function addComponents(type:int, mapObjectClass:Class, infoClass:Class) : void {
         _hash[type] = new InfoAndMapObject(type, infoClass, mapObjectClass);
      }
      
      public function getMapObjectClass(type:int) : Class {
         return getHolder(type).mapObjectClass;
      }
      
      public function getInfoClass(type:int) : Class {
         return getHolder(type).infoClass;
      }
      
      public function getAllObjectTypes() : Array {
         return getAllEntries().map(
            function(entry:InfoAndMapObject, idx:int, array:Array) : int {
               return entry.objectType;
            }
         )
      }
      
      private function getHolder(type:int) : InfoAndMapObject {
         return _hash[type];
      }
      
      private function getAllEntries() : Array {
         var entries:Array = new Array();
         for each (var entry:InfoAndMapObject in _hash) {
            entries.push(entry);
         }
         return entries.sort(
            function(a:InfoAndMapObject, b:InfoAndMapObject) : int {
               return ObjectUtil.numericCompare(a.objectType, b.objectType);
            }
         );
      }
   }
}


class InfoAndMapObject
{
   public function InfoAndMapObject(objectType:int, infoClass:Class, mapObjectClass:Class)
   {
      super();
      this.objectType = objectType;
      this.infoClass = infoClass;
      this.mapObjectClass = mapObjectClass;
   }
   public var objectType:int;
   public var infoClass:Class;
   public var mapObjectClass:Class;
}