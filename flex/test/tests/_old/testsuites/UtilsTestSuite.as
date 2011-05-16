package tests._old.testsuites
{
   import net.digitalprimates.fluint.tests.TestSuite;
   
   import tests._old.utils.*;
   import tests._old.utils.remote.rmo.RMOClassesTest;
   
   
   
   
   public class UtilsTestSuite extends TestSuite
   {
      public function UtilsTestSuite()
      {
         super ();
         
         addTestCase(new PropertiesTranformerTest());
         addTestCase(new TypeCheckerTest());
         addTestCase(new NameResolverTest());
         addTestCase(new ObjectsTest());
         addTestCase(new RMOClassesTest());
      }
   }
}