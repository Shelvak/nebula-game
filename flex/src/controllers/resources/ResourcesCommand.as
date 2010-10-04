package controllers.resources
{
   import controllers.CommunicationCommand;
   
   
   /**
    * Used for updating amounts of resources.
    */  
   public class ResourcesCommand extends CommunicationCommand
   {
      /**
       * Dispatch this when you want to update resources bar with information
       * from server.
       * 
       * @eventType resourcesIndex
       */
      public static const INDEX: String = "resourcesIndex";
      
      
      public function ResourcesCommand  
         (type: String, parameters: Object = null, fromServer: Boolean = false)
      {
         super (type, parameters, fromServer);
      }
   }
}