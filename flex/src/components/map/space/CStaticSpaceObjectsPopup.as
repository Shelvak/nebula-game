package components.map.space
{
   import models.IMStaticSpaceObject;
   import models.MStaticSpaceObjectsAggregator;
   import models.map.MMapSpace;
   
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   
   import spark.components.Group;
   import spark.layouts.HorizontalAlign;
   import spark.layouts.VerticalLayout;
   
   
   public class CStaticSpaceObjectsPopup extends Group
   {
      private var _customComponentClasses:StaticObjectComponentClasses;
      
      
      public function CStaticSpaceObjectsPopup(customComponentClasses:StaticObjectComponentClasses)
      {
         super();
         _customComponentClasses  = customComponentClasses;
         var layout:VerticalLayout = new VerticalLayout();
         layout.horizontalAlign = HorizontalAlign.CONTENT_JUSTIFY;
         layout.gap = 2;
         this.layout = layout;
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      private var objectTypes:Array = [MMapSpace.STATIC_OBJECT_NATURAL, MMapSpace.STATIC_OBJECT_WRECKAGE];
      
      
      protected override function createChildren() : void
      {
         super.createChildren();
         for each (var objectType:int in objectTypes)
         {
            var component:CStaticSpaceObjectInfo =
               new (_customComponentClasses.getInfoClass(objectType))();
            addElement(component);
         }
      }
      
      
      private function updateCustomComponents() : void
      {
         for (var i:int = 0; i < numElements; i++)
         {
            var objectType:int = objectTypes[i];
            var component:CStaticSpaceObjectInfo = CStaticSpaceObjectInfo(getElementAt(i));
            var object:IMStaticSpaceObject = model ? model.findObjectOfType(objectType) : null;
            component.staticObject = object;
            component.visible = object != null;
            component.includeInLayout = component.visible;
         }
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _model:MStaticSpaceObjectsAggregator;
      [Bindable]
      public function set model(value:MStaticSpaceObjectsAggregator) : void
      {
         if (_model != value)
         {
            _model = value;
            f_modelChanged = true;
            invalidateProperties();
         }
      }
      public function get model() : MStaticSpaceObjectsAggregator
      {
         return _model;
      }
      
      
      private var f_modelChanged:Boolean = true;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         
         if (f_staticObjectsAggregatorChanged || f_modelChanged)
         {
            updateCustomComponents();
         }
         
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