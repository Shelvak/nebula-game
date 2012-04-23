package models.tips
{
   import components.base.paging.IPageModel;
   import components.base.paging.MPageSwitcher;

   import config.Config;

   import models.quest.MMainQuestLine;

   import utils.SingletonFactory;


   public class MTipScreen extends MPageSwitcher
   {
      public static function getInstance(): MTipScreen {
         return SingletonFactory.getSingletonInstance(MTipScreen);
      }

      public function MTipScreen() {
         const tips: Vector.<IPageModel> = new Vector.<IPageModel>();
         const numTips: int = Config.getNumberOfTips();
         for (var id:int = 0; id < numTips; id++) {
            tips.push(new MTip(id, false));
         }
         super(tips, new CTipFactory());
         wrapAround = true;
      }


      override public function open(): void {
         MMainQuestLine.getInstance().close();
         super.open();
      }
   }
}


import components.base.paging.IPageComponentFactory;
import components.base.paging.IPageModel;
import components.tips.CTip;

import models.tips.MTip;

import mx.core.IVisualElement;


class CTipFactory implements IPageComponentFactory
{
   public function getPageComponent(pageModel: IPageModel): IVisualElement {
      const component: CTip = new CTip();
      component.model = MTip(pageModel);
      return component;
   }
}