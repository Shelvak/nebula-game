package components.player
{
   import utils.SingletonFactory;


   public class MWaitingScreen
   {
      public static function getInstance(): MWaitingScreen {
         return SingletonFactory.getSingletonInstance(MWaitingScreen);
      }

      [Bindable]
      public var visible: Boolean = false;
   }
}
