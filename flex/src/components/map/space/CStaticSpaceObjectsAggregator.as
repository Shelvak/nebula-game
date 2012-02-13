package components.map.space
{
   import flash.filters.GlowFilter;

   import models.location.LocationMinimal;
   import models.map.IMStaticSpaceObject;
   import models.map.MStaticSpaceObjectsAggregator;

   import mx.events.CollectionEvent;

   import spark.components.Group;

   import utils.Objects;


   public class CStaticSpaceObjectsAggregator extends Group
   {
      private var _staticObjectsAggregator:MStaticSpaceObjectsAggregator;
      private var _customComponentClasses:StaticObjectComponentClasses;


      public function CStaticSpaceObjectsAggregator(staticObjectsAggregator: MStaticSpaceObjectsAggregator,
                                                    customComponentClasses: StaticObjectComponentClasses) {
         super();
         mouseChildren = false;
         _customComponentClasses =
            Objects.paramNotNull("customComponentClasses",
                                 customComponentClasses);
         _staticObjectsAggregator =
            Objects.paramNotNull("staticObjectsAggregator",
                                 staticObjectsAggregator);
         _staticObjectsAggregator.addEventListener(
            CollectionEvent.COLLECTION_CHANGE,
            aggregator_collectionChangeHandler, false, 0, true
         );
         setSize();
      }

      private function setSize() : void {
         width  = _staticObjectsAggregator.componentWidth;
         height = _staticObjectsAggregator.componentHeight;
      }

      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */


      private const _components:ComponentsHash = new ComponentsHash();
      private var _selectionFilter:GlowFilter;


      protected override function createChildren() : void {
         super.createChildren();

         _selectionFilter = new GlowFilter(0xD8D800, 1.0, 24, 24);
         filters = [];

         for each (var objectType:int in _customComponentClasses.getAllObjectTypes()) {
            var component:ICStaticSpaceObject =
               new (_customComponentClasses.getMapObjectClass(objectType))();
            component.verticalCenter = 0;
            component.horizontalCenter = 0;
            component.visible = false;
            addElement(component);
            _components.add(objectType, component);
         }
      }

      private function resetComponentModels(): void {
         var component: ICStaticSpaceObject;
         for (var idx: int = 0; idx < numElements; idx++) {
            component = ICStaticSpaceObject(getElementAt(idx));
            component.staticObject = null;
            component.visible = false;
         }
         for each (var model: IMStaticSpaceObject in _staticObjectsAggregator) {
            component = _components.get(model.objectType);
            component.staticObject = model;
            component.visible = true;
         }
      }


      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */

      public function navigateTo() : void {
         _staticObjectsAggregator.navigateTo();
      }


      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */

      public function get model() : MStaticSpaceObjectsAggregator {
         return _staticObjectsAggregator;
      }

      public function get currentLocation() : LocationMinimal {
         return _staticObjectsAggregator.currentLocation;
      }

      public function get isNavigable() : Boolean {
         return _staticObjectsAggregator.isNavigable;
      }

      private var _selected:Boolean = false;
      public function set selected(value:Boolean) : void {
         if (_selected != value) {
            _selected = value;
            f_selectedChanged = true;
            invalidateProperties();
         }
      }
      public function get selected() : Boolean {
         return _selected;
      }

      private var f_selectedChanged:Boolean = true;

      protected override function commitProperties() : void {
         super.commitProperties();

         if (f_selectedChanged) {
            this.filters = _selected ? [_selectionFilter] : new Array();
         }

         if (f_staticObjectsAggregatorChanged) {
            resetComponentModels();
         }

         f_selectedChanged = false;
         f_staticObjectsAggregatorChanged = false;
      }

      public override function toString(): String {
         return "[class: " + Objects.getClassName(this)
                   + ", model: " + model
                   + ", selected: " + _selected
                   + ", visible: " + visible + "]";
      }


      /* ############################ */
      /* ### MODEL EVENT HANDLERS ### */
      /* ############################ */


      private var f_staticObjectsAggregatorChanged:Boolean = true;

      private function aggregator_collectionChangeHandler(event:CollectionEvent) : void {
         setSize();
         f_staticObjectsAggregatorChanged = true;
         invalidateProperties();
      }
   }
}


import components.map.space.ICStaticSpaceObject;

import flash.utils.Dictionary;


class ComponentsHash
{
   private const _hash:Dictionary = new Dictionary();

   public function ComponentsHash() {
   }

   public function add(type:int, component:ICStaticSpaceObject) : void {
      _hash[type] = component;
   }

   public function get(type:int) : ICStaticSpaceObject {
      return _hash[type];
   }
}