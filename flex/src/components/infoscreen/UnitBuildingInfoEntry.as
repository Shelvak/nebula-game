package components.infoscreen
{
   import models.unit.UnitBuildingEntry;
   
   public class UnitBuildingInfoEntry extends UnitBuildingEntry
   {
      public var title: String;
      public var dmg: int;
      public var techMod: Number;
      public var dmgType: String;
      public var armorType: String;
      
      public function UnitBuildingInfoEntry(type:String, _title: String, _dmg: Number = 0, _dmgType: String = null, _armorType: String = null, _techMod: Number = 0)
      {
         title = _title;
         dmg = _dmg;
         if (_dmgType != null)
         {
            techMod = _techMod;
            dmgType = _dmgType;
            armorType = _armorType;
         }
         super(type);
      }
   }
}