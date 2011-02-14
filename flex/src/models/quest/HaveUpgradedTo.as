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
         return (klass == 'technology'
            ?(Localizer.string('Quests', 'objectiveText.'+type + '2',
               [Localizer.string('Quests', (level == 1 ? 'objectiveLvl1.' : 'objectiveLvl2.')+type), 
               ObjectStringsResolver.getString(key.split('::')[1],count), count, completed, (level > 1
                  ? Localizer.string('Quests','level',[level])
                  : ''),Localizer.string('Quests', 'technology')]))
            :(Localizer.string('Quests', 'objectiveText.'+type + '1',
               [Localizer.string('Quests', (level == 1 ? 'objectiveLvl1.' : 'objectiveLvl2.')+type), 
               ObjectStringsResolver.getString(key.split('::')[1],count), count, completed, (level > 1
                  ? ' ' + Localizer.string('Quests','of') + ' ' + Localizer.string('Quests','level',[level])
                  : '')]))
            );
      }
   }
}