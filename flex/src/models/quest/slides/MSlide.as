package models.quest.slides
{
   import components.base.paging.IPageModel;
   import components.base.paging.PageModelEvent;

   import flash.events.EventDispatcher;

   import models.quest.*;

   import utils.Events;

   import utils.Objects;


   public class MSlide extends EventDispatcher implements IPageModel
   {
      public function MSlide(key: String, quest: Quest) {
         _key = Objects.paramNotEmpty("key", key);
         _quest = quest;
      }

      private var _quest: Quest;
      public function get quest(): Quest {
         return _quest;
      }

      private var _key: String;
      public function get key(): String {
         return _key;
      }

      private var _visible: Boolean = false;
      [Bindable(event="visibleChange")]
      public function set visible(value: Boolean): void {
         if (_visible != value) {
            _visible = value;
            dispatchPageModelEvent(PageModelEvent.VISIBLE_CHANGE);
         }
      }
      public function get visible(): Boolean {
         return _visible;
      }

      private var _loading: Boolean = false;
      [Bindable(event="loadingChange")]
      public function set loading(value: Boolean): void {
         if (_loading != value) {
            _loading = value;
            dispatchPageModelEvent(PageModelEvent.LOADING_CHANGE);
         }
      }
      public function get loading(): Boolean {
         return _loading;
      }

      private function dispatchPageModelEvent(type: String): void {
         Events.dispatchSimpleEvent(this, PageModelEvent, type);
      }
   }
}
