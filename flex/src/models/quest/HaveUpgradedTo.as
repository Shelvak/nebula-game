package models.quest
{
   import utils.ObjectStringsResolver;
   
   [ResourceBundle("Quests")]
   
   public class HaveUpgradedTo extends QuestObjective
   {
      public function HaveUpgradedTo()
      {
         super();
      }
      
      
      public override function get objectiveText():String
      {
         return RM.getString('Quests', 'objectiveText.'+type, [RM.getString('Quests', (level == 1
            ? 'objectiveLvl1.'
            : 'objectiveLvl2.')+type), 
            ObjectStringsResolver.getString(key.split('::')[1],count), count, completed, (level > 1
            ? ' '+RM.getString('Quests','level',[level])
            : '')]);
      }
   }
}