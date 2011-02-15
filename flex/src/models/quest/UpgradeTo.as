package models.quest
{
   import utils.Localizer;
   import utils.ModelUtil;
   import utils.ObjectStringsResolver;
   
   
   public class UpgradeTo extends QuestObjective
   {
      public function UpgradeTo()
      {
         super();
      }
      
      
      public override function get objectiveText():String
      {
         var klass: String = ModelUtil.getModelClass(ModelUtil.getModelClass(key, true));
         var text: String = Localizer.string('Quests', 'objectiveText.'+type, 
            [Localizer.string('Quests', (
               level == 1
                  ? 'objectiveLvl1.'
                  : 'objectiveLvl2.') + type),
            ObjectStringsResolver.getString(ModelUtil.getModelSubclass(key),count), count, completed, (level > 1
               ? ' '+Localizer.string('Quests','toLevel',[level])
               : '')]);
         if (text == null)
         {
            throw new Error("Objective text creation failed, "+type+', '+key);
         }
         return text;
      }
   }
}