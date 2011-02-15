package models.quest
{
   import controllers.objects.ObjectClass;
   
   import utils.Localizer;
   import utils.ModelUtil;
   import utils.ObjectStringsResolver;
   
   
   public class HaveUpgradedTo extends QuestObjective
   {
      public function HaveUpgradedTo()
      {
         super();
      }
      
      
      public override function get objectiveText():String
      {
         var klass: String = ModelUtil.getModelClass(key);
         return (klass == ObjectClass.TECHNOLOGY
            ?(Localizer.string('Quests', 'objectiveText.'+type + '2',
               [Localizer.string('Quests', (level == 1 ? 'objectiveLvl1.' : 'objectiveLvl2.')+type), 
               ObjectStringsResolver.getString(ModelUtil.getModelSubclass(key),count), count, completed, (level > 1
                  ? Localizer.string('Quests','level',[level])
                  : ''),Localizer.string('Quests', 'technology')]))
            :(Localizer.string('Quests', 'objectiveText.'+type + '1',
               [Localizer.string('Quests', (level == 1 ? 'objectiveLvl1.' : 'objectiveLvl2.')+type), 
               ObjectStringsResolver.getString(ModelUtil.getModelSubclass(key),count), count, completed, (level > 1
                  ? ' ' + Localizer.string('Quests','of') + ' ' + Localizer.string('Quests','level',[level])
                  : '')]))
            );
      }
   }
}