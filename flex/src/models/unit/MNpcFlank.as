/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 4/5/12
 * Time: 2:35 PM
 * To change this template use File | Settings | File Templates.
 */
package models.unit {
   import models.factories.UnitFactory;

   import mx.collections.ArrayCollection;

   public class MNpcFlank {
      public function MNpcFlank(flankNr: int,  cachedUnits: Object) {
         flank = flankNr;
         units = UnitFactory.createCachedUnits(cachedUnits);
         var _count: int = 0;
         for each (var val: int in cachedUnits)
         {
            _count += val;
         }
         unitsCount = _count;
      }

      [Bindable]
      public var flank: int;

      [Bindable]
      public var unitsCount: int;

      [Bindable]
      public var units: ArrayCollection;
   }
}
