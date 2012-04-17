package components.base.paging
{
   import flash.events.IEventDispatcher;


   [Event(
      name="visibleChange",
      type="components.base.paging.PageModelEvent")]

   [Event(
      name="loadingChange",
      type="components.base.paging.PageModelEvent")]

   public interface IPageModel extends IEventDispatcher
   {
      /**
       * Is the page visible? When this property changes,
       * <code>PageModelEvent.VISIBLE_CHANGE</code> event is dispatched.
       */
      function set visible(value: Boolean): void;
      function get visible(): Boolean;

      /**
       * Optional. Is the page loading?  When this property changes,
       * <code>PageModelEvent.LOADING_CHANGE</code> event is dispatched.
       */
      function set loading(value: Boolean): void;
      function get loading(): Boolean;
   }
}
