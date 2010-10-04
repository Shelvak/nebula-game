package utils.remote
{
   /**
    * Implement this interface if you want your action to respond to response
    * messages recieved from the server.
    */ 
	public interface IResponder
	{
		/**
		 * This method will be called when a response message has been recieved. 
		 */	   
		function result () :void;
	}
}