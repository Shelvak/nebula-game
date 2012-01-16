package models.quest.slides
{
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
   }
}
