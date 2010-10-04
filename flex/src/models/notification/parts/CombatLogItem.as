package models.notification.parts
{
   import mx.collections.ArrayCollection;
   
   [Bindable]
   public class CombatLogItem
   {
      public var property: String;
      public var yours: ArrayCollection;
      public var alliances: ArrayCollection;
      public var nap: ArrayCollection;
      public var enemies: ArrayCollection;
      
      public function CombatLogItem(prop: String, _yours: ArrayCollection, _ally: ArrayCollection, _nap: ArrayCollection,
                                    _enemy: ArrayCollection)
      {
         property = prop;
         yours = _yours;
         alliances = _ally;
         nap = _nap;
         enemies = _enemy;
      }
      
      public function getData(field: String): ArrayCollection
      {
         return this[field];
      }
   }
}