package models.cooldown
{
   import interfaces.IUpdatable;

   import models.BaseModel;
   import models.location.LocationMinimal;
   import models.map.IMStaticMapObject;
   import models.time.MTimeEventFixedMoment;

   import utils.ObjectStringBuilder;


   public class MCooldown extends BaseModel implements IMStaticMapObject, IUpdatable
   {
      public function MCooldown() {
         super();
      }

      [Required(alias="endsAt")]
      /**
       * Time when this cooldown ends.
       */
      public const endsEvent: MTimeEventFixedMoment = new MTimeEventFixedMoment();


      /* ################## */
      /* ### IUpdatable ### */
      /* ################## */

      public function update(): void {
         endsEvent.update();
         dispatchUpdateEvent();
      }

      public function resetChangeFlags(): void {
         endsEvent.resetChangeFlags();
      }


      /* ######################### */
      /* ### IMStaticMapObject ### */
      /* ######################### */


      private var _currentLocation: LocationMinimal;
      [Required(alias="location")]
      /**
       * Location of this cooldown in a space map.
       *
       * <p>Metadata:</br>
       * [Required(alias="location")]
       * </p>
       */
      public function set currentLocation(value: LocationMinimal): void {
         _currentLocation = value;
      }

      /**
       * @private
       */
      public function get currentLocation(): LocationMinimal {
         return _currentLocation;
      }

      public function get isNavigable(): Boolean {
         return false;
      }

      public function navigateTo(): void {
      }


      /* ######################## */
      /* ### STATE VALIDATION ### */
      /* ######################## */

      private function checkState_currentLocation(): void {
         if (_currentLocation == null) {
            throwIllegalStateError("[prop currentLocation] is null.");
         }
      }


      /* ########################### */
      /* ### BaseModel OVERRIDES ### */
      /* ########################### */

      public override function toString(): String {
         return new ObjectStringBuilder(this)
            .addProp("id")
            .addProp("currentLocation")
            .addProp("endsEvent").finish();
      }

      public override function equals(o: Object): Boolean {
         if (o == null || !(o is MCooldown)) {
            return false;
         }
         var cooldown: MCooldown = MCooldown(o);

         cooldown.checkState_currentLocation();
         checkState_currentLocation();

         return currentLocation.equals(cooldown.currentLocation);
      }
   }
}