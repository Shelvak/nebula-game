package models.objectives
{
   import utils.ModelUtil;
   import utils.ObjectFormType;
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
         var classOnly: Boolean = objective.key.indexOf(
            ModelUtil.MODEL_SUBCLASS_SEPARATOR) == -1;
         var result: String = Localizer.string('Objectives', 'objectiveText.'+objective.type, 
            [ObjectStringsResolver.getString(classOnly ? objective.key
               : ModelUtil.getModelSubclass(objective.key), ObjectFormType.WHAT,
               objective.count), objective.level]);
         if (result == null || result == '')
         {
            throw new Error('Objective '+ objective.type + ' text was not resolved');
         }
         return result;
      }
   }
}