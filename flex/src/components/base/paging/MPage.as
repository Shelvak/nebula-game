package components.base.paging
{
   import flash.events.EventDispatcher;

   import utils.Events;


   public class MPage extends EventDispatcher implements IPageModel
   {
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
