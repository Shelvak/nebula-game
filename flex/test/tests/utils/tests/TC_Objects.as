package tests.utils.tests
{
   import ext.hamcrest.object.equals;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.isTrue;
   
   import utils.Objects;

   
   public class TC_Objects
   {
      [Test]
      public function extractPropsWithPrefix() : void {
         var result:Object = Objects.extractPropsWithPrefix("prefix", {
            "one": 1,
            "two": 2,
            "prefixOneOne": 11,
            "prefixTwoTwo": 22
         });
         assertThat( "[prop one] not extracted", result["one"] === undefined, isTrue() );
         assertThat( "[prop two] not extracted", result["two"] === undefined, isTrue() );
         assertThat( "[prop prefixOneOne] extracted", result["oneOne"], equals (11) );
         assertThat( "[prop prefixTwoTwo] extracted", result["twoTwo"], equals (22) );
      }
      
      [Test]
      public function extractPropsWithPrefixLeavesOutPropsWithTheSameNameAsPrefix () : void {
         var result:Object = Objects.extractPropsWithPrefix("prefix", {"prefix": 0});
         assertThat( "[prop prefix] not extracted", result["prefix"] === undefined, isTrue() );
         assertThat( "prop with no name not created", result[""] === undefined, isTrue() );
      }
   }
}