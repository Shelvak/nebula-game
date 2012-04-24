package models.quest.slides
{
   import components.base.paging.MPage;

   import models.quest.*;

   import utils.Objects;


   public class MSlide extends MPage
   {
      public function MSlide(key: String, quest: Quest) {
         _key = Objects.paramNotEmpty("key", key);
         _quest = quest;
      }

      private var _quest: Quest;
      public function get quest(): Quest {
         return _quest;
      }

      private var _key: String;
      public function get key(): String {
         return _key;
      }
   }
}
