/**
 * Created with IntelliJ IDEA.
 * User: arturas
 * Date: 8/27/12
 * Time: 4:28 PM
 * To change this template use File | Settings | File Templates.
 */
package controllers.startup {
   import flash.external.ExternalInterface;

   import models.ModelLocator;
   import models.galaxy.Galaxy;

   public class JavascriptController {
      public static function registerCallbacks(): void {
         ExternalInterface.addCallback("getGalaxyId", getGalaxyId);
      }

      /**
       * @return 0 if galaxy is not yet initialized, galaxy id otherwise.
       */
      public static function getGalaxyId(): uint {
         var galaxy: Galaxy = ModelLocator.getInstance().latestGalaxy;
         return galaxy == null ? 0 : galaxy.id;
      }
   }
}
