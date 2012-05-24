package controllers.planets.actions
{
   import interfaces.IEqualsComparable;

   import utils.ObjectStringBuilder;

   import utils.Objects;


   /**
    * Aggregates parameters of <code>controllers.planets.actions.BgSpawnAction</code> client command.
    *
    * @see BgSpawnActionParams()
    * @see #planetId
    */
   public class BgSpawnActionParams implements IEqualsComparable
   {
      /**
       * See documentation of corresponding variables for information about parameters.
       *
       * @see #planetId
       */
      public function BgSpawnActionParams(planetId: int) {
         this.planetId = Objects.paramIsId("planetId", planetId);
      }

      /**
       * Id of a battleground or pulsar planet to spawn boss to | <b> &gt; 0 </b>
       */
      public var planetId: int = 0;

      public function equals(o: Object): Boolean {
         const another: BgSpawnActionParams = o as BgSpawnActionParams;
         return another != null && another.planetId == this.planetId;
      }

      public function toString(): String {
         return new ObjectStringBuilder(this)
            .addProp("planetId").finish();
      }
   }
}
