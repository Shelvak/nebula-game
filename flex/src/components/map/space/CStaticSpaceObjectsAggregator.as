package components.map.space
{
   import models.IStaticSpaceSectorObject;
   import models.StaticSpaceObjectsAggregator;
   import models.location.LocationMinimal;
   
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.graphics.SolidColorStroke;
   
   import spark.components.Group;
   import spark.primitives.Ellipse;
   
   
   public class CStaticSpaceObjectsAggregator extends Group implements IMapSpaceObject
   {
      private var _staticObjectsAggregator:StaticSpaceObjectsAggregator;
      private var _customComponentClasses:StaticObjectComponents;
      
      
      public function CStaticSpaceObjectsAggregator(staticObjectsAggregator:StaticSpaceObjectsAggregator,
                                          customComponentClasses:StaticObjectComponents)
      {
         super();
         _staticObjectsAggregator = staticObjectsAggregator;
         width  = _staticObjectsAggregator.width;
         height = _staticObjectsAggregator.height;
         _customComponentClasses = customComponentClasses;
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      private var _selectionIndicator:Ellipse;
      
      
      protected override function createChildren() : void
      {
         super.createChildren();
         
         _selectionIndicator = new Ellipse();
         _selectionIndicator.left =
         _selectionIndicator.right = 
         _selectionIndicator.top =
         _selectionIndicator.bottom = -5;
         _selectionIndicator.visible = false;
         _selectionIndicator.alpha = 0.7;
         _selectionIndicator.stroke = new SolidColorStroke(0xD8D800, 3);
         _selectionIndicator.depth = 1000;
         addElementAt(_selectionIndicator, 0);
      }
      
      
      private function recreateCustomComponents() : void
      {
         // Leave selectionIndicator intact
         for (var i:int = 1; i < numElements; i++)
         {
            removeElementAt(i);
         }
         
         for each (var model:IStaticSpaceSectorObject in _staticObjectsAggregator)
         {
            var component:ICStaticSpaceSectorObject =
               new (_customComponentClasses.getMapObjectClass(model.objectType))();
            component.staticObject = model;
            component.verticalCenter =
            component.horizontalCenter = 0;
            addElement(component);
         }
         
         width  = _staticObjectsAggregator.width;
         height = _staticObjectsAggregator.height;
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      public function get currentLocation() : LocationMinimal
      {
         return _staticObjectsAggregator.currentLocation;
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
         return selected;
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