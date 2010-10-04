package controllers
{
   import com.developmentarc.core.actions.actions.AbstractAction;
   
   import models.ModelLocator;
   
   import mx.core.FlexGlobals;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   import spark.components.Group;
   
   
   
   
   /**
    * Extend this class if you want your action to have a property for getting
    * a <code>ModelLocator</code> instance.
    */
   public class BaseAction extends AbstractAction
   {
      /**
       * Returns <code>ModelLocator</code> instance.
       */
      protected function get ML () :ModelLocator
      {
         return ModelLocator.getInstance();
      }
      
      
      /**
       * Returns instance of <code>IResourceManager</code>.
       */
      protected function get RM () :IResourceManager
      {
         return ResourceManager.getInstance();
      }
   }
}