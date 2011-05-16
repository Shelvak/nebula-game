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
         var quest:Quest = new Quest();
         quest.id = data.quest.id;
         quest.rewards = new Reward(data.quest.rewards);
         quest.helpUrlId = data.quest.helpUrlId;
         quest.status = data.progress.status;
         quest.completed = data.progress.completed;
         
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