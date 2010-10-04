package controllers.quests.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import models.factories.QuestFactory;
   import models.quest.Quest;
   
   import mx.collections.ArrayCollection;
   
   
   /**
    * List of all quests is received after galaxies|select.
    * 
    * <p>
    * Client <<-- Server:
    * <ul>
    *    <li>
    *       <code>quests</code> - array of generic objects that represent
    *       <code>Quests</code>
    *    </li>
    * </ul>
    * </p>
    */
   public class IndexAction extends CommunicationAction
   {
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         ML.quests.removeAll();
         for each (var quest: Object in cmd.parameters.quests)
         {
            ML.quests.addItem(QuestFactory.fromObject(quest));
         }
      }
   }
}