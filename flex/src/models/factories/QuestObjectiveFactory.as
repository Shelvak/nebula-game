package models.factories
{
   import models.quest.AnnexPlanet;
   import models.quest.Destroy;
   import models.quest.DestroyNpcBuilding;
   import models.quest.ExploreBlock;
   import models.quest.HavePlanets;
   import models.quest.HavePoints;
   import models.quest.HaveUpgradedTo;
   import models.quest.ObjectiveType;
   import models.quest.QuestObjective;
   import models.quest.UpgradeTo;
   
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
         var tObjective: *;
         switch (data.objective.type)
         {
            case ObjectiveType.HAVE_UPGRADED_TO:
               tObjective = new HaveUpgradedTo();
               break;
            case ObjectiveType.DESTROY:
               tObjective = new Destroy();
               break;
            case ObjectiveType.UPGRADE_TO:
               tObjective = new UpgradeTo();
               break;
            case ObjectiveType.ANNEX_PLANET:
               tObjective = new AnnexPlanet();
               break;
            case ObjectiveType.HAVE_PLANETS:
               tObjective = new HavePlanets();
               break;
            case ObjectiveType.DESTROY_NPC_BUILDING:
               tObjective = new DestroyNpcBuilding();
               break;
            case ObjectiveType.HAVE_SCIENCE_POINTS:
            case ObjectiveType.HAVE_ECONOMY_POINTS:
            case ObjectiveType.HAVE_ARMY_POINTS:
            case ObjectiveType.HAVE_WAR_POINTS:
            case ObjectiveType.HAVE_VICTORY_POINTS:
            case ObjectiveType.HAVE_POINTS:
               tObjective = new HavePoints();
               tObjective.limit = data.objective.limit;
               break;
            case ObjectiveType.EXPLORE_BLOCK:
               tObjective = new ExploreBlock();
               tObjective.limit = data.objective.limit;
               break;
            default:
               throw new Error('objective type '+data.objective.type+' not yet suported');
         }
         var objective: QuestObjective = tObjective;
         objective.npc = data.objective.npc;
         objective.level = data.objective.level;
         data = PropertiesTransformer.objectToCamelCase(data);
         objective.id = data.objective.id;
         objective.questId = data.objective.questId;
         objective.type = data.objective.type;
         objective.key = data.objective.key;
         objective.count = data.objective.count;
         objective.alliance = data.objective.alliance;
         objective.progressId = data.progress == null
            ? -1
            : data.progress.id;
         objective.completed = data.progress == null
            ? objective.count
            : data.progress.completed;
         
         return objective;
      }
   }
}