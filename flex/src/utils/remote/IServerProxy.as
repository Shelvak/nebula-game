package utils.remote
{
   import utils.remote.rmo.ClientRMO;
   
   
   public interface IServerProxy
   {
      function get connected() : Boolean;
      function connect() : void;
      function get communicationHistory() : Vector.<String>;
      function sendMessage(rmo:ClientRMO) : void;
   }
}