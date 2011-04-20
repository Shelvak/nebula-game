package utils.remote
{
   import utils.SingletonFactory;
   
   
   public class ServerProxyInstance
   {
      public static function getInstance() : IServerProxy
      {
         return SingletonFactory.getSingletonInstance(ServerConnector);
      }
   }
}