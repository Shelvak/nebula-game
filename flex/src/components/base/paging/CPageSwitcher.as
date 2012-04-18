package components.base.paging
{
   import components.base.SpinnerContainer;

   import flash.events.MouseEvent;

   import spark.components.Button;
   import spark.components.Group;
   import spark.components.Label;
   import spark.components.supportClasses.SkinnableComponent;


   public class CPageSwitcher extends SkinnableComponent
   {
      public function CPageSwitcher(): void {
         super();
         setStyle("skinClass", CPageSwitcherSkin);
      }

      /* ############# */
      /* ### MODEL ### */
      /* ############# */

      private var _model: MPageSwitcher;
      public function set model(value: MPageSwitcher): void {
         if (_model != value) {
            if (_model != null) {
               _model.removeEventListener(
                  MPageSwitcherEvent.CURRENT_PAGE_CHANGE,
                  model_currentPageChangeHandler, false
               );
               _model.removeEventListener(
                  MPageSwitcherEvent.IS_OPEN_CHANGE,
                  model_isOpenChangeHandler, false
               );
            }
            _model = value;
            setCurrentPage();
            if (_model != null) {
               _model.addEventListener(
                  MPageSwitcherEvent.CURRENT_PAGE_CHANGE,
                  model_currentPageChangeHandler, false, 0, true
               );
               _model.addEventListener(
                  MPageSwitcherEvent.IS_OPEN_CHANGE,
                  model_isOpenChangeHandler, false, 0, true
               );
            }
            f_modelChanged = true;
            invalidateProperties();
         }
      }
      public function get model(): MPageSwitcher {
         return _model;
      }

      private var _currentPage: IPageModel = null;
      private function setCurrentPage(): void {
         if (_currentPage != null) {
            _currentPage.removeEventListener(
               PageModelEvent.LOADING_CHANGE,
               currentPage_loadingChangeHandler, false
            );
         }
         _currentPage = model != null ? model.currentPage : null;
         updateContainers();
         updateVisibility();
         if (_currentPage != null) {
            _currentPage.addEventListener(
               PageModelEvent.LOADING_CHANGE,
               currentPage_loadingChangeHandler, false, 0, true
            );
         }
         f_currentPageChanged = true;
         invalidateProperties();
      }

      private function updateVisibility(): void {
         visible = model != null && model.isOpen;
      }

      private function currentPage_loadingChangeHandler(event: PageModelEvent): void {
         updateContainers();
      }

      private function model_currentPageChangeHandler(event: MPageSwitcherEvent): void {
         setCurrentPage();
      }

      private function model_isOpenChangeHandler(event: MPageSwitcherEvent): void {
         updateVisibility();
      }

      private var f_modelChanged: Boolean = true;
      private var f_currentPageChanged: Boolean = true;

      override protected function commitProperties(): void {
         super.commitProperties();
         if (f_modelChanged) {
            grpPageContainer.removeAllElements();
            if (model != null) {
               const factory: IPageComponentFactory = model.componentFactory;
               for each (var page: IPageModel in model.allPages()) {
                  grpPageContainer.addElement(factory.getPageComponent(page));
               }
            }
         }
         if (model != null && (f_modelChanged || f_currentPageChanged)) {
            if (btnClose != null) {
               btnClose.visible = !model.hasNextPage;
            }
            btnNextPage.visible = model.hasNextPage;
            btnPreviousPage.visible = model.hasPreviousPage;
            lblPageNumber.text = model.currentPageNum + " / " + model.numPages;
         }
         f_modelChanged = false;
         f_currentPageChanged = false;
      }


      /* ############ */
      /* ### SKIN ### */
      /* ############ */

      [SkinPart(required="true")]
      public var grpPageContainer: Group;

      [SkinPart(required="false")]
      public var grpSpinnerContainer: SpinnerContainer;

      private function updateContainers(): void {
         const loading: Boolean = _currentPage != null && _currentPage.loading;
         if (grpSpinnerContainer != null) {
            grpSpinnerContainer.busy = loading;
            grpSpinnerContainer.visible = loading;
         }
         if (grpPageContainer) {
            grpPageContainer.visible = !loading;
         }
      }

      [SkinPart(required="true")]
      public var lblPageNumber: Label;

      [SkinPart(required="true")]
      public var btnPreviousPage: Button;

      private function btnPreviousPage_clickHandler(event: MouseEvent): void {
         if (model != null) {
            model.previousPage();
         }
      }

      [SkinPart(required="true")]
      public var btnNextPage: Button;

      private function btnNextPage_clickHandler(event: MouseEvent): void {
         if (model != null) {
            model.nextPage();
         }
      }

      [SkinPart(required="false")]
      public var btnClose: Button;

      private function btnClose_clickHandler(event: MouseEvent): void {
         if (model != null) {
            model.close();
         }
      }

      override protected function partAdded(partName: String,
                                            instance: Object): void {
         super.partAdded(partName, instance);
         switch (instance)
         {
            case btnNextPage:
               btnNextPage.addEventListener(
                  MouseEvent.CLICK, btnNextPage_clickHandler, false, 0, true
               );
               break;

            case btnPreviousPage:
               btnPreviousPage.addEventListener(
                  MouseEvent.CLICK, btnPreviousPage_clickHandler, false, 0, true
               );
               break;

            case btnClose:
               btnClose.addEventListener(
                  MouseEvent.CLICK, btnClose_clickHandler, false, 0, true
               );
               break;

            case grpSpinnerContainer:
               grpSpinnerContainer.timeoutEnabled = false;
               break;
         }
      }
   }
}
