package models.objectives
{
   import controllers.objects.ObjectClass;
   
   import utils.ModelUtil;
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
         var klass: String = ModelUtil.getModelClass(objective.key);
         return (klass == ObjectClass.TECHNOLOGY
            ?(Localizer.string('Objectives', 'objectiveText.'+objective.type + '2',
               [ObjectStringsResolver.getString(
                  (objective.key.indexOf(ModelUtil.MODEL_SUBCLASS_SEPARATOR) != -1
                     ? ModelUtil.getModelSubclass(objective.key)
                     : objective.key),objective.count), objective.count, (objective.level > 1
                  ? Localizer.string('Objectives','level',[objective.level])
                  : ''),Localizer.string('Objectives', 'technology')]))
            :(Localizer.string('Objectives', 'objectiveText.'+objective.type + '1',
               [ObjectStringsResolver.getString(
                  (objective.key.indexOf(ModelUtil.MODEL_SUBCLASS_SEPARATOR) != -1
                     ? ModelUtil.getModelSubclass(objective.key)
                     : objective.key),objective.count), objective.count, (objective.level > 1
                  ? ' ' + Localizer.string('Objectives','ofLevel',[objective.level])
                  : '')]))
            );
      }
   }
}