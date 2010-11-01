package controllers.constructionqueues
{
   import controllers.CommunicationCommand;

   /**
    * Used for queue controls.
    */  
   public class ConstructionQueuesCommand extends CommunicationCommand
   {
      public static const INDEX: String = "queueIndex";
      public static const MOVE: String = "queueMove";
      public static const REDUCE: String = "queueReduce";
      public static const SPLIT: String = "queueSplit";
      
      /**
       * Constructor. 
       */
      public function ConstructionQueuesCommand
         (type: String, parameters: Object = null, fromServer: Boolean = false)
      {
         super (type, parameters, fromServer);
      }
   }
}