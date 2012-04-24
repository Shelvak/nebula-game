package components.base.paging
{
   import flash.events.EventDispatcher;

   import utils.Events;

   import utils.Objects;


   [Event(
      name="currentPageChange",
      type="components.base.paging.MPageSwitcherEvent")]

   [Event(
      name="isOpenChange",
      type="components.base.paging.MPageSwitcherEvent")]

   public class MPageSwitcher extends EventDispatcher
   {
      private var _pages: Vector.<IPageModel>;

      public function MPageSwitcher(pages: Vector.<IPageModel>,
                                    pageComponentFactory: IPageComponentFactory) {
         _pages =
            Objects.paramNotNull("pages", pages);
         _componentFactory =
            Objects.paramNotNull("componentFactory", pageComponentFactory);
         _numPages = _pages.length;
         firstPage();
         for each (var page: IPageModel in pages) {
            page.visible = false;
         }
         currentPage.visible = true;
      }

      public var wrapAround: Boolean = false;

      private var _componentFactory: IPageComponentFactory;
      public function get componentFactory(): IPageComponentFactory {
         return _componentFactory;
      }

      private var _currentPageIdx: int = 0;
      private function setCurrentPageIdx(value: int): void {
         if (_currentPageIdx != value) {
            const oldPage: IPageModel = currentPage;
            currentPage.visible = false;
            _currentPageIdx = value;
            currentPage.visible = true;
            const newPage: IPageModel = currentPage;
            const eventType: String = MPageSwitcherEvent.CURRENT_PAGE_CHANGE;
            if (hasEventListener(eventType)) {
               const event: MPageSwitcherEvent =
                        new MPageSwitcherEvent(eventType);
               event.oldPage = oldPage;
               event.newPage = newPage;
               dispatchEvent(event);
            }
         }
      }


      private function get onFirstPage(): Boolean {
         return _currentPageIdx == 0;
      }

      public function previousPage(): void {
         if (hasPreviousPage) {
            onFirstPage
               ? lastPage()
               : setCurrentPageIdx(_currentPageIdx - 1);
         }
      }

      public function firstPage(): void {
         setCurrentPageIdx(0);
      }

      private function get lastPageIdx(): int {
         return numPages - 1;
      }

      private function get onLastPage(): Boolean {
         return _currentPageIdx == lastPageIdx;
      }

      public function nextPage(): void {
         if (hasNextPage) {
            onLastPage
               ? firstPage()
               : setCurrentPageIdx(_currentPageIdx + 1);
         }
      }

      public function lastPage(): void {
         setCurrentPageIdx(lastPageIdx);
      }

      [Bindable(event="currentPageChange")]
      public function get hasPreviousPage(): Boolean {
         return wrapAround || !onFirstPage;
      }

      [Bindable(event="currentPageChange")]
      public function get currentPageNum(): int {
         return _currentPageIdx + 1;
      }

      [Bindable(event="currentPageChange")]
      public function get currentPage(): IPageModel {
         return _pages[_currentPageIdx];
      }

      [Bindable(event="currentPageChange")]
      public function get hasNextPage(): Boolean {
         return wrapAround || !onLastPage;
      }

      private var _numPages: int;
      public function get numPages(): int {
         return _numPages;
      }

      public function allPages(): Vector.<IPageModel> {
         return _pages.slice();
      }

      private var _isOpen: Boolean = false;
      [Bindable(event="isOpenChange")]
      public function get isOpen(): Boolean {
         return _isOpen;
      }
      private function setIsOpen(value: Boolean): void {
         if (_isOpen != value) {
            _isOpen = value;
            Events.dispatchSimpleEvent(
               this, MPageSwitcherEvent, MPageSwitcherEvent.IS_OPEN_CHANGE
            );
         }
      }

      public function open(): void {
         setIsOpen(true);
      }

      public function close(): void {
         setIsOpen(false);
      }
   }
}
