package tests.utils
{
   import tests.utils.tests.*;
   
   
   [Suite]
   [RunWith("org.flexunit.runners.Suite")]
   public class TS_Utils
   {
      public var tc_StringUtil:TC_StringUtil;
      public var tc_DateUtil:TC_DateUtil;
      public var tc_SyncUtil:TC_SyncUtil;
      public var tc_Localizer:TC_Localizer;
      public var tc_NumberUtil:TC_NumberUtil;
      public var tc_ModelUtil:TC_ModelUtil;
   }
}