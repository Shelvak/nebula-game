package controllers.planets.actions
{
   import interfaces.IEqualsComparable;

   import utils.ObjectStringBuilder;

   import utils.Objects;


   /**
    * Aggregates parameters of <code>controllers.planets.actions.ReinitiateCombatAction</code>
    * client command.
    *
    * @see #ReinitiateCombatActionParams()
    * @see #planetId
    */
   public class ReinitiateCombatActionParams implements IEqualsComparable
   {
      /**
       * See documentation of corresponding variables for information about parameters.
       *
       * @see #planetId
       */
      public function ReinitiateCombatActionParams(planetId: int) {
         this.planetId = Objects.paramIsId("planetId", planetId);
      }

      /**
       * Id of the planet to reinitiate combat in.
       * <p><b>Required. Greater than 0.</b></p>
       */
      public var planetId: int;

      public function toString(): String {
         return new ObjectStringBuilder(this).addProp("planetId").finish();
      }

      public function equals(o: Object): Boolean {
         const another: ReinitiateCombatActionParams = o as ReinitiateCombatActionParams;
         return another != null && another.planetId == this.planetId;
      }
   }
}
