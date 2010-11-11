package controllers.constructionqueues
{
   import controllers.CommunicationCommand;

   /**
    * Used for queue controls.
    */  
   public class ConstructionQueuesCommand extends CommunicationCommand
   {
      public static const INDEX:String = "construction_queues|index";
      public static const MOVE:String = "construction_queues|move";
      public static const REDUCE:String = "construction_queues|reduce";
      public static const SPLIT:String = "construction_queues|split";
      
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