/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 6/28/12
 * Time: 1:23 PM
 * To change this template use File | Settings | File Templates.
 */
package models.unit {
   import flash.display.BitmapData;
   import flash.events.MouseEvent;

   public class MLoadable {
      public function MLoadable() {
      }

      [Bindable]
      public var count: int;

      public function get label(): String
      {
         return count.toString();
      }

      public function clickHandler(e: MouseEvent): void
      {
         throw new Error("This method is abstract!");
      }

      public function get image(): BitmapData
      {
         throw new Error("This method is abstract!");
      }
   }
}
