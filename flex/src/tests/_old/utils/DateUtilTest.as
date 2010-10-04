package tests._old.utils
{
   import net.digitalprimates.fluint.tests.TestCase;
   
   import utils.DateUtil;
   
   public class DateUtilTest extends TestCase
   {
      private var str: String;
      private var date: Date;
      
      [Test]
      public function secondsToHumanStringTest() : void
      {
         assertEquals ("Should return calculated string", "1d 1h 1m 1s", 
            DateUtil.secondsToHumanString(60 * 60 * 24 + 60 * 60 + 60 + 1));
         assertEquals ("Should skip unneeded parts", "1d 1s", 
            DateUtil.secondsToHumanString(60 * 60 * 24 + 1));
      };
      
      
      [Test]
      public function getLocalTime() : void
      {
         var serverTime:Date = null;
         
         serverTime = new Date(2010, 1, 1, 0, 0, 0);
         DateUtil.timeDiff = 0;
         assertEquals(
            "when timeDiff == 0, should return same time value",
            serverTime.time, DateUtil.getLocalTime(serverTime).time
         );
         
         DateUtil.timeDiff = 1000;
         assertEquals(
            "server time should be ahead by 1 second",
            serverTime.time - 1000, DateUtil.getLocalTime(serverTime).time
         );
         
         DateUtil.timeDiff = -1000;
         assertEquals(
            "local time should be ahead by 1 second",
            serverTime.time + 1000, DateUtil.getLocalTime(serverTime).time
         );
         
         DateUtil.timeDiff = 200;
         assertEquals(
            "local time should be floored to lower second and should be 1 second behind",
            serverTime.time - 1000, DateUtil.getLocalTime(serverTime).time
         );
         
         DateUtil.timeDiff = -200;
         assertEquals(
            "local time should be floored to lower second and should be equal to server time",
            serverTime.time, DateUtil.getLocalTime(serverTime).time
         );
      }
   }
}