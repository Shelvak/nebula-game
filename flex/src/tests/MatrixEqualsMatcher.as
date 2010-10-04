package tests
{
   
   import org.hamcrest.Description;
   import org.hamcrest.Matcher;
   
   public class MatrixEqualsMatcher implements Matcher
   {

      private var expectedMatrix: Array;
      
      private var gotMatrix: Array;
      
      public function MatrixEqualsMatcher(expected: Array)
      {
         expectedMatrix = expected;
      }
      
      public function matches(item:Object):Boolean
      {
         if (item is Array)
         {
           gotMatrix = item as Array; 
            if (gotMatrix.length == expectedMatrix.length) 
            {
               for (var i: int = 0; i < gotMatrix.length; i++)
                  for (var j: int = 0; j < (gotMatrix[i] as Array).length; j++)
                     if (expectedMatrix[i][j] != gotMatrix[i][j])
                     {
                        return false;
                     }
            }
            else {
               return false;
            }
         }
         else {
            return false;
         }   
         return true;
      }
      
      public function describeMismatch(item:Object, mismatchDescription:Description):void
      {
         var expectedText: String = '';
         for (var i: int = 0; i<expectedMatrix.length;i++)
         {
            for (var j: int = 0; j<(expectedMatrix[i] as Array).length;j++)
            {
               expectedText += expectedMatrix[i][j] + ',';
            }
            expectedText += '\n';
         }
         
         var gotText: String = '';
         for (i = 0; i<gotMatrix.length;i++)
         {
            for (j = 0; j<(gotMatrix[i] as Array).length;j++)
            {
               gotText += gotMatrix[i][j] + ',';
            }
            gotText += '\n';
         }
         
         mismatchDescription.appendText('Matrix matching failed, expected: \n' + expectedText +
         'was:\n' + gotText);
      }
      
      public function describeTo(description:Description):void
      {
      }
   }
}