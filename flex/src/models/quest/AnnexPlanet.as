package models.quest
{
   import utils.ObjectStringsResolver;
   
   [ResourceBundle ('Quests')]
   
   public class AnnexPlanet extends QuestObjective
   {
      public function AnnexPlanet()
      {
         super();
      }
      
      
      public override function get objectiveText():String
      {
         var text: String = RM.getString('Quests', 'objectiveText.'+type, [
            RM.getString('Quests', 'objective.'+type),
               count, (npc
               ? RM.getString('Quests', 'npc')
               : RM.getString('Quests', 'enemy')), 
               ObjectStringsResolver.getString('Planet', count), completed]);
         if (text == null)
         {
            throw new Error("Objective text creation failed, "+type+', Planet');
         }
         return text;
      }
      
   }
}