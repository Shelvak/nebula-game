package tests._old.testsuits
{
   import net.digitalprimates.fluint.tests.TestSuite;
   
   import tests._old.models.*;
   
   
   
   
   public class ModelsTestSuite extends TestSuite
   {
      public function ModelsTestSuite()
      {
         super ();
         addTestCase(new BaseModelTest());
         addTestCase(new BuildingTest());
         addTestCase(new BuildingBonusesTest());
         addTestCase(new ZIndexCalculatorTest());
      }
   }
}