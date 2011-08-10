package tests.utils.tests
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   import org.fluint.sequence.SequenceRunner;
   import org.hamcrest.assertThat;
   import org.hamcrest.core.throws;
   import org.hamcrest.object.equalTo;
   
   import utils.SyncUtil;

   public class TC_SyncUtil
   {
      include "../../asyncHelpers.as";
      include "../../asyncSequenceHelpers.as";
      
      
      [Before]
      public function setUp() : void
      {
         runner = new SequenceRunner(this);
      };
      
      
      [Test(description="checks if callLater() does not accept innaproriate parameter values")]
      public function callLater_badParams() : void
      {
         assertThat(
            function():void{ SyncUtil.callLater(null, 5) },
            throws (ArgumentError)
         );
      };
      
      
      [Test(async, timeout=200, description="checks if a function gets called after specified delay")]
      public function callAfter() : void
      {
         var functionCalled:Boolean = false;
         addDelay(100);
         addCall(function() : void { assertThat( functionCalled, equalTo (true) ); });
         SyncUtil.callLater(function() : void { functionCalled = true; }, 50);
         runner.run();
      };
      
      
      [Test(async, timeout=500, description="checks if two functions are called after specified delay if second has been added before the first has been called")]
      public function callAfter_twoFunctions() : void
      {
         var functionACalled:Boolean = false;
         var functionBCalled:Boolean = false;
         addDelay(100);
         addCall(function() : void { assertThat( functionACalled, equalTo (true) ); });
         addDelay(100);
         addCall(function() : void { assertThat( functionBCalled, equalTo (true) ); });
         SyncUtil.callLater(function() : void { functionACalled = true; },  50);
         SyncUtil.callLater(function() : void { functionBCalled = true; }, 150);
         runner.run();
      }
   }
}