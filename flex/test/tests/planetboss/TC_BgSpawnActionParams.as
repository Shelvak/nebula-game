package tests.planetboss
{
   import controllers.planets.actions.BgSpawnActionParams;

   import ext.hamcrest.object.equals;

   import org.hamcrest.assertThat;
   import org.hamcrest.core.not;
   import org.hamcrest.object.notNullValue;


   public class TC_BgSpawnActionParams
   {
      [Test]
      public function testEquals(): void {
         assertThat( "not equals to null", params(1), notNullValue() );
         assertThat( "not equals to object of other type", params(1), not (equals (new Object())) );
         assertThat( "not equals when ids are different", params(1), not (equals (params (2))) );
         assertThat( "equals when ids are the same", params(1), equals (params (1)) );
      }

      [Test]
      public function testToString(): void {
         assertThat(
            params(1).toString(),
            equals ("[class: controllers.planets.actions::BgSpawnActionParams, planetId: 1]")
         );
      }

      private function params(planetId: int): BgSpawnActionParams {
         return new BgSpawnActionParams(planetId);
      }
   }
}
