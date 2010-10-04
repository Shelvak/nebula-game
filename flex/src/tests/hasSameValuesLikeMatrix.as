package tests
{
   import org.hamcrest.Matcher;
   import org.hamcrest.object.equalTo;
   
   import tests.MatrixEqualsMatcher;
   

   public function hasSameValuesLikeMatrix(value:Object):Matcher
   {
      return new MatrixEqualsMatcher(value as Array);
   }
}