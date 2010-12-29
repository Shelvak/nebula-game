package components.map.space
{
   import models.IMStaticSpaceObject;
   import models.MStaticSpaceObjectsAggregator;
   import models.location.LocationMinimal;
   
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.graphics.SolidColorStroke;
   
   import spark.components.Group;
   import spark.primitives.Ellipse;
   
   
   public class CStaticSpaceObjectsAggregator extends Group
   {
      private var _staticObjectsAggregator:MStaticSpaceObjectsAggregator;
      private var _customComponentClasses:StaticObjectComponentClasses;
      
      
      public function CStaticSpaceObjectsAggregator(staticObjectsAggregator:MStaticSpaceObjectsAggregator,
                                                    customComponentClasses:StaticObjectComponentClasses)
      {
         super();
         mouseChildren = false;
         _customComponentClasses = customComponentClasses;
         _staticObjectsAggregator = staticObjectsAggregator;
         width  = _staticObjectsAggregator.componentWidth;
         height = _staticObjectsAggregator.componentHeight;
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      private var _selectionIndicator:Ellipse;
      
      
      protected override function createChildren() : void
      {
         super.createChildren();
         
         _selectionIndicator = new Ellipse();
         with (_selectionIndicator)
         {
            left    = -5;
            right   = -5;
            top     = -5;
            bottom  = -5;
            visible = false;
            alpha   = 0.7;
            stroke  = new SolidColorStroke(0xD8D800, 3);
            depth   = 1000;
         }
         addElementAt(_selectionIndicator, 0);
      }
      
      
      private function recreateCustomComponents() : void
      {
         // Leave selectionIndicator intact
         for (var i:int = 1; i < numElements; i++)
         {
            removeElementAt(i);
         }
         
         for each (var model:IMStaticSpaceObject in _staticObjectsAggregator)
         {
            var component:ICStaticSpaceObject =
               new (_customComponentClasses.getMapObjectClass(model.objectType))();
            component.staticObject = model;
            component.verticalCenter =
            component.horizontalCenter = 0;
            addElement(component);
         }
         
         width  = _staticObjectsAggregator.componentWidth;
         height = _staticObjectsAggregator.componentHeight;
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      public function navigateTo() : void
      {
         _staticObjectsAggregator.navigateTo();
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      public function get model() : MStaticSpaceObjectsAggregator
      {
         return _staticObjectsAggregator;
      }
      
      
      public function get currentLocation() : LocationMinimal
      {
         return _staticObjectsAggregator.currentLocation;
      }
      
      
      public function get isNavigable() : Boolean
      {
         return _staticObjectsAggregator.isNavigable;
      }
      
      
      private var _selected:Boolean = false;
      public function set selected(value:Boolean) : void
      {
         if (_selected != value)
         {
            _selected = value;
            f_selectedChanged = true;
            invalidateProperties();
         }
      }
      public function get selected() : Boolean
      {
         return _selected;
      }
      
      
      private var f_selectedChanged:Boolean = true;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         
         if (f_selectedChanged)
         {
            _selectionIndicator.visible = _selected;
         }
         if (f_staticObjectsAggregatorChanged)
         {
            recreateCustomComponents();
         }
         
         f_selectedChanged =
         f_staticObjectsAggregatorChanged = false;
      }
      
      
      /* ############################ */
      /* ### MODEL EVENT HANDLERS ### */
      /* ############################ */
      
      
      private var f_staticObjectsAggregatorChanged:Boolean = true;
      
      
      private function aggregator_collectionChangeHandler(event:CollectionEvent) : void
      {
         switch (event.kind)
         {
            case CollectionEventKind.ADD:
            case CollectionEventKind.REMOVE:
               f_staticObjectsAggregatorChanged = true;
               invalidateProperties();
               break;
         }
      }
   }
}