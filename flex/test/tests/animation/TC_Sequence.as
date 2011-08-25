package tests.animation
{
   import animation.Sequence;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.equalTo;
   
   
   public class TC_Sequence
   {
      // Reference declaration for class to test
      private var seq:Sequence;
      
      
      [Test(description="[param finishFrames] beeing empty array should cause an error",
            expects="ArgumentError")]
      public function instantiation_finishFrames_empty() : void
      {
         new Sequence(null, null, []);
      };
      
      
      [Test(description="[param loopFrames] beeing empty should cause and error",
            expects="ArgumentError")]
      public function instantiation_loopFrames_empty() : void
      {
         new Sequence(null, [], [0]);
      };
      
      
      [Test(description="if [param startFrames] is empty constructor should throw an error",
            expects="ArgumentError")]
      public function instantiation_startFrames_empty() : void
      {
         new Sequence([], [1, 2], [0]);
      };
      
      
      [Test(description="correct parameters passed to constructor should not cause errors")]
      public function instantiation_ok() : void
      {
         new Sequence(null, null, [0]);
         new Sequence(null, [1, 2], [0]);
         new Sequence([1], null, [0]);
         new Sequence([1, 2], null, [3, 4]);
         new Sequence([1, 2], [5, 6], [3, 4]);
      };
      
      
      [Test(description="checks if [prop hasStartFrames] returns correct value after instantiation")]
      public function hasStartFrames() : void
      {
         seq = new Sequence(null, null, [0]);
         // should not have start frames
         assertThat( seq.hasStartFrames, equalTo (false) );
         
         seq = new Sequence([1], null, [2]);
         // should now have start frames
         assertThat( seq.hasStartFrames, equalTo (true) );
      };
      
      
      [Test(description="checks if [prop isLooped] returns correct value after instantiation")]
      public function isLooped() : void
      {
         seq = new Sequence(null, null, [0]);
         assertThat( seq.isLooped, equalTo (false) );
         
         seq = new Sequence([3], null, [0, 1, 2]);
         assertThat( seq.isLooped, equalTo (false) );
         
         seq = new Sequence(null, [4, 5], [0]);
         assertThat( seq.isLooped, equalTo (true) );
         
         seq = new Sequence([1, 2], [4, 5, 3], [0]);
         assertThat( seq.isLooped, equalTo (true) );
      };
   }
}