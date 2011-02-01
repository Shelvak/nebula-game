package components.map.space
{
   import controllers.Messenger;
   import controllers.ui.NavigationController;
   
   import models.BaseModel;
   import models.ModelLocator;
   import models.events.GalaxyEvent;
   import models.galaxy.Galaxy;
   import models.map.MMap;
   import models.map.MMapSpace;
   import models.solarsystem.SolarSystem;
   
   import spark.components.Group;
   
   import utils.Localizer;
   
   
   /**
    * Galaxy map.
    */
   public class CMapGalaxy extends CMapSpace
   {
      /**
       * Called by <code>NavigationController</code> when galaxy map screen is shown.
       */
      public static function screenShowHandler() : void
      {
         if (!ModelLocator.getInstance().latestGalaxy.canBeExplored)
         {
            Messenger.show(Localizer.string("Galaxy", "message.noRadar"), Messenger.LONG);
         }
      }
      
      
      /**
       * Called by <code>NavigationController</code> when galaxy map screen is hidden.
       */
      public static function screenHideHandler() : void
      {
         Messenger.hide();
      }
      
      
      private var NAV_CTRL:NavigationController = NavigationController.getInstance();
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      public function CMapGalaxy(model:Galaxy)
      {
         super(model);
      }
      
      
      override protected function createGrid() : Grid
      {
         return new GridGalaxy(this);
      }
      
      
      protected override function createCustomComponentClasses():StaticObjectComponentClasses
      {
         var classes:StaticObjectComponentClasses = new StaticObjectComponentClasses();
         classes.addComponents(MMapSpace.STATIC_OBJECT_NATURAL,  CSolarSystem, CSolarSystemInfo);
         classes.addComponents(MMapSpace.STATIC_OBJECT_WRECKAGE, CWreckage,    CWreckageInfo);
         return classes;
      }
      
      
      private var _fowRenderer:FOWRenderer;
      private var _fowContainer:Group;
      override protected function createBackgroundObjects(objectsContainer:Group) : void
      {
         super.createBackgroundObjects(objectsContainer);
         _fowContainer = new Group();
         with (_fowContainer)
         {
            left   = 0;
            right  = 0;
            top    = 0;
            bottom = 0;
         }
         objectsContainer.addElement(_fowContainer);
         _fowRenderer = new FOWRenderer(Galaxy(model), GridGalaxy(grid), _fowContainer.graphics);
      }
      
      
      /* ############### */
      /* ### VISUALS ### */
      /* ############### */
      
      
      private var f_galaxySizeChanged:Boolean = true;
      
      
      protected override function updateDisplayList(uw:Number, uh:Number):void
      {
         super.updateDisplayList(uw, uh);
         if (f_galaxySizeChanged)
         {
            _fowRenderer.redraw();
            f_galaxySizeChanged = false;
         }
      }
      
      
      /* ############################## */
      /* ### SOLAR SYSTEM SELECTION ### */
      /* ############################## */
      
      
      /**
       * Typed getter for <code>model</code> property.
       */
      public function getGalaxy() : Galaxy
      {
         return Galaxy(model);
      }
      
      
      protected override function selectModel(model:BaseModel) : void
      {
         if (model is SolarSystem)
         {
            super.selectModel(model);
         }
      }
      
      
      protected override function zoomObjectImpl(object:*, operationCompleteHandler:Function = null) : void
      {
         if (object is SolarSystem)
         {
            super.zoomObjectImpl(object, operationCompleteHandler);
         }
      }
      
      
      /* ############################ */
      /* ### MODEL EVENT HANDLERS ### */
      /* ############################ */
      
      
      protected override function addModelEventHandlers(model:MMap) : void
      {
         super.addModelEventHandlers(model);
         Galaxy(model).addEventListener(GalaxyEvent.RESIZE, model_resizeHandler);
      }
      
      
      protected override function removeModelEventHandlers(model:MMap) : void
      {
         Galaxy(model).removeEventListener(GalaxyEvent.RESIZE, model_resizeHandler);
         super.removeModelEventHandlers(model);
      }
      
      
      private function model_resizeHandler(event:GalaxyEvent) : void
      {
         f_galaxySizeChanged = true;
         invalidateSize();
         invalidateObjectsPosition();
         invalidateDisplayList();
      }
   }
}