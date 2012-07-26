package controllers.units
{
   import models.location.LocationMinimal;
   import models.unit.Unit;

   import mx.collections.IList;

   import utils.Objects;


   /**
    * This class is a part of duplicating units bug fix.
    *
    * Here is the they might duplicate:
    * <ul>
    *    <li>Just before jump (~500ms) client removes squadron and units
    *        completely.</li>
    *    <li>The server then sends objects|updated with those units because of
    *        the combat or resources transfer (in case of mules).</li>
    *    <li>In both cases, client creates those units and adds them to global
    *        units lists.</li>
    *    <li>Now server sends units|movement with the same units. Client thinks
    *        that those units are not present since it recently removed them
    *        and creates squadron <b>AND</b> those units again.</li>
    *    <li>The list of units in that squad is refreshed and also catches all
    *        the units that were updated and created after objects|updated
    *        message. The result - we have a squad with duplicated units.</li>
    * </ul>
    *
    * To fix this rarely seen issue we do this:
    * <ul>
    *    <li>Jus before removing units because of a jump, client adds hash items
    *        to this class where the key is unit ID and value is a the following
    *        string representation of a unit location just before the jump:
    *        "[type],[id],[x],[y]"</li>
    *    <li>Now when objects|updated is received with units, for each space
    *        unit we check its location. If that location matches the one in
    *        the hash, we do not create or update that unit.
    *    </li>
    * </ul>
    *
    * As for objects|destroyed (server might send this after the combat also)
    * we have to ignore IDs of units not present in the client as there is
    * no way to check if they were removed because of immediate jump or
    * because of some failure.
    */
   public final class UnitJumps
   {
      private static const _hash: Object = new Object();

      public static function buildLocationString(
         type: int, id: int, x: int, y: int): String
      {
         return type + "," + id + "," + x + "," + y;
      }

      public static function setPreJumpLocations(
         units: IList, location: LocationMinimal): void
      {
         Objects.paramNotNull("location", location);
         if (units == null) {
            return;
         }
         for each (var unit: Unit in units.toArray()) {
            setPreJumpLocation(
               unit.id,
               buildLocationString(
                  location.type, location.id, location.x, location.y
               )
            );
         }
      }

      public static function setPreJumpLocation(unitId: int, location: String): void {
         Objects.paramIsId("unitId", unitId);
         Objects.paramNotEmpty("location", location);
         _hash[unitId] = location;
      }

      public static function preJumpLocationMatches(unitId: int, location: String): Boolean {
         Objects.paramIsId("unitId", unitId);
         Objects.paramNotEmpty("location", location);
         return _hash[unitId] == location;
      }
   }
}
