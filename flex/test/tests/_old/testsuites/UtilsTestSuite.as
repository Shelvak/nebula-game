package tests._old.testsuites
{
   import tests._old.utils.*;
   import tests._old.utils.remote.rmo.RMOClassesTest;
   
   
   [Suite]
   [RunWith("org.flexunit.runners.Suite")]
   public class UtilsTestSuite
   {
         public var propertiesTransformerTest:PropertiesTranformerTest;
         public var typeCheckerTest:TypeCheckerTest;
         public var nameResolverTest:NameResolverTest;
         public var objectsTest:ObjectsTest;
         public var rmoClassesTest:RMOClassesTest;
   }
}