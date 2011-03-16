package controllers.technologies
{
   import controllers.CommunicationCommand;
   
   
   
   
   /**
    * Used for technologies.
    */  
   public class TechnologiesCommand extends CommunicationCommand
   {
      public static const INDEX: String = "technologies|index";
      public static const NEW: String = "technologies|new";
      public static const PAUSE: String = "technologies|pause";
      public static const RESUME: String = "technologies|resume";
      public static const UPGRADE: String = "technologies|upgrade";
      public static const UPDATE: String = "technologies|update";
      public static const ACCELERATE_UPGRADE: String = "technologies|accelerate";
      
      /**
       * Constructor. 
       */
      public function TechnologiesCommand  
         (type: String, parameters: Object = null, fromServer: Boolean = false)
      {
         super (type, parameters, fromServer);
      }
   }
}