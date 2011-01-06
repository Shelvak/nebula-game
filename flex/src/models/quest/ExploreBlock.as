package models.quest
{
   import config.Config;
   
   import utils.Localizer;
   import utils.ObjectStringsResolver;
   import utils.StringUtil;
   
   
   public class ExploreBlock extends QuestObjective
   {
      public function ExploreBlock()
      {
         super();
      }
      
      public var limit: int;
      
      
      public override function get objectiveText():String
      {
         var scientists: int = Math.round(StringUtil.evalFormula(
            Config.getValue("tiles.exploration.scientists"),
            {"width": limit, "height": 1}
         ));
         var text: String = Localizer.string('Quests', 'objectiveText.'+type, [
            Localizer.string('Quests', 'objective.'+type),
            (count > 1 ? count + ' ' : ''), ObjectStringsResolver.getString('Object', count), scientists, completed,
         count]);
         if (text == null)
         {
            throw new Error("Objective text creation failed, "+type+', count: '+count+', limit: '+limit);
         }
         return text;
      }
      
   }
}