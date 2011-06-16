package components.map.space
{
   import flash.filters.GlowFilter;
   
   import models.IMStaticSpaceObject;
   import models.MStaticSpaceObjectsAggregator;
   import models.location.LocationMinimal;
   
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   
   import spark.components.Group;
   
   import utils.Objects;
   
   
   public class CStaticSpaceObjectsAggregator extends Group
   {
      private var _staticObjectsAggregator:MStaticSpaceObjectsAggregator;
      /**
       * Returns model provoded in the constructor of this class.
       */
      public function get staticObjectsAggregator() : MStaticSpaceObjectsAggregator
      {
         return _staticObjectsAggregator;
      }
      
      
      private var _customComponentClasses:StaticObjectComponentClasses;
      
      
      public function CStaticSpaceObjectsAggregator(staticObjectsAggregator:MStaticSpaceObjectsAggregator,
                                                    customComponentClasses:StaticObjectComponentClasses)
      {
         super();
         mouseChildren = false;
         _customComponentClasses = Objects.paramNotNull("customComponentClasses", customComponentClasses);
         _staticObjectsAggregator = Objects.paramNotNull("staticObjectsAggregator", staticObjectsAggregator);
         width  = _staticObjectsAggregator.componentWidth;
         height = _staticObjectsAggregator.componentHeight;
         _staticObjectsAggregator.addEventListener(CollectionEvent.COLLECTION_CHANGE,
                                                   aggregator_collectionChangeHandler);
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      private var _selectionFilter:GlowFilter;
      
      
      protected override function createChildren() : void
      {
         super.createChildren();
         _selectionFilter = new GlowFilter(0xD8D800, 1.0, 24, 24);
         filters = [];
      }
      
      
      private function recreateCustomComponents() : void
      {
         removeAllElements();
         
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
            var filters:Array = this.filters;
            if (_selected)
            {
               filters.push(_selectionFilter);
            }
            else
            {
               filters.splice(0, filters.length);
            }
            this.filters = filters;
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