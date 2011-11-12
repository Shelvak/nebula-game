/**
 * Created by IntelliJ IDEA.
 * User: MikisM
 * Date: 11.11.11
 * Time: 13.22
 * To change this template use File | Settings | File Templates.
 */
package models.map
{
   import models.planet.MPlanet;

   import utils.Objects;


   public class MMapPlanet extends MMap
   {
      public function MMapPlanet(planet:MPlanet) {
         super();
         _planet = Objects.paramNotNull("planet", planet);
      }

      private var _planet:MPlanet;
      public function get planet(): MPlanet {
         return _planet;
      }
   }
}
