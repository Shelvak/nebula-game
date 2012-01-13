package models.quest.slides
{
   import models.quest.*;
   import flash.events.EventDispatcher;

   import models.quest.events.MMainQuestSlideEvent;

   import utils.Events;

   import utils.Objects;


   [Event(
      name="visibleChange",
      type="models.quest.events.MMainQuestSlideEvent")]

   public class MSlide extends EventDispatcher
   {
      public function MSlide(key:String, quest:Quest) {
         _key = Objects.paramNotEmpty("key", key);
         _quest = quest;
      }

      private var _quest: Quest;
      public function get quest(): Quest {
         return _quest;
      }

      private var _key:String;
      public function get key(): String {
         return _key;
      }

      private var _visible:Boolean = false;
      [Bindable(event="visibleChange")]
      public function set visible(value: Boolean): void {
         if (_visible != value) {
            _visible = value;
            Events.dispatchSimpleEvent(
               this,
               MMainQuestSlideEvent,
               MMainQuestSlideEvent.VISIBLE_CHANGE
            );
         }
      }
      public function get visible(): Boolean {
         return _visible;
      }

      [Bindable]
      public var loading:Boolean = false;
   }
}
