package tests.utils.tests
{
   import ext.hamcrest.object.equals;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.isTrue;
   
   import utils.Objects;

   
   public class TC_Objects
   {
      [Test]
      public function extractProps() : void {
         var result:Object = Objects.extractProps(["one", "two", "nonExisting"], {
            "one": 1,
            "two": 2,
            "three": 3,
            "four": 4
         });
         assertThat( "[prop three] not extracted", result["three"] === undefined, isTrue() );
         assertThat( "[prop four] not extracted", result["four"] === undefined, isTrue() );
         assertThat( "[prop nonExisting] not created", result["nonExisting"] === undefined, isTrue() );
         assertThat( "[prop one] extracted", result["one"], equals (1) );
         assertThat( "[prop two] extracted", result["two"], equals (2) );
      }
      
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