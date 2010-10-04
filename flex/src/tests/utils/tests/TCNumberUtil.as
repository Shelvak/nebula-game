package tests.utils.tests
{
   import org.hamcrest.assertThat;
   import org.hamcrest.core.throws;
   import org.hamcrest.object.equalTo;
   
   import utils.NumberUtil;

   public class TCNumberUtil
   {		
      [Test]
      public function addLeadingZeros() : void
      {
         // should not accespt negative numbers
         assertThat( function():void{ NumberUtil.addLeadingZeros(-1, 2) }, throws (ArgumentError) );
         assertThat( function():void{ NumberUtil.addLeadingZeros(-5, 2) }, throws (ArgumentError) );
         
         // shoud not accept negative number of symbols
         assertThat( function():void{ NumberUtil.addLeadingZeros(5, -1) }, throws (ArgumentError) );
         assertThat( function():void{ NumberUtil.addLeadingZeros(5, -5) }, throws (ArgumentError) );
         
         // should return number itself as a string if number symbols is less than or equal
         // to number of digits
         assertThat( NumberUtil.addLeadingZeros(152, 1), equalTo ("152") );
         assertThat( NumberUtil.addLeadingZeros(152, 2), equalTo ("152") );
         assertThat( NumberUtil.addLeadingZeros(152, 3), equalTo ("152") );
         
         // A few examples
         assertThat( NumberUtil.addLeadingZeros(1, 5), equalTo ("00001") );
         assertThat( NumberUtil.addLeadingZeros(11, 5), equalTo ("00011") );
         assertThat( NumberUtil.addLeadingZeros(111, 6), equalTo ("000111") );
         assertThat( NumberUtil.addLeadingZeros(1111, 6), equalTo ("001111") );
      }
   }
}