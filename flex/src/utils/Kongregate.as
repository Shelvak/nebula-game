/**
 * Created with IntelliJ IDEA.
 * User: arturas
 * Date: 10/2/12
 * Time: 12:14 PM
 * To change this template use File | Settings | File Templates.
 */
package utils {
   import flash.external.ExternalInterface;

   public class Kongregate {

      public static function isKongregate(): Boolean {
         return ExternalInterface.call('isKongregateUser');
      }

      public static function openBuyPopup(): void {
         ExternalInterface.call('openKongregateBuyPopup');
      }
   }
}
