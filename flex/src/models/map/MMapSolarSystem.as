package models.map
{
   import models.solarsystem.MSolarSystem;

   import utils.Objects;


   public class MMapSolarSystem extends MMapSpace
   {
      public function MMapSolarSystem(solarSystem:MSolarSystem) {
         Objects.paramNotNull("solarSystem", solarSystem);
         super();
      }
   }
}
