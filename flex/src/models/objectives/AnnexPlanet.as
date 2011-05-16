package models.objectives
{
   import utils.ObjectStringsResolver;
   import utils.locale.Localizer;
   
   
   public class AnnexPlanet extends ObjectivePart
   {
      public function AnnexPlanet(_objective: Objective)
      {
         super(_objective);
      }
      
      
      public override function get objectiveText():String
      {
         var text: String = Localizer.string('Objectives', 'objectiveText.'+objective.type, [
            objective.count, (objective.npc
               ? Localizer.string('Objectives', 'npc')
               : Localizer.string('Objectives', 'enemy')), 
            ObjectStringsResolver.getString('Planet', objective.count)]);
         if (text == null)
         {
            throw new Error("Objective text creation failed, "+objective.type+', Planet');
         }
         return text;
      }
      
   }
}