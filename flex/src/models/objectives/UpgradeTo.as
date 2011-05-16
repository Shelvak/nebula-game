package models.objectives
{
   import utils.ModelUtil;
   import utils.ObjectStringsResolver;
   import utils.locale.Localizer;
   
   
   public class UpgradeTo extends ObjectivePart
   {
      public function UpgradeTo(_objective: Objective)
      {
         super(_objective);
      }
      
      
      public override function get objectiveText():String
      {
         var klass: String = ModelUtil.getModelClass(objective.key);
         var text: String = Localizer.string('Objectives', 'objectiveText.'+objective.type, 
            [Localizer.string('Objectives', (
               objective.level == 1
                  ? 'objectiveLvl1.'
                  : 'objectiveLvl2.') + objective.type),
            ObjectStringsResolver.getString(
               (objective.key.indexOf(ModelUtil.MODEL_SUBCLASS_SEPARATOR) != -1
                  ? ModelUtil.getModelSubclass(objective.key)
                  : objective.key),objective.count), objective.count, (objective.level > 1
               ? ' '+Localizer.string('Objectives','toLevel',[objective.level])
               : '')]);
         if (text == null)
         {
            throw new Error("Objective text creation failed, "+objective.type+', '+objective.key);
         }
         return text;
      }
   }
}