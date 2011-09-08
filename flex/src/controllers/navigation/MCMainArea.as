package controllers.navigation
{
   import controllers.screens.MainAreaScreens;
   
   import utils.SingletonFactory;

   public class MCMainArea extends Navigation
   {
      public static function getInstance() : MCMainArea
      {
         return SingletonFactory.getSingletonInstance(MCMainArea);
      }
      
      protected override function get defaultScreen(): String
      {
         return MainAreaScreens.GALAXY;
      }
   }
}