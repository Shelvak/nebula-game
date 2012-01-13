package models.quest
{
   import components.quests.slides.CSlide;
   import components.quests.slides.CSlideQuestTextAndImage;
   import components.quests.slides.CSlideQuestTextOnly;
   import components.quests.slides.CSlideSimple;

   import models.quest.slides.MSlide;
   import models.quest.slides.MSlideQuestWithImage;
   import models.quest.slides.MSlideSimple;
   import models.quest.slides.SlidesConfiguration;

   import utils.SingletonFactory;


   public class MainQuestSlideFactory
   {
      public static function getInstance(): MainQuestSlideFactory {
         return SingletonFactory.getSingletonInstance(MainQuestSlideFactory);
      }

      private var _models:Object = new Object();
      private var _components:Object = new Object();
      private const _ffPairs:Object = new Object();
      private const _keyToTypeMap:Object = new Object();

      public function MainQuestSlideFactory() {
         _keyToTypeMap[SlidesConfiguration.KEY_QUEST]
            = MainQuestSlideType.QUEST;
         _keyToTypeMap[SlidesConfiguration.KEY_QUEST_WITH_IMAGE]
            = MainQuestSlideType.QUEST_WITH_IMAGE;

         _ffPairs[MainQuestSlideType.SIMPLE] =
            new FFPair(SIMPLE_model, SIMPLE_comp);
         _ffPairs[MainQuestSlideType.QUEST] =
            new FFPair(QUEST_model, QUEST_comp);
         _ffPairs[MainQuestSlideType.QUEST_WITH_IMAGE] =
            new FFPair(QUEST_WITH_IMAGE_model, QUEST_WITH_IMAGE_comp);
      }

      public function reset(): void {
         _models = new Object();
         _components = new Object();
      }

      private function SIMPLE_model(key:String, quest:Quest): MSlide {
         return new MSlideSimple(key, quest);
      }

      private function SIMPLE_comp(): CSlide {
         return new CSlideSimple();
      }

      private function QUEST_model(key:String, quest:Quest): MSlide {
         return new MSlide(key, quest);
      }

      private function QUEST_comp(): CSlideQuestTextOnly {
         return new CSlideQuestTextOnly();
      }

      private function QUEST_WITH_IMAGE_model(key:String, quest:Quest): MSlideQuestWithImage {
         return new MSlideQuestWithImage(key, quest);
      }

      private function QUEST_WITH_IMAGE_comp(): CSlideQuestTextAndImage {
         return new CSlideQuestTextAndImage();
      }

      private function getSlideType(key:String, keyIsSpecial:Boolean): int {
         if (keyIsSpecial) {
            key = MainQuestSlideKey.isQuestBaseKey(key)
                      ? SlidesConfiguration.KEY_QUEST
                      : SlidesConfiguration.KEY_QUEST_WITH_IMAGE;
         }
         if (_keyToTypeMap[key] === undefined) {
            return MainQuestSlideType.SIMPLE;
         }
         return _keyToTypeMap[key];
      }

      private function getFullKey(key:String, quest:Quest): String {
         const keyIsSpecial:Boolean =
                MainQuestSlideKey.isQuestBaseKey(key) ||
                MainQuestSlideKey.isQuestWithImageBaseKey(key);
         return keyIsSpecial
                   ? MainQuestSlideKey.getQuestFullKey(key, quest)
                   : key;
      }

      private function getFFPair(type:int): FFPair {
         return _ffPairs[type];
      }

      public function getModel(key:String, quest:Quest): MSlide {
         var fullKey:String = getFullKey(key, quest);
         var model:MSlide = _models[fullKey];
         if (model == null) {
            model = getFFPair(getSlideType(key, key != fullKey)).modelFF.call(null, key, quest);
            _models[fullKey] = model;
         }
         return model;
      }

      public function getComponent(model:MSlide): CSlide {
         var key:String = model.key;
         var fullKey:String = getFullKey(key, model.quest);
         var comp:CSlide = _components[fullKey];
         if (comp == null) {
            comp = getFFPair(getSlideType(key, key != fullKey)).compFF.call();
            comp.model = model;
            _components[fullKey] = comp;
         }
         return comp;
      }
   }
}


class FFPair
{
   public var modelFF: Function;
   public var compFF: Function;
   
   public function FFPair(modelFF:Function, compFF:Function) {
      this.modelFF = modelFF;
      this.compFF = compFF;
   }
}