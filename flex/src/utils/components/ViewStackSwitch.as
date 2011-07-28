package utils.components
{
   import controllers.screens.ScreensSwitch;
   
   import flash.errors.IllegalOperationError;
   import flash.events.EventDispatcher;
   
   import models.events.ScreensSwitchEvent;
   
   import mx.containers.ViewStack;
   import mx.core.INavigatorContent;
   
   import spark.components.NavigatorContent;
   
   import utils.SyncUtil;
   
   
   /**
    * Utility class for manipulating <code>ViewStack</code> components:
    * provides convenient way to switch between different containers in a
    * <code>ViewStack</code>.
    * <p>
    * In order to easily reach instance of <code>ViewStackSwitch</code> bound with
    * particular <code>ViewStack</code> extend <code>ViewStackSwitch</code> and make your
    * class a singleton: implement <code>getInstance()</code> method.
    * </p>
    * <p>
    * Requirements for the <code>ViewStack</code> instance:
    * <ul>
    *    <li>All screens' <code>name</code>s must be prefixed with the string contained by
    *        <code>screenPrefix</code> config option</li>
    *    <li>Default screen must be present in the <code>ViewStack</code> and name must be
    *        exact match of the string value contained by <code>screenPrefix</code> config
    *        option</li>
    *    <li>Format of <code>name</code> property value of each screen in the
    *        <code>ViewStack</code> should be: <code>{screenPrefix}{screenName}</code>. For
    *        example: <code>name</code> of default screen (with default configuration of
    *        <code>ViewStackSwitch</code>) must be "cnvDefault".</li>
    * </ul>
    * Note that you can change configuration <strong>once</strong> with
    * <code>setConfig()</code> method. See documentation of this method for more information
    * on configuring instance of <code>ViewStackSwitch</code>.
    * </p>
    */
   public class ViewStackSwitch extends EventDispatcher
   {
      /**
       * Indicates if custom configuration has been set.
       * 
       * @default false 
       */      
      protected var fConfigSet: Boolean = false;
      /**
       * Indicates if <code>ViewStackInstance</code> has been set.
       * 
       * @default false 
       */      
      protected var fViewStackSet: Boolean = false;
      
      
      /**
       * Name of default screen.
       * 
       * @default Default 
       */      
      protected var defaultScreenName: String = "Default";
      /**
       * Name of screen currently displayed by the <code>ViewStack</code>.
       * 
       * @default null
       */
      protected var currentName: String = null;
      /**
       * Name of screen currently displayed by the <code>ViewStack</code>.
       * 
       * @default null
       */
      public function get currentScreenName() : String
      {
         return currentName;
      }
      
      
      /**
       * Instance of <code>NavigatorContent</code> currently visible. 
       */
      public function get currentScreenContent() : NavigatorContent
      {
         return viewStack.getChildByName(currentName) as NavigatorContent;
      }
      
      
      /**
       * Instance of <code>ViewStack</code> bound to this <code>ViewStackSwitch</code>. 
       */      
      public var viewStack: ViewStack = null
      
      
      /**
       * Sets configuration of this <code>ViewStackSwitch</code>.
       * <p>
       * This method can be invoked only once.
       * </p>
       * 
       * @param options Object containing configuration properties which can be:
       * <ul>
       *    <li><code>defaultScreenName</code> - name of default screen in the
       *        <code>ViewStack</code> (string; default - "<code>Default</code>")</li> 
       * </ul>
       * Note that not all configuration options have to be defined but the ones that are
       * must be of correct type and value.
       * 
       * @throws flash.errors.IllegalOperationError when this method is invoked after
       * configuration has already been set
       */      
      public function setConfig(options:Object) : void
      {
         if (fConfigSet)
            throw new IllegalOperationError("Configuration has already been set.");
         
         if (options.defaultScreenName != void)
            defaultScreenName = options.defaultScreenName as String;
         
         fConfigSet = true;
      }
      
      
      /**
       * Bounds (sets) the given <code>ViewStack</code> to this <code>ViewStackSwitch</code>.
       *  
       * @param vs Instance of <code>ViewStack</code> to be bound (not null)
       * 
       */      
      public function setViewStack(vs:ViewStack) : void
      {
         if (fViewStackSet)
            throw new IllegalOperationError("ViewStack has already been set.");
         
         if (vs == null)
            throw new ArgumentError("vs must be a valid instance of ViewStack.");
         
         viewStack = vs;
         
         fViewStackSet = true;
      }
      
      
      /**
       * Shows default screen(container) of the bound <code>ViewStack</code>. You must set
       * the <code>ViewStack</code> before calling this method.
       */      
      public function showDefaultScreen() : void
      {
         showScreen(defaultScreenName);
      }
      
      
      /**
       * Shows a screen with the given name.
       * 
       * @param name Name of the screen to show <strong>without</strong> prefix.
       */
      public function showScreen(name:String, unlockAfter: Boolean = true) : void
      {
         currentName = name;
         SyncUtil.waitFor(this, 'viewStack', 
            function(viewStack:ViewStack, name:String):void {
               
               SyncUtil.waitFor(this, [viewStack, 'getChildByName', name],
                  function(child:INavigatorContent):void {
                     viewStack.selectedChild = child;
                     this.dispatchEvent(new ScreensSwitchEvent(ScreensSwitchEvent.SCREEN_CREATED));
                  }
               );
            },
            name
         );
      }
   }
}