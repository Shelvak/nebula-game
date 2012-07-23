package models.galaxy
{
   import flash.display.BitmapData;
   
   import interfaces.IEqualsComparable;
   
   import utils.Objects;
   import utils.locale.Localizer;

   
   public class MRenderedObjectType implements IEqualsComparable
   {
      private var _entireGalaxy: IMEntireGalaxy;
      
      public function MRenderedObjectType(entireGalaxy: IMEntireGalaxy) {
         _entireGalaxy = Objects.paramNotNull("entireGalaxy", entireGalaxy);
      }

      public function get entireGalaxy(): IMEntireGalaxy {
         return _entireGalaxy;
      }

      private var _rendered: Boolean = true;
      [Bindable]
      public function set rendered(value: Boolean): void {
         if (_rendered != value) {
            _rendered = value;
            _entireGalaxy.rerender();
         }
      }
      public function get rendered(): Boolean {
         return _rendered;
      }
      
      public function get legendText(): String {
         Objects.throwAbstractPropertyError();
         return null;
      }
      
      public function get legendImage(): BitmapData {
         Objects.throwAbstractPropertyError();
         return null;
      }
      
      public function equals(o: Object): Boolean {
         Objects.throwAbstractMethodError();
         return false;
      }
      
      protected function getString(property: String): String {
         return Localizer.string("EntireGalaxy", property);
      }
   }
}