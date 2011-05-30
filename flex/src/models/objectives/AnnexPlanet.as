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
         return Localizer.string('Objectives', 'objectiveText.'+objective.type+'.'+
            (objective.npc?'npc':'enemy'), [objective.count]);
      }
      
   }
}