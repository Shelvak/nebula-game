package components.map.space.galaxy.entiregalaxy
{
   import controllers.ui.NavigationController;

   import models.galaxy.MEntireGalaxy;

   import utils.SingletonFactory;


   public class MEntireGalaxyScreen
   {
      public static function getInstance(): MEntireGalaxyScreen {
         return SingletonFactory.getSingletonInstance(MEntireGalaxyScreen);
      }

      [Bindable]
      public var model: MEntireGalaxy;

      /**
       * Just invokes <code>NavigationController.showEntireGalaxy()</code>.
       */
      public function show(): void {
         NavigationController.getInstance().showEntireGalaxy();
      }
   }
}
