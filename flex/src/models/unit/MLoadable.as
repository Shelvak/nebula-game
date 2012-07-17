/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 6/28/12
 * Time: 1:23 PM
 * To change this template use File | Settings | File Templates.
 */
package models.unit {
   import flash.display.BitmapData;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;

   import models.unit.events.UnitEvent;

   public class MLoadable extends EventDispatcher {
      public function MLoadable() {
      }

      public function set count(value: int): void
      {
         _count = value;
         dispatchCountChangeEvent();
      }

      [Bindable (event="loadableCountChange")]
      public function get count(): int
      {
         return _count;
      }

      private var _count: int;

      [Bindable (event="loadableCountChange")]
      public function get label(): String
      {
         return count.toString();
      }

      protected function get AL(): MCAutoLoad
      {
         return MCAutoLoad.getInstance();
      }

      [Bindable (event="loadableCountChange")]
      public function get enabled(): Boolean
      {
         return count > 0;
      }

      public function clickHandler(e: MouseEvent): void
      {
         throw new Error("This method is abstract!");
      }

      public function get image(): BitmapData
      {
         throw new Error("This method is abstract!");
      }

      public function get sidePadding(): int
      {
         return 0;
      }

      private function dispatchCountChangeEvent(): void
      {
         if (hasEventListener(UnitEvent.LOADABLE_COUNT_CHANGE))
         {
            dispatchEvent(new UnitEvent(UnitEvent.LOADABLE_COUNT_CHANGE));
         }
      }
   }
}
