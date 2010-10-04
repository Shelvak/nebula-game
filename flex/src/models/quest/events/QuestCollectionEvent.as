package models.quest.events
{
   import flash.events.Event;
   
   import models.quest.Quest;
   
   public class QuestCollectionEvent extends Event
   {
      /**
       * @eventType selectionChange
       * 
       * @see models.quest.QuestsCollection
       */      
      public static const SELECTION_CHANGE:String = "selectionChange";
      
      
      /**
       * @eventType countersUpdated
       * 
       * @see models.quest.QuestsCollection
       */      
      public static const COUNTERS_UPDATED:String = "countersUpdated";
      
      
      /**
       * @eventType questListUpdateCompleted
       * 
       * @see models.quest.QuestsCollection
       */      
      public static const UPDATE_COMPLETED:String = "questListUpdateCompleted";
      
      
      /**
       * @eventType filterApplied
       * 
       * @see models.quest.QuestsCollection
       */      
      public static const FILTER:String = "filterApplied";
      
      
      /**
       * Constructor.
       * 
       * @param oldQuest quest which was selected before this event has been dispached 
       * @param newQuest quest which has been selected
       */
      public function QuestCollectionEvent(type:String,
                                           oldQuest:Quest = null,
                                           newQuest:Quest = null)
      {
         super(type, false, false);
         _oldQuest = oldQuest;
         _newQuest = newQuest;
      }
      
      
      private var _oldQuest:Quest = null;
      /**
       * A quest which was selected before this event has been dispatched. <code>null</code> if there was
       * no quest selected.
       */
      public function get oldQuest() : Quest
      {
         return _oldQuest;
      }
      
      
      private var _newQuest:Quest = null;
      /**
       * A quest which has been selected when this event was dispached. <code>null</code> if no quest
       * has been selected (only <code>oldQuest</code> has been deselected).
       */
      public function get newQuest() : Quest
      {
         return _newQuest;
      }
   }
}