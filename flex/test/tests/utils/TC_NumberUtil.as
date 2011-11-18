package tests.utils
{
   import org.hamcrest.assertThat;
   import org.hamcrest.object.equalTo;
   
   import utils.NumberUtil;
   
   public class TC_NumberUtil
   {
      
      [Before]
      public function setUp() : void
      {
      };
      
      [Test]
      public function testToShortStringSimple() : void
      {
         assertThat(NumberUtil.toShortString(10), equalTo("10"));
         assertThat(NumberUtil.toShortString(1000), equalTo("1k"));
         assertThat(NumberUtil.toShortString(1000000), equalTo("1m"));
         assertThat(NumberUtil.toShortString(1000000000), equalTo("1g"));
      }
      
      [Test]
      public function testToShortStringWithRounding() : void
      {
         assertThat(NumberUtil.toShortString(10.55), equalTo("10.6"));
         assertThat(NumberUtil.toShortString(1550), equalTo("1.6k"));
         assertThat(NumberUtil.toShortString(1550000), equalTo("1.6m"));
         assertThat(NumberUtil.toShortString(1550000000), equalTo("1.6g"));
      }
      
      [Test]
      public function testToShortStringWithRoundingPrecision() : void
      {
         assertThat(NumberUtil.toShortString(10.552, 2), equalTo("10.55"));
         assertThat(NumberUtil.toShortString(1552, 2), equalTo("1.55k"));
         assertThat(NumberUtil.toShortString(1552000, 2), equalTo("1.55m"));
         assertThat(NumberUtil.toShortString(1552000000, 2), equalTo("1.55g"));
      }
      
      [Test]
      public function testToShortStringNegative() : void
      {
         assertThat(NumberUtil.toShortString(-10.552, 2), equalTo("-10.55"));
         assertThat(NumberUtil.toShortString(-1552, 2), equalTo("-1.55k"));
         assertThat(NumberUtil.toShortString(-1552000, 2), equalTo("-1.55m"));
         assertThat(NumberUtil.toShortString(-1552000000, 2), equalTo("-1.55g"));
      }
   }
}