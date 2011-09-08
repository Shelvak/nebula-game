package controllers.navigation
{
   import controllers.screens.SidebarScreens;
   
   import utils.SingletonFactory;

   public class MCSidebar extends Navigation
   {
      public static function getInstance() : MCSidebar
      {
         return SingletonFactory.getSingletonInstance(MCSidebar);
      }
      
      protected override function get defaultScreen(): String
      {
         return SidebarScreens.EMPTY;
      }
      
      public override function showScreen(name:String, unlockAfter:Boolean=true, pushToStack:Boolean=true):void
      {
         super.showScreen(name, false, pushToStack);
      }
   }
}