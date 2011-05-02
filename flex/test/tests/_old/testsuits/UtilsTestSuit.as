package tests._old.testsuits
{
   import net.digitalprimates.fluint.tests.TestSuite;
   
   import tests._old.utils.*;
   import tests._old.utils.remote.rmo.RMOClassesTest;
   
   
   
   
   public class UtilsTestSuit extends TestSuite
   {
      public function UtilsTestSuit()
      {
         super ();
         
         addTestCase(new PropertiesTranformerTest());
         addTestCase(new TypeCheckerTest());
         addTestCase(new NameResolverTest());
         addTestCase(new DateUtilTest());
         addTestCase(new StringUtilTest());
         addTestCase(new ObjectsTest());
         addTestCase(new RMOClassesTest());
      }
   }
}