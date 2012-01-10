package models.factories
{
   import controllers.battle.BattleController;
   
   import models.ModelLocator;
   import models.ModelsCollection;
   import models.quest.Quest;
   import models.objectives.QuestObjective;
   import models.Reward;
   
   import utils.PropertiesTransformer;
   
   public class QuestFactory
   {
      /**
       * Creates <code>Quest</code> model with all objectives in it.
       * 
       * @param data Raw object containing all information about quest.
       *  
       * @return instance of <code>Quest</code>
       */
      public static function fromObject(data:Object) : Quest
      {
         data = PropertiesTransformer.objectToCamelCase(data);
         var questData:Object = data["quest"];
         var progressData:Object = data["progress"];
         var quest:Quest = new Quest();
         quest.id = questData["id"];
         quest.rewards = new Reward(questData["rewards"]);
         quest.mainQuestSlides = questData["mainQuestSlides"];
         quest.status = progressData["status"];
         quest.completed = progressData["completed"];

         var source:Array = new Array();
         for each (var rawObjective: Object in data.objectives)
         {
            source.push(QuestObjectiveFactory.fromObject(rawObjective));
         }
         quest.objectives = new ModelsCollection(source);
         
         return quest;
      }
   }
}