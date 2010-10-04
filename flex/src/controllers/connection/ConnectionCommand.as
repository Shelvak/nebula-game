package controllers.connection
{
   import com.developmentarc.core.actions.commands.AbstractCommand;
   
   
   /**
    * Represent connection-related commands. 
    */   
   public class ConnectionCommand extends AbstractCommand
   {
      /**
       * Dispatch this command when you want to connect with the server.
       * After some time <code>CONNECTION_ESTABLISHED</code> event will
       * be dispached when client has successfully connected with the server.
       * 
       * @eventType connect
       */ 
      public static const CONNECT: String = "connect";
      
      
      
      
      /**
       * Constructor. 
       */      
      public function ConnectionCommand (type: String)
      {
         super (type);
      }
   }
}