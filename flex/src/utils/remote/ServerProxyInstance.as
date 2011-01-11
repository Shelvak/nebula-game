package utils.remote
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import utils.remote.proxy.ClientProxy;
   
   public class ServerProxyInstance
   {
      private static const DEBUG_MODE:Boolean = false;
      public static function getInstance() : IServerProxy
      {
         if (DEBUG_MODE)
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