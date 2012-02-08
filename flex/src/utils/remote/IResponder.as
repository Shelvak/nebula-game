package utils.remote
{
   import utils.remote.rmo.ClientRMO;
   import utils.remote.rmo.ServerRMO;


   /**
    * Implement this interface if you want your action to respond to response messages recieved from the
    * server.
    */ 
	public interface IResponder
	{
		/**
		 * This method will be called when a response message has been recieved and server has successfully
       * fulfilled clients request.
       * 
       * @param rmo instance of <code>ClientRMO</code> wich contains all information passed to the server
       * in a message that caused this response
		 */
		function result(rmo:ClientRMO) : void;
      
      
      /**
       * This method will be called when a response message has been received but the server could not
       * successfully fulfill clients requests and as a result all actions taken by the client app must be
       * rolled back.
       * 
       * @param rmo instance of <code>ClientRMO</code> which contains all information passed to the server
       * in a message that caused this response
       * @param srmo Server remote message object.
       */
      function cancel(rmo:ClientRMO, srmo: ServerRMO) : void;
	}
}