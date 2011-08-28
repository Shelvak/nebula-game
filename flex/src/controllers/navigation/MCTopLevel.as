package controllers.navigation
{
   import controllers.screens.Screens;
   
   import utils.SingletonFactory;

   public class MCTopLevel extends Navigation
   {
      public static function getInstance() : MCTopLevel
      {
         return SingletonFactory.getSingletonInstance(MCTopLevel);
      }
      
      protected override function get defaultScreen(): String
      {
         return Screens.LOADING;
      }
   }
}