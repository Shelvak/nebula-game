package models.resource
{
   import models.ModelLocator;
   import models.solarsystem.SSObject;
   import models.technology.TechnologiesModel;

   public class ResourcesMods
   {
      private var _energyStorage: Number = 0;
      private var _energyRate: Number = 0;
      private var _metalStorage: Number = 0;
      private var _metalRate: Number = 0;
      private var _zetiumStorage: Number = 0;
      private var _zetiumRate: Number = 0;
      
      // Getters
      
      public function getRateMod(type: String): Number
      {
         switch (type)
         {
            case ResourceType.METAL:
               return _metalRate;
            case ResourceType.ENERGY:
               return _energyRate;
            case ResourceType.ZETIUM:
               return _zetiumRate;
         }
         return 1;
      }
      
      public function getStorageMod(type: String): Number
      {
         switch (type)
         {
            case ResourceType.METAL:
               return _metalStorage;
            case ResourceType.ENERGY:
               return _energyStorage;
            case ResourceType.ZETIUM:
               return _zetiumStorage;
         }
         return 1;
      }
      
      public function recalculateMods(): void
      {
         var ML: ModelLocator = ModelLocator.getInstance();
         var techs: TechnologiesModel = ML.technologies;
         _energyStorage = 1 + techs.getTechnologiesPropertyMod(ModType.ENERGY_STORE)/100;
         _energyRate = 1 + techs.getTechnologiesPropertyMod(ModType.ENERGY_GENERATE)/100;
         _metalStorage = 1 + techs.getTechnologiesPropertyMod(ModType.METAL_STORE)/100;
         _metalRate = 1 + techs.getTechnologiesPropertyMod(ModType.METAL_GENERATE)/100;
         _zetiumStorage = 1 + techs.getTechnologiesPropertyMod(ModType.ZETIUM_STORE)/100;
         _zetiumRate = 1 + techs.getTechnologiesPropertyMod(ModType.ZETIUM_GENERATE)/100;
         var planet:SSObject = ML.latestPlanet.ssObject;
         planet.metal.renewAllInfoDueToModsChange();
         planet.energy.renewAllInfoDueToModsChange();
         planet.zetium.renewAllInfoDueToModsChange();
      }
   }
}