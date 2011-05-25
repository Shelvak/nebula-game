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
         var classOnly: Boolean = objective.key.indexOf(
            ModelUtil.MODEL_SUBCLASS_SEPARATOR) == -1;
         var klass: String = ModelUtil.getModelClass(objective.key);
         return Localizer.string('Objectives', 'objectiveText.'+objective.type, 
            [ObjectStringsResolver.getString(classOnly ? objective.key
               : ModelUtil.getModelSubclass(objective.key), ObjectFormType.WHAT,
               objective.count), objective.level]);
      }
   }
}