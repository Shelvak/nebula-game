package controllers
{
   import com.developmentarc.core.actions.actions.AbstractAction;
   
   import models.ModelLocator;
   
   
   
   
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
   }
}