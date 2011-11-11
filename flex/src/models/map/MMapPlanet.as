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
         Objects.paramNotNull("planet", planet);
         super();
      }
   }
}
