package tests._old.utils
{
   import net.digitalprimates.fluint.tests.TestCase;
   
   import utils.NameResolver;

   public class NameResolverTest extends TestCase
   {
      private var names:Array = ["Alfa", "Beta", "Gama", "Theta", "Omega"];
      
      [Test]
      public function testNameSimple():void {
         assertEquals("It should resolve name if it falls into array range.",
         "Beta-1", NameResolver.resolve(names, 2));
      };

      [Test]
      public function testNameEdgeStartIter1():void {
         assertEquals("It should resolve name if it's on the edge of array range.",
            "Alfa-1", NameResolver.resolve(names, 1));
      };
      
      [Test]
      public function testNameEdgeStart():void {
         assertEquals("It should resolve name if it's on the edge of array range.",
            "Alfa-2", NameResolver.resolve(names, 6));
      };
      
      [Test]
      public function testNameEdgeEnd():void {
         assertEquals("It should resolve name if it's on the edge of array range.",
            "Omega-2", NameResolver.resolve(names, 10));
      };
      
      [Test]
      public function testNameComplex():void {
         assertEquals("It should resolve name if its greater than array range.",
            "Gama-2", NameResolver.resolve(names, 8));
      };
   }
}