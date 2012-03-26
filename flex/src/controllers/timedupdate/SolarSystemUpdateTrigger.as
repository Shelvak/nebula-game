package controllers.timedupdate
{
   import interfaces.IUpdatable;

   import models.BaseModel;
   import models.ModelLocator;


   public class SolarSystemUpdateTrigger implements IUpdateTrigger
   {
      private function get solarSystem(): IUpdatable {
         return ModelLocator.getInstance().latestSSMap;
      }

      public function SolarSystemUpdateTrigger() {
      }

      public function update(): void {
         BaseModel.updateItem(solarSystem);
      }

      public function resetChangeFlags(): void {
         BaseModel.resetChangeFlagsOf(solarSystem);
      }
   }
}