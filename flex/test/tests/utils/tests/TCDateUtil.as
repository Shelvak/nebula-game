package tests.utils.tests
{
   import org.flexunit.asserts.assertEquals;
   
   import utils.DateUtil;
   
   
   public class TCDateUtil
   {
      private var str: String;
      private var date: Date;
      
      
      [Ignore("Does not work")]
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