package tests.animation
{
   import tests.animation.tests.TC_AnimatedBitmap;
   import tests.animation.tests.TC_BattleFactory;
   import tests.animation.tests.TC_BattleMatrix;
   import tests.animation.tests.TC_PlaceFinder;
   import tests.animation.tests.TC_Sequence;
   import tests.animation.tests.TC_SequencePlayer;

   [Suite]
   [RunWith("org.flexunit.runners.Suite")]
   public class TS_Animation
   {
      public var tc_AnimatedBitmap:TC_AnimatedBitmap;
      public var tc_Sequence:TC_Sequence;
      public var tc_SequencePlayer:TC_SequencePlayer;
      public var tc_BattleFactory:TC_BattleFactory;
      public var tc_BattleMatrix:TC_BattleMatrix;
      public var tc_PlaceFinder:TC_PlaceFinder;
   }
}