package controllers
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import flash.events.EventDispatcher;
   
   
   /**
    * Defines static flags that alter actions of a few controllers in a row.
    */
   public final class GlobalFlags extends EventDispatcher
   {
      /**
       * Sets all flags to their default values.
       */
      public static function reset () :void
      {
         var inst:GlobalFlags = getInstance();
         inst.lockApplication = false;
      }
      
      
      /**
       * @return allways the same instance of <code>GlobalFlags</code>
       */
      public static function getInstance() : GlobalFlags
      {
         return SingletonFactory.getSingletonInstance(GlobalFlags);
      }
      
      
      [Bindable]
      /**
       * If <code>true</code> user won't be able to input anything and spinner will be shown.
       */
      public var lockApplication:Boolean = false;
   }
}