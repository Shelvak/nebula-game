package controllers.objects
{
   import controllers.CommunicationCommand;
   
   
   /**
    * Used for buildings, units, routes, quests and their progress, and queues.
    */  
   public class ObjectsCommand extends CommunicationCommand
   {
      public static const UPDATED: String = "objects|updated";
      public static const DESTROYED: String = "objects|destroyed";
      public static const CREATED: String = "objects|created";
      
      
      public function ObjectsCommand(type:String, parameters:Object = null, fromServer:Boolean = false) {
         super (type, parameters, fromServer);
      }
   }
}