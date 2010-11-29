package models.quest
{
   import utils.Localizer;
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
         return Localizer.string('Quests', 'objectiveText.'+type, [Localizer.string('Quests', (level == 1
            ? 'objectiveLvl1.'
            : 'objectiveLvl2.')+type), 
            ObjectStringsResolver.getString(key.split('::')[1],count), count, completed, (level > 1
            ? ' '+Localizer.string('Quests','level',[level])
            : '')]);
      }
   }
}