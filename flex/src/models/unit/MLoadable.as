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

   import utils.locale.Localizer;

   public class MLoadable extends EventDispatcher {
      public function MLoadable() {
         super();
      }

      public static const PLANET_STORAGE: int = -1;

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

      [Bindable (event="loadableCountChange")]
      public function get toolTip(): String
      {
         return enabled
            ? ""
            : (count > 0
               ? Localizer.string('Units', 'tooltip.autoLoadWontFit')
               : ""
            );
      }

      protected function dispatchCountChangeEvent(): void
      {
         if (hasEventListener(UnitEvent.LOADABLE_COUNT_CHANGE))
         {
            dispatchEvent(new UnitEvent(UnitEvent.LOADABLE_COUNT_CHANGE));
         }
      }

      protected var maxVolume: int;

      public function setMaxVolume(value: int): void
      {
         maxVolume = value;
         dispatchCountChangeEvent();
      }
   }
}
