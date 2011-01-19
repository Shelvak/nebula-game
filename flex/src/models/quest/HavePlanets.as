package models.quest
{
   import utils.Localizer;
   import utils.ObjectStringsResolver;
   
   
   public class HavePlanets extends QuestObjective
   {
      public function HavePlanets()
      {
         super();
      }
      
      
      public override function get objectiveText():String
      {
         var text: String = Localizer.string('Quests', 'objectiveText.'+type, [
            Localizer.string('Quests', 'objective.'+type),
            count, ObjectStringsResolver.getString('Planet', count), completed]);
         if (text == null)
         {
            throw new Error("Objective text creation failed, "+type+', Planet');
         }
         return text;
      }
   }
}