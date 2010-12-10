package models.quest
{
   import utils.Localizer;
   import utils.ObjectStringsResolver;
   
   
   public class HaveUpgradedTo extends QuestObjective
   {
      public function HaveUpgradedTo()
      {
         super();
      }
      
      
      public override function get objectiveText():String
      {
         var klass: String = key.split('::')[0];
         return Localizer.string('Quests', 'objectiveText.'+type + (klass=='Technology'?'2':'1'), 
            [Localizer.string('Quests', 
            (level == 1
            ? 'objectiveLvl1.'
            : 'objectiveLvl2.')+type), 
            ObjectStringsResolver.getString(key.split('::')[1],count), count, 
            completed, (level > 1
            ? ' '+Localizer.string('Quests','level',[level])
            : ''),(klass=='Technology'?Localizer.string('Quests', 'technology'):'')]);
      }
   }
}