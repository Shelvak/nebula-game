package models.quest
{
   import utils.ObjectStringsResolver;
   
   [ResourceBundle ('Quests')]
   
   public class UpgradeTo extends QuestObjective
   {
      public function UpgradeTo()
      {
         super();
      }
      
      
      public override function get objectiveText():String
      {
         var text: String = RM.getString('Quests', 'objectiveText.'+type, [RM.getString('Quests', (level == 1
            ? 'objectiveLvl1.'
            : 'objectiveLvl2.')+type), 
            ObjectStringsResolver.getString(key.split('::')[1],count), count, completed, (level > 1
               ? ' '+RM.getString('Quests','toLevel',[level])
               : '')]);
         if (text == null)
         {
            throw new Error("Objective text creation failed, "+type+', '+key);
         }
         return text;
      }
   }
}