package controllers.objects
{
   import controllers.CommunicationCommand;
   
   
   
   
   /**
    * Used for buildings, units, routes, quests and their progress, and queues.
    */  
   public class ObjectsCommand extends CommunicationCommand
   {
      public static const UPDATED: String = "objectsUpdated";
      public static const DESTROYED: String = "objectsDestroyed";
      public static const CREATED: String = "objectsCreated";
      
      /**
       * Constructor. 
       */
      public function ObjectsCommand  
         (type: String, parameters: Object = null, fromServer: Boolean = false)
      {
         super (type, parameters, fromServer);
      }
   }
}