package models.objectives
{
   import flash.display.BitmapData;
   
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   public class ObjectivePart
   {
      public static function getObjectivePart(objective: Objective): ObjectivePart
      {
         switch (objective.type)
         {
            case ObjectiveType.HAVE_UPGRADED_TO:
               return new HaveUpgradedTo(objective);
            case ObjectiveType.DESTROY:
               return new Destroy(objective);
            case ObjectiveType.UPGRADE_TO:
               return new UpgradeTo(objective);
            case ObjectiveType.ANNEX_PLANET:
               return new AnnexPlanet(objective);
            case ObjectiveType.HAVE_PLANETS:
               return new HavePlanets(objective);
            case ObjectiveType.DESTROY_NPC_BUILDING:
               return new DestroyNpcBuilding(objective);
            case ObjectiveType.HAVE_SCIENCE_POINTS:
            case ObjectiveType.HAVE_ECONOMY_POINTS:
            case ObjectiveType.HAVE_ARMY_POINTS:
            case ObjectiveType.HAVE_WAR_POINTS:
            case ObjectiveType.HAVE_VICTORY_POINTS:
            case ObjectiveType.HAVE_POINTS:
               return new HavePoints(objective);
            case ObjectiveType.EXPLORE_BLOCK:
               return new ExploreBlock(objective);
            case ObjectiveType.ACCELERATE:
               return new Accelerate(objective);
            case ObjectiveType.ACCELERATE_FLIGHT:
               return new AccelerateFlight(objective);
            case ObjectiveType.BATTLE:
               return new Battle(objective);
            case ObjectiveType.BECOME_VIP:
               return new BecomeVip(objective);
            case ObjectiveType.COMPLETE_ACHIEVEMENTS:
               return new CompleteAchievements(objective);
            case ObjectiveType.COMPLETE_QUESTS:
               return new CompleteQuests(objective);
            case ObjectiveType.HEAL_HP:
               return new HealHp(objective);
            case ObjectiveType.MOVE_BUILDING:
               return new MoveBuilding(objective);
            case ObjectiveType.SELF_DESTRUCT:
               return new SelfDestruct(objective);
            default:
               throw new Error('objective type '+objective.type+' not yet suported');
         }
         return null;
      }
      
      public function ObjectivePart(_objective: Objective)
      {
         objective = _objective;
      }
      
      public var objective: Objective;
      
      public function get objectiveText(): String
      {
         throw new Error('You must override objective text getter');
      }
      
      public function get image(): BitmapData
      {
         return ImagePreloader.getInstance().getImage(
            AssetNames.getAchievementImageName(objective.type, objective.key));
      }
   }
}