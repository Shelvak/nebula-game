package models.infoscreen
{
   import config.Config;
   
   import models.BaseModel;
   import models.building.Building;
   import models.technology.Technology;
   import models.unit.Unit;
   
   import mx.core.BitmapAsset;
   
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   [Bindable]
   public class InfoObject extends BaseModel
   {
      
      public var name: String;
      
      public var imageSource: *;
      
      public var description: String;
      
      public var currentLevel: int;
      
      // Level value that is used in GUI components.
      public var usefulLevel: int;
      
      public var maxLevel: int;
      
      public var infoData: Object;
      
      public var type: String;
      
      public var objectType: String;
      
      public var armorType: String;
      
      
      public function InfoObject(target: *)
      {
         var img:ImagePreloader = ImagePreloader.getInstance();
         
         if (target is Building)
         {
            objectType = 'building';
            var TBuilding: Building = (target as Building);
            type = TBuilding.type;
            name = TBuilding.name;
            imageSource = new BitmapAsset(img.getImage(AssetNames.getBuildingImageName(TBuilding.type)));
            description = TBuilding.description;
            currentLevel = TBuilding.upgradePart.level;
            usefulLevel = currentLevel > 1 ? currentLevel : 1;
            maxLevel = Config.getBuildingMaxLevel(TBuilding.type);
            infoData = TBuilding.getInfoData();
            armorType = ArmorTypes.FORTIFIED;
         }
         if (target is Technology)
         {
            objectType = 'technology';
            var tTechnology: Technology = (target as Technology);
            type = tTechnology.type;
            name = tTechnology.title;
            imageSource = new BitmapAsset(img.getImage(AssetNames.getTechnologyImageName(tTechnology.type)));
            description = tTechnology.description;
            currentLevel = tTechnology.upgradePart.level;
            usefulLevel = currentLevel > 1 ? currentLevel : 1;
            maxLevel = tTechnology.maxLevel;
            infoData = tTechnology.getInfoData();
            armorType = null;
         }
         if (target is Unit)
         {
            objectType = 'unit';
            var tUnit: Unit = (target as Unit);
            type = tUnit.type;
            name = tUnit.title;
            imageSource = new BitmapAsset(img.getImage(AssetNames.getUnitImageName(tUnit.type)));
            description = tUnit.description;
            currentLevel = tUnit.upgradePart.level;
            usefulLevel = currentLevel > 1 ? currentLevel : 1;
            maxLevel = tUnit.maxLevel;
            infoData = tUnit.getInfoData();
            armorType = infoData.armor;
         }
      }
   }
}