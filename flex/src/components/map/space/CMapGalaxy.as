package components.map.space
{
   import controllers.ui.NavigationController;
   
   import models.MStaticSpaceObjectsAggregator;
   import models.events.GalaxyEvent;
   import models.galaxy.Galaxy;
   import models.map.MMap;
   
   import spark.components.Group;
   
   
   /**
    * Galaxy map.
    */
   public class CMapGalaxy extends CMapSpace
   {
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
         classes.addComponents(MStaticSpaceObjectsAggregator.TYPE_NATURAL, CSolarSystem, CSolarSystemInfo);
         classes.addComponents(MStaticSpaceObjectsAggregator.TYPE_WRECKAGE, CWreckage, CWreckageInfo);
         return classes;
      }
      
      
      private var _fowRenderer:FOWRenderer;
      private var _fowContainer:Group;
      override protected function createBackgroundObjects(objectsContainer:Group) : void
      {
         super.createBackgroundObjects(objectsContainer);
         _fowContainer = new Group();
         _fowContainer.left =
         _fowContainer.right =
         _fowContainer.top =
         _fowContainer.bottom = 0;
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
         var g:Galaxy = Galaxy(model);
         g.removeEventListener(GalaxyEvent.RESIZE, model_resizeHandler);
         super.removeModelEventHandlers(model);
      }
      
      
      private function model_resizeHandler(event:GalaxyEvent) : void
      {
         f_galaxySizeChanged = true;
         invalidateSize();
         invalidateDisplayList();
         invalidateObjectsPosition();
      }
   }
}