package tests.utils
{
   import mx.resources.ResourceBundle;
   
   import org.flexunit.asserts.assertEquals;

   import testsutils.LocalizerUtl;

   import utils.DateUtil;
   import utils.locale.Locale;
   import utils.locale.Localizer;
   
   
   public class TC_DateUtil
   {
      private var str: String;
      private var date: Date;
      
      [Before]
      public function setUp():void
      {
         LocalizerUtl.setUp();
         LocalizerUtl.addBundle("General", {
            'day.short': 'd',
            'hour.short': 'h',
            'minute.short': 'm',
            'second.short': 's'
         });
      }
      
      [Test]
      public function secondsToHumanStringTest() : void
      {
         assertEquals(
            "Should return calculated string",
            "1d 1h 1m 1s", DateUtil.secondsToHumanString(60 * 60 * 24 + 60 * 60 + 60 + 1)
         );
         assertEquals(
            "Should skip unneeded parts",
            "1d 1s", DateUtil.secondsToHumanString(60 * 60 * 24 + 1)
         );
      };
   }
}