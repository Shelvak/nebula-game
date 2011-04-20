package tests.animation.tests
{
   import animation.Sequence;
   
   import flash.display.BitmapData;
   
   public class Data
   {
      // Sequences
      /**
       * [0] </br>
       * null </br>
       * [1, 2]
       */
      public static const seqOne:Sequence = new Sequence([0], null, [1, 2]);
      /**
       * [0, 1] </br>
       * [0, 2] </br>
       * [2]
       */
      public static const seqTwo:Sequence = new Sequence([0, 1], [0, 2], [2]);
      /**
       * null </br>
       * null </br>
       * [2, 1]
       */
      public static const seqThree:Sequence = new Sequence(null, null, [2, 1]);
      /**
       * [2, 1, 3] </br>
       * [0, 3] </br>
       * [1, 2]
       */
      public static const seqAllParts:Sequence = new Sequence([2, 1, 3], [0, 3], [1, 2]);
      /**
       * null </br>
       * [1, 2] </br>
       * [3, 1]
       */
      public static const seqLoopFinish:Sequence = new Sequence(null, [1, 2], [3, 1]);
      
      
      // Frames
      public static const frame0C:uint = 0xFF0000;
      public static const frame1C:uint = 0x00FF00;
      public static const frame2C:uint = 0x0000FF;
      public static const frame3C:uint = 0xFFFFFF;
      public static const frameWidth:int = 5;
      public static const frameHeight:int = 5;
      public static const framesTotal:int = 4;
      private static var _framesData:Vector.<BitmapData> = null;
      public static function get framesData() : Vector.<BitmapData>
      {
         if (!_framesData)
         {
            _framesData = Vector.<BitmapData>([
               new BitmapData(frameWidth, frameHeight),
               new BitmapData(frameWidth, frameHeight),
               new BitmapData(frameWidth, frameHeight),
               new BitmapData(frameWidth, frameHeight)
            ]);
            _framesData[0].setPixel(0, 0, frame0C);
            _framesData[1].setPixel(0, 0, frame1C);
            _framesData[2].setPixel(0, 0, frame2C);
            _framesData[3].setPixel(0, 0, frame3C);
         }
         return _framesData;
      }
      
      
      // Animations
      /**
       * "duck": seqOne <br/>
       * "run": seqTwo <br/>
       * "fly": seqAllParts
       */
      public static const animations:Object = {
         "duck": seqOne,
         "run": seqTwo,
         "fly": seqAllParts
      }
   }
}