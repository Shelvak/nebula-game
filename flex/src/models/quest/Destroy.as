package models.quest
{
   import utils.Localizer;
   import utils.ModelUtil;
   import utils.ObjectStringsResolver;
   
   
   public class Destroy extends QuestObjective
   {
      public function Destroy()
      {
         super();
      }
      
      
      public override function get objectiveText():String
      {
         return Localizer.string('Quests', 'objectiveText.'+type, [Localizer.string('Quests', (level == 1
            ? 'objectiveLvl1.'
            : 'objectiveLvl2.')+type), 
            ObjectStringsResolver.getString(ModelUtil.getModelSubclass(key), count), count, completed, (level > 1
               ? ' '+Localizer.string('Quests','level',[level])
               : '')]);
      }
   }
}