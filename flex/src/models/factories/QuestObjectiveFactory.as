package models.factories
{
   import models.objectives.AnnexPlanet;
   import models.objectives.Destroy;
   import models.objectives.DestroyNpcBuilding;
   import models.objectives.ExploreBlock;
   import models.objectives.HavePlanets;
   import models.objectives.HavePoints;
   import models.objectives.HaveUpgradedTo;
   import models.objectives.ObjectiveType;
   import models.objectives.QuestObjective;
   import models.objectives.UpgradeTo;
   
   import utils.PropertiesTransformer;
   
   public class QuestObjectiveFactory
   {
      /**
       * Creates an objective form a given simple object.
       *  
       * @param data An object representing an objective.
       * 
       * @return instance of <code>QuestObjective</code> builded from data
       */
      public static function fromObject(data:Object) : QuestObjective
      {
         data = PropertiesTransformer.objectToCamelCase(data);
         var objective: QuestObjective = new QuestObjective(data.objective.type);
         objective.limit = data.objective.limit;
         objective.npc = data.objective.npc;
         objective.level = data.objective.level;
         objective.id = data.objective.id;
         objective.questId = data.objective.questId;
         objective.key = data.objective.key;
         objective.count = data.objective.count;
         objective.alliance = data.objective.alliance;
         objective.progressId = data.progress == null
            ? -1
            : data.progress.id;
         objective.outcome = data.outcome;
         objective.completed = data.progress == null
            ? objective.count
            : data.progress.completed;
         
         return objective;
      }
   }
}