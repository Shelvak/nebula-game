package models.objectives
{
   public class HavePointsQuestObjective extends QuestObjective
   {
      public function HavePointsQuestObjective(_type:String)
      {
         super(_type);
      }
      
      [Bindable (event="completedChange")]
      public override function get objectiveText(): String
      {
         var currentPoints: int;
         switch (type)
         {
            case ObjectiveType.HAVE_ARMY_POINTS:
               currentPoints = ML.player.armyPoints;
               break;
            case ObjectiveType.HAVE_ECONOMY_POINTS:
               currentPoints = ML.player.economyPoints;
               break;
            case ObjectiveType.HAVE_POINTS:
               currentPoints = ML.player.points;
               break;
            case ObjectiveType.HAVE_SCIENCE_POINTS:
               currentPoints = ML.player.sciencePoints;
               break;
            case ObjectiveType.HAVE_WAR_POINTS:
               currentPoints = ML.player.warPoints;
               break;
            case ObjectiveType.HAVE_VICTORY_POINTS:
               currentPoints = ML.player.victoryPoints;
               break;
         }
         return objectivePart.objectiveText + 
            ' ('+ Math.min(currentPoints, limit) + '/' + limit+')';
      }
   }
}