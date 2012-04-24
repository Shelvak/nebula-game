package tests.paging
{
   import components.base.paging.IPageModel;
   import components.base.paging.MPage;
   import components.base.paging.MPageSwitcher;
   import components.base.paging.MPageSwitcherEvent;

   import ext.hamcrest.events.causes;
   import ext.hamcrest.object.definesProperties;
   import ext.hamcrest.object.equals;
   import ext.hamcrest.object.metadata.withBindableTag;

   import org.hamcrest.Matcher;
   import org.hamcrest.assertThat;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;


   public class TC_MPageSwitcher
   {
      private var switcher: MPageSwitcher;
      private var pages: Vector.<IPageModel>;

      [Before]
      public function setUp(): void {
         pages = Vector.<IPageModel>([
            pageModel(), pageModel(), pageModel()
         ]);
         switcher = new MPageSwitcher(pages, new IPageComponentFactoryMock());
      }

      [After]
      public function tearDown(): void {
         switcher = null;
      }

      [Test]
      public function initialization(): void {
         assertThat(
            "first page is the currentPage",
            switcher.currentPage, equals (pages[0])
         );
         assertThat(
            "can switch to next page",
            switcher.hasNextPage, isTrue()
         );
         assertThat(
            "can't switch to previous page",
            switcher.hasPreviousPage, isFalse()
         );
      }

      [Test]
      public function pagesNavigation(): void {
         assertThat(
            "has next page when currentPage is the first",
            switcher.hasNextPage, isTrue()
         );
         assertThat(
            "does not have previous page when currentPage is the first",
            switcher.hasPreviousPage, isFalse()
         );

         assertThat(
            "event is dispatched when next page is switched",
            switcher.nextPage,
            causes (switcher) .toDispatchEvent(
               MPageSwitcherEvent.CURRENT_PAGE_CHANGE,
               function (event: MPageSwitcherEvent): void {
                  assertThat( event.oldPage, equals (pages[0]) );
                  assertThat( event.newPage, equals (pages[1]) );
               }
            )
         );
         assertThat(
            "switched to next page",
            switcher.currentPage, equals (pages[1])
         );
         assertThat(
            "has next page when currentPage is in the middle",
            switcher.hasNextPage, isTrue()
         );
         assertThat(
            "has previous page when currentPage is in the middle",
            switcher.hasPreviousPage, isTrue()
         );

         switcher.nextPage();
         assertThat(
            "switched to next page",
            switcher.currentPage, equals (pages[2])
         );
         assertThat(
            "does not have next page when currentPage is the last",
            switcher.hasNextPage, isFalse()
         );
         assertThat(
            "has previous page when currentPage is in the last",
            switcher.hasPreviousPage, isTrue()
         );

         assertThat(
            "event is dispatched when previous page is switched",
            switcher.previousPage,
            causes (switcher) .toDispatchEvent(
               MPageSwitcherEvent.CURRENT_PAGE_CHANGE
            )
         );
         assertThat(
            "switched to previous page",
            switcher.currentPage, equals (pages[1])
         );

         assertThat(
            "event is dispatched when first page is switched",
            switcher.firstPage,
            causes (switcher) .toDispatchEvent(
               MPageSwitcherEvent.CURRENT_PAGE_CHANGE
            )
         );
         assertThat(
            "switched to first page",
            switcher.currentPage, equals (pages[0])
         );

         assertThat(
            "event is dispatched when last page is switched",
            switcher.lastPage,
            causes (switcher) .toDispatchEvent(
               MPageSwitcherEvent.CURRENT_PAGE_CHANGE
            )
         );
         assertThat(
            "switched to last page",
            switcher.currentPage, equals (pages[2])
         );
      }

      [Test]
      public function navigatingPagesChangesTheirVisibility(): void {
         var page: IPageModel = switcher.currentPage;
         assertThat(
            "when instance is created the first page is visible",
            page.visible, isTrue()
         );

         switcher.nextPage();
         assertThat(
            "when switching to next page, previous current becomes invisible",
            page.visible, isFalse()
         );
         page = switcher.currentPage;
         assertThat(
            "when switching to next page, that page becomes visible",
            page.visible, isTrue()
         );

         switcher.previousPage();
         assertThat(
            "when switching to previous page, current becomes invisible",
            page.visible, isFalse()
         );
         page = switcher.currentPage;
         assertThat(
            "when switching to previous page, that page becomes visible",
            page.visible, isTrue()
         );
      }

      [Test]
      public function afterInitializationOnlyTheFirstPageIsVisible(): void {
         var pages: Vector.<IPageModel>;

         switcher = new MPageSwitcher(
            Vector.<IPageModel>([pageModel(), pageModel()]),
            new IPageComponentFactoryMock()
         );
         pages = switcher.allPages();
         assertThat(
            "first page visible after initialization with quest",
            pages[0].visible, isTrue()
         );
         assertThat(
            "second page invisible after initialization with quest",
            pages[1].visible, isFalse()
         );

         switcher.nextPage();
         switcher = new MPageSwitcher(pages, new IPageComponentFactoryMock());
         assertThat(
            "first page visible after initialization with same pages again",
            pages[0].visible, isTrue()
         );
         assertThat(
            "second page invisible after initialization with same page again",
            pages[1].visible, isFalse()
         );
      }

      [Test]
      public function pageNumbers(): void {
         assertThat(
            "number of pages", switcher.numPages, equals (3)
         );
         assertThat(
            "numbering starts with 1", switcher.currentPageNum, equals (1)
         );

         switcher.nextPage();
         assertThat(
            "page number changes when switching pages",
            switcher.currentPageNum, equals (2)
         );
      }

      [Test]
      public function openAndClose(): void {
         assertThat(
            "should be closed by default", switcher.isOpen, isFalse()
         );

         assertThat(
            "should dispatch IS_OPEN_CHANGE event",
            switcher.open, causes (switcher) .toDispatchEvent(
               MPageSwitcherEvent.IS_OPEN_CHANGE
            )
         );
         assertThat(
            "should be open", switcher.isOpen, isTrue()
         );

         assertThat(
            "should dispatch IS_OPEN_CHANGE event",
            switcher.close, causes(switcher).toDispatchEvent(
               MPageSwitcherEvent.IS_OPEN_CHANGE
            )
         );
         assertThat(
            "should be closed", switcher.isOpen, isFalse()
         );
      }

      [Test]
      public function wrapAround(): void {
         assertThat(
            "should not be on by default", switcher.wrapAround, isFalse()
         );
         switcher.wrapAround = true;

         switcher.firstPage();
         assertThat(
            "should have previous page when on first page and wrapAround is on",
            switcher.hasPreviousPage, isTrue()
         );
         switcher.previousPage();
         assertThat(
            "should switch to last page when on first page and wrapAround is on",
            switcher.currentPageNum, equals (3)
         );

         switcher.lastPage();
         assertThat(
            "should have next page when on last page and wrapAround is on",
            switcher.hasNextPage, isTrue()
         );
         switcher.nextPage();
         assertThat(
            "should switch to first page when on last page and wrapAround is on",
            switcher.currentPageNum, equals (1)
         );
      }

      [Test]
      public function metadata(): void {
         function _withBindableTag(): Matcher {
            return withBindableTag(
               MPageSwitcherEvent.CURRENT_PAGE_CHANGE
            );
         }
         assertThat(
            MPageSwitcher, definesProperties({
               "hasPreviousPage": _withBindableTag(),
               "currentPageNum": _withBindableTag(),
               "currentPage": _withBindableTag(),
               "hasNextPage": _withBindableTag(),
               "isOpen": withBindableTag(MPageSwitcherEvent.IS_OPEN_CHANGE)
            })
         );
      }

      private function pageModel():IPageModel {
         return new MPage();
      }
   }
}


import components.base.paging.IPageComponentFactory;
import components.base.paging.IPageModel;

import mx.core.IVisualElement;


class IPageComponentFactoryMock implements IPageComponentFactory
{
   public function getPageComponent(pageModel: IPageModel): IVisualElement {
      return null;
   }
}