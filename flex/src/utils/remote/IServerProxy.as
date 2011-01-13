package utils.remote
{
   import utils.remote.rmo.ClientRMO;
   import utils.remote.rmo.ServerRMO;
   
   
   public interface IServerProxy
   {
      /**
       * Tries to connect to the server.
       */
      function connect() : void;
      
      
      /**
       * Sends a message to the server.
       */
      function sendMessage(rmo:ClientRMO) : void;
      
      
      /**
       * Indicates if a proxy is connected to the server.
       */
      function get connected() : Boolean;
      
      
      /**
       * List of last messages sent to and received form the server.
       */
      function get communicationHistory() : Vector.<String>;
      
      
      /**
       * Returns messages received from the server that have not been processed yet. Clears internal list
       * that was used for holding those messages. You get a copy of that list first.
       */
      function getUnprocessedMessages() : Vector.<ServerRMO>;
   }
}