package components.base.paging
{
   import flash.events.Event;


   public class PageModelEvent extends Event
   {
      public static const VISIBLE_CHANGE: String = "visibleChange";
      public static const LOADING_CHANGE: String = "loadingChange";

      public function PageModelEvent(type: String) {
         super(type);
      }
   }
}
