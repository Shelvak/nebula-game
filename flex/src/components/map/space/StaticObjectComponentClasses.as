package components.map.space
{
   public class StaticObjectComponentClasses
   {
      private var data:Object = new Object();
      
      
      public function addComponents(type:int, mapObjectClass:Class, infoClass:Class) : void
      {
         data[type] = new InfoAndMapObject(infoClass, mapObjectClass);
      }
      
      
      public function getMapObjectClass(type:int) : Class
      {
         return getHolder(type).mapObjectClass;
      }
      
      
      public function getInfoClass(type:int) : Class
      {
         return getHolder(type).infoClass;
      }
      
      
      private function getHolder(type:int) : InfoAndMapObject
      {
         return data[type];
      }
   }
}


class InfoAndMapObject
{
   public function InfoAndMapObject(infoClass:Class, mapObjectClass:Class)
   {
      super();
      this.infoClass = infoClass;
      this.mapObjectClass = mapObjectClass;
   }
   public var infoClass:Class;
   public var mapObjectClass:Class;
}