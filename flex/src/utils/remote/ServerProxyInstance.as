package utils.remote
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import controllers.startup.StartupManager;
   
   import utils.remote.proxy.ClientProxy;
   
   
   public class ServerProxyInstance
   {
      public static function getInstance() : IServerProxy
      {
         if (StartupManager.DEBUG_MODE)
         {
            return SingletonFactory.getSingletonInstance(ServerConnector);
         }
         else
         {
            return SingletonFactory.getSingletonInstance(ClientProxy);
         }
      }
   }
}