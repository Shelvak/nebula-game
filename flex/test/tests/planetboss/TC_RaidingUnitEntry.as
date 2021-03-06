package tests.planetboss
{
   import ext.hamcrest.object.equals;

   import models.unit.RaidingUnitEntry;

   import org.hamcrest.assertThat;
   import org.hamcrest.core.not;
   import org.hamcrest.core.throws;
   import org.hamcrest.object.notNullValue;


   public class TC_RaidingUnitEntry
   {
      [Test]
      public function testToString(): void {
         assertThat(
            entry("Trooper", 1, 5, 0.5).toString(),
            equals ('[class: models.unit::RaidingUnitEntry, type: "Trooper", countFrom: 1, countTo: 5, prob: 0.5]')
         );
      }

      [Test]
      public function testEquals(): void {
         const sample: RaidingUnitEntry = entry("Trooper", 1, 5, 1);
         assertThat( "not equals to null", sample, notNullValue() );
         assertThat( "not equals to object of another type", sample, not (equals (new Object())) );
         assertThat(
            "not equals if properties are not equal",
            sample, not (equals (entry("Gnat", 1, 5, 0.1))) );
         assertThat(
            "equals if all properties are the same",
            sample, equals (entry("Trooper", 1, 5, 1))
         );
      }

      [Test]
      public function add(): void {
         assertThat(
            "should throw error if adding entries of different types of units",
            function(): void { entry("Trooper", 1, 5, 1) .add (entry("Gnat", 1, 5, 1)) },
            throws (Error)
         );
         assertThat(
            "should throw error if adding entries with different probabilities",
            function(): void { entry("Trooper", 1, 5, 1) .add (entry("Gnat", 1, 5, 0.5)) },
            throws (Error)
         );

         assertThat(
            "should add from and to values",
            entry("Trooper", 1, 5, 1) .add (entry("Trooper", 1, 5, 1)),
            equals (entry("Trooper", 2, 10, 1))
         );
      }

      private function entry(type: String, from: int, to: int, prob: Number): RaidingUnitEntry {
         return new RaidingUnitEntry(type, from, to, prob);
      }
   }
}
