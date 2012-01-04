package models.quest
{
   import flash.errors.IllegalOperationError;
   import flash.events.EventDispatcher;

   import models.quest.events.MMainQuestPresentationEvent;
   import models.quest.slides.MSlide;

   import utils.Events;
   import utils.Objects;

   
   [Event(
      name="currentSlideChange",
      type="models.quest.events.MMainQuestPresentationEvent")]

   public class MMainQuestPresentation extends EventDispatcher
   {
      private var _quest:Quest;
      private var _slides:Vector.<MSlide>;
      private var _numSlides:int;

      public function MMainQuestPresentation(quest:Quest) {
         _quest = Objects.paramNotNull("quest", quest);
         createSlides();
         firstSlide();
         currentSlide.visible = true;
      }

      private function createSlides(): void {
         const keys:Array = _quest.mainQuestSlides.split(",");
         _slides = new Vector.<MSlide>();
         for each (var key:String in keys) {
            _slides.push(
               MainQuestSlideFactory.getInstance().getModel(key, _quest)
            );
         }
         _numSlides = _slides.length;
      }

      private var _currentSlideIdx:int;
      private function setCurrentSlideIdx(value:int): void {
         if (_currentSlideIdx != value) {
            currentSlide.visible = false;
            _currentSlideIdx = value;
            currentSlide.visible = true;
            Events.dispatchSimpleEvent(
               this,
               MMainQuestPresentationEvent,
               MMainQuestPresentationEvent.CURRENT_SLIDE_CHANGE
            );
         }
      }

      public function firstSlide(): void {
         setCurrentSlideIdx(0);
      }

      public function nextSlide(): void {
         if (hasNextSlide) {
            setCurrentSlideIdx(_currentSlideIdx + 1);
         }
         else {
            throw new IllegalOperationError("Already showing the last slide");
         }
      }

      public function previousSlide(): void {
         if (hasPreviousSlide) {
            setCurrentSlideIdx(_currentSlideIdx - 1);
         }
         else {
            throw new IllegalOperationError("Already showing the first slide");
         }
      }
      
      [Bindable(event="currentSlideChange")]
      public function get hasPreviousSlide(): Boolean {
         return _currentSlideIdx > 0;
      }

      [Bindable(event="currentSlideChange")]
      public function get currentSlide(): MSlide {
         return _slides[_currentSlideIdx];
      }

      [Bindable(event="currentSlideChange")]
      public function get hasNextSlide(): Boolean {
         return _currentSlideIdx < _numSlides - 1;
      }

      public function allSlides(): Vector.<MSlide> {
         return _slides.slice();
      }
   }
}
