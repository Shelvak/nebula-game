package models.objectives
{
   import utils.ModelUtil;
   import utils.ObjectStringsResolver;
   import utils.locale.Localizer;
   
   
   public class Destroy extends ObjectivePart
   {
      public function Destroy(_objective: Objective)
      {
         super(_objective);
      }
      
      
      public override function get objectiveText():String
      {
         return Localizer.string('Objectives', 'objectiveText.'+objective.type, 
            [ObjectStringsResolver.getString(
               (objective.key.indexOf(ModelUtil.MODEL_SUBCLASS_SEPARATOR) != -1
               ? ModelUtil.getModelSubclass(objective.key)
               : objective.key), objective.count), 
            objective.count, (objective.level > 1
               ? ' '+Localizer.string('Objectives','level',[objective.level])
               : '')]);
      }
   }
}