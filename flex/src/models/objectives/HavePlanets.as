package models.objectives
{
   import utils.ObjectStringsResolver;
   import utils.locale.Localizer;
   
   
   public class HavePlanets extends ObjectivePart
   {
      public function HavePlanets(_objective: Objective)
      {
         super(_objective);
      }
      
      
      public override function get objectiveText():String
      {
         var text: String = Localizer.string('Objectives', 'objectiveText.'+objective.type, [
            objective.count, ObjectStringsResolver.getString('Planet', objective.count)]);
         if (text == null)
         {
            throw new Error("Objective text creation failed, "+objective.type+', Planet');
         }
         return text;
      }
   }
}