package tests.utils
{
   import mx.resources.ResourceBundle;
   
   import org.flexunit.asserts.assertEquals;
   
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
         var bundle: ResourceBundle = new ResourceBundle(Locale.EN, 'General');
         bundle.content['day.short'] = 'd';
         bundle.content['hour.short'] = 'h';
         bundle.content['minute.short'] = 'm';
         bundle.content['second.short'] = 's';
         Localizer.addBundle(bundle);
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