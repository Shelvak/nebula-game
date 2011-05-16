package models.objectives
{
   import utils.ObjectStringsResolver;
   import utils.locale.Localizer;

   public class HavePoints extends ObjectivePart
   {
      public function HavePoints(_objective: Objective)
      {
         super(_objective);
      }
      
      
      public override function get objectiveText():String
      {
         var text: String = Localizer.string('Objectives', 'objectiveText.'+objective.type, [
            objective.limit, ObjectStringsResolver.getString(
               'Point', objective.limit), objective.count]);
         if (text == null)
         {
            throw new Error("Objective text creation failed, "+objective.type+', Planet');
         }
         return text;
      }
      
   }
}