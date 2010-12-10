package models.quest
{
   import utils.Localizer;
   import utils.ObjectStringsResolver;
   
   
   public class AnnexPlanet extends QuestObjective
   {
      public function AnnexPlanet()
      {
         super();
      }
      
      
      public override function get objectiveText():String
      {
         var text: String = Localizer.string('Quests', 'objectiveText.'+type, [
            Localizer.string('Quests', 'objective.'+type),
               count, (npc
               ? Localizer.string('Quests', 'npc')
               : Localizer.string('Quests', 'enemy')), 
               ObjectStringsResolver.getString('Planet', count), completed]);
         if (text == null)
         {
            throw new Error("Objective text creation failed, "+type+', Planet');
         }
         return text;
      }
      
   }
}