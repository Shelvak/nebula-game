package components.base.paging
{
   import flash.events.Event;


   public class MPageSwitcherEvent extends Event
   {
      public static const CURRENT_PAGE_CHANGE: String = "currentPageChange";
      public static const IS_OPEN_CHANGE: String = "isOpenChange";

      public function MPageSwitcherEvent(type: String) {
         super(type);
      }

      public var oldPage: IPageModel;
      public var newPage: IPageModel;
   }
}
