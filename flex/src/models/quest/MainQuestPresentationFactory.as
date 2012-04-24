package models.quest
{
   import components.base.paging.IPageModel;
   import components.base.paging.MPageSwitcher;

   import utils.Objects;
   import utils.SingletonFactory;


   public class MainQuestPresentationFactory
   {
      public static function getInstance(): MainQuestPresentationFactory {
         return SingletonFactory
                   .getSingletonInstance(MainQuestPresentationFactory);
      }

      public function getPresentation(quest:Quest): MPageSwitcher {
         Objects.paramNotNull("quest", quest);
         const slideFactory: MainQuestSlideFactory =
                  MainQuestSlideFactory.getInstance();
         const keys: Array = quest.mainQuestSlides.split(",");
         const slides: Vector.<IPageModel> = new Vector.<IPageModel>();
         for each (var key: String in keys) {
            slides.push(slideFactory.getModel(key, quest));
         }
         return new MPageSwitcher(
            slides, new SlideComponentFactory(slideFactory)
         );
      }
   }
}


import components.base.paging.IPageComponentFactory;
import components.base.paging.IPageModel;

import models.quest.MainQuestSlideFactory;
import models.quest.slides.MSlide;

import mx.core.IVisualElement;


class SlideComponentFactory implements IPageComponentFactory
{
   private var _factory: MainQuestSlideFactory;

   public function SlideComponentFactory(slideFactory: MainQuestSlideFactory) {
      _factory = slideFactory;
   }

   public function getPageComponent(pageModel: IPageModel): IVisualElement {
      return _factory.getComponent(MSlide(pageModel));
   }
}