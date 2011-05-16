package tests.animation
{
   import tests.animation.tests.TCAnimatedBitmap;
   import tests.animation.tests.TCBattleFactory;
   import tests.animation.tests.TCBattleMatrix;
   import tests.animation.tests.TCPlaceFinder;
   import tests.animation.tests.TCSequence;
   import tests.animation.tests.TCSequencePlayer;

   [Suite]
   [RunWith("org.flexunit.runners.Suite")]
   public class TSAnimation
   {
      public var tcAnimatedBitmap:TCAnimatedBitmap;
      public var tcSequence:TCSequence;
      public var tcSequencePlayer:TCSequencePlayer;
      public var tcBattleFactory:TCBattleFactory;
      public var tcBattleMatrix:TCBattleMatrix;
      public var tcPlaceFinder:TCPlaceFinder;
   }
}