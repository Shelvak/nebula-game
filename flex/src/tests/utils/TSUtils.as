package tests.utils
{
   import tests.utils.tests.TCLocalizer;
   import tests.utils.tests.TCNumberUtil;
   import tests.utils.tests.TCSyncUtil;

   [Suite]
   [RunWith("org.flexunit.runners.Suite")]
   public class TSUtils
   {
      public var tcNumberUtil:TCNumberUtil;
      public var tcSyncUtil:TCSyncUtil;
      public var tcLocalizer: TCLocalizer;
   }
}