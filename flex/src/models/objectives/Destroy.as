package models.objectives
{
   import utils.ModelUtil;
   import utils.StringUtil;
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
         var result: String = Localizer.string('Objectives', 'objectiveText.'+objective.type, 
            [
               objective.count, 
               (classOnly ? objective.key : StringUtil.replaceClassSeperator(objective.key)), 
               objective.level
            ]);
         if (result == null || result == '')
         {
            throw new Error('Objective '+ objective.type + ' text was not resolved');
         }
         return result;
      }
   }
}