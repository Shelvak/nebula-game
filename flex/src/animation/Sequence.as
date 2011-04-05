package animation
{
   /**
    * Holds information about one animation sequence. The sequence
    * has three parts:
    * <ul>
    *    <li><code>startFrames</code> - list of frames to start animation from;</li>
    *    <li>
    *       <code>loopFrames</code> - list of frames to loop. Will kick of after <code>startFrames</code>
    *       have been played;
    *    </li>
    *    <li>
    *       <code>finishFrames</code> - list of frames to play back in the end of animation.
    *    </li>
    * </ul>
    */
   public class Sequence
   {
      private var _startFrames:Array = null;
      /**
       * List of starting frames of this animation sequence.
       */
      public function get startFrames() : Array
      {
         return _startFrames;
      }
      
      
      private var _loopFrames:Array = null;
      /**
       * List of frames to be looped.
       */
      public function get loopFrames() : Array
      {
         return _loopFrames;
      }
      
      
      private var _finishFrames:Array = null;
      /**
       * List of frames to play back in the end of animation sequence.
       */
      public function get finishFrames() : Array
      {
         return _finishFrames;
      }
      
      
      /**
       * Indicates if this sequence has <code>startFrames</code> part.
       */
      public function get hasStartFrames() : Boolean
      {
         return startFrames ? true : false;
      }
      
      
      public function get hasFinishFrames() : Boolean
      {
         return finishFrames ? true : false;
      }
      
      
      /**
       * Indicates if this sequence has <code>looFrames</code> part.
       */
      public function get isLooped() : Boolean
      {
         return loopFrames ? true : false;
      }
      
      
      /**
       * Constructor. Each list, if provided, must contain at least one frame number. 
       * 
       * @param startFrames start part of this animation. Not required.
       * @param loopFrames loop part of this animation. Not required. Must have at least 2 frame number.
       * @param finishFrames finish part of this animation.  Not required.
       */
      public function Sequence(startFrames:Array, loopFrames:Array, finishFrames:Array)
      {
         // Check parameters for validity
         if (finishFrames && finishFrames.length == 0 ||
             startFrames && startFrames.length == 0 ||
             loopFrames && loopFrames.length == 0)
         {
            throw new ArgumentError("[param startFrames], [param loopFrames] and [param finishFrames], " +
                                    "if not null, must have at least one element");
         }
         
         _startFrames = startFrames;
         _loopFrames = loopFrames;
         _finishFrames = finishFrames;
      }
   }
}