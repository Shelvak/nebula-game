package models.objectives
{
   import controllers.objects.ObjectClass;
   
   import utils.ModelUtil;
   import utils.ObjectFormType;
   import utils.ObjectStringsResolver;
   import utils.locale.Localizer;
   
   
   public class HaveUpgradedTo extends ObjectivePart
   {
      public function HaveUpgradedTo(_objective: Objective)
      {
         super(_objective);
      }
      
      
      public override function get objectiveText():String
      {
         var classOnly: Boolean = objective.key.indexOf(
            ModelUtil.MODEL_SUBCLASS_SEPARATOR) == -1;
         var klass: String = ModelUtil.getModelClass(objective.key);
         return Localizer.string('Objectives', 'objectiveText.'+objective.type+
            (klass != ObjectClass.TECHNOLOGY ? '' 
               : (classOnly ? 'TechClass' : 'Tech')), 
            [ObjectStringsResolver.getString(classOnly ? objective.key
               : ModelUtil.getModelSubclass(objective.key), ObjectFormType.WHAT,
               objective.count), objective.level]);
      }
   }
}