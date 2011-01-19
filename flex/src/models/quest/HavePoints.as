package models.quest
{
   import utils.Localizer;
   import utils.ObjectStringsResolver;

   public class HavePoints extends QuestObjective
   {
      public function HavePoints()
      {
         super();
      }
      
      public var limit: int;
      
      
      public override function get objectiveText():String
      {
         var text: String = Localizer.string('Quests', 'objectiveText.'+type, [
            Localizer.string('Quests', 'objective.'+type),
            limit, ObjectStringsResolver.getString('Point', limit), completed, count]);
         if (text == null)
         {
            throw new Error("Objective text creation failed, "+type+', Planet');
         }
         return text;
      }
      
   }
}