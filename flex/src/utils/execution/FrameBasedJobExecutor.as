package utils.execution
{
   import flash.display.DisplayObject;
   import flash.display.Stage;
   import flash.events.Event;

   import mx.core.FlexGlobals;


   public class FrameBasedJobExecutor extends BaseJobExecutor
   {
      private function get stage(): Stage {
         return DisplayObject(FlexGlobals.topLevelApplication).stage;
      }

      public function FrameBasedJobExecutor(pauseOtherProcessing: Boolean) {
         super(pauseOtherProcessing);
      }

      private function stage_enterFrameHandler(event: Event): void {
         executeNextSubJob();
      }

      override protected function executeImpl(): void {
         stage.addEventListener(
            Event.ENTER_FRAME, stage_enterFrameHandler, false, 0, true
         );
      }

      override protected function stopImpl(): void {
         stage.removeEventListener(
            Event.ENTER_FRAME, stage_enterFrameHandler, false
         );
      }
   }
}
