package controllers.technologies
{
   import controllers.CommunicationCommand;
   
   
   
   
   /**
    * Used for technologies.
    */  
   public class TechnologiesCommand extends CommunicationCommand
   {
      public static const INDEX: String = "technologiesIndex";
      public static const NEW: String = "technologiesNew";
      public static const PAUSE: String = "technologiesPause";
      public static const RESUME: String = "technologiesResume";
      public static const UPGRADE: String = "technologiesUpgrade";
	  public static const UPDATE: String = "technologiesUpdate";
      
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