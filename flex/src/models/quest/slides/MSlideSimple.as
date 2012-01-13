package models.quest.slides
{
   import flash.geom.Rectangle;

   import models.quest.Quest;

   import utils.locale.Localizer;


   public class MSlideSimple extends MSlide
   {
      public function MSlideSimple(key:String, quest:Quest) {
         super(key, quest);
      }

      public function get text(): String {
         return Localizer.string("QuestScreens", key);
      }

      public function get textArea(): Rectangle {
         return SlidesConfiguration.getSimpleSlideTextPosition(key);
      }
   }
}
