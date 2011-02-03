package components.unitsscreen
{
   import flash.display.DisplayObject;
   import flash.geom.PerspectiveProjection;
   import flash.geom.Rectangle;
   
   import models.constructionqueueentry.ConstructionQueueEntry;
   import models.unit.Unit;
   import models.unit.UnitBuildingEntry;
   
   import mx.collections.ArrayCollection;
   import mx.core.IFactory;
   import mx.core.IVisualElement;
   import mx.utils.MatrixUtil;
   
   import spark.components.DataGroup;
   import spark.components.Group;
   import spark.components.IItemRenderer;
   import spark.components.List;
   
   /**
    *  The ListItemDragProxy class defines the default drag proxy used 
    *  when dragging from a Spark List based control.
    *
    *  @langversion 3.0
    *  @playerversion Flash 10
    *  @playerversion AIR 1.5
    *  @productversion Flex 4
    */
   public class UnitsDragIndicator extends Group
   {
      
      //--------------------------------------------------------------------------
      //
      //  Constructor
      //
      //--------------------------------------------------------------------------
      
      /**
       *  Constructor.
       *  
       *  @langversion 3.0
       *  @playerversion Flash 10
       *  @playerversion AIR 1.5
       *  @productversion Flex 4
       */
      public function UnitsDragIndicator()
      {
         super();
      }
      
      //--------------------------------------------------------------------------
      //
      //  Overridden methods: UIComponent
      //
      //--------------------------------------------------------------------------
      
      /**
       *  @private
       */
      override protected function createChildren():void
      {
         super.createChildren();
         
         var list:List = owner as List;
         if (!list)
            return;
         
         var dataGroup:DataGroup = list.dataGroup;
         if (!dataGroup)
            return;
         var ammounts: Object = {};
         
         for each (var item: Unit in list.selectedItems)
         {
            if (ammounts[item.type] == null)
            {
               ammounts[item.type] = 0;
            }
            ammounts[item.type]++;
         }
         var units: ArrayCollection = new ArrayCollection();
         for (var type: String in ammounts)
         {
            units.addItem(new UnitBuildingEntry('Unit::'+type, ammounts[type]));
         }
         
         
         var indicator: DraggedUnitsIndicator = new DraggedUnitsIndicator();
         indicator.cachedUnits = units;
         var element: IVisualElement = dataGroup.getElementAt(list.selectedIndex);
         var offsetX:Number = 0;
         var offsetY:Number = 0;
         var scrollRect:Rectangle = dataGroup.scrollRect;
         if (scrollRect)
         {
            offsetX = scrollRect.x;
            offsetY = scrollRect.y;
         }
         
         indicator.setLayoutMatrix(element.getLayoutMatrix(), false);
         
         
         indicator.x = list.contentMouseX;
         indicator.y = list.contentMouseY;
         indicator.x -= offsetX;
         indicator.y -= offsetY;
         
         
         if (element.postLayoutTransformOffsets)
            indicator.postLayoutTransformOffsets = element.postLayoutTransformOffsets;
         
         addElement(indicator);
      }
      
      //--------------------------------------------------------------------------
      //
      //  Private Methods
      //
      //--------------------------------------------------------------------------
      
      // TODO (egeorgie): find a better place for this helper method.
      static private var elementBounds:Rectangle;
      /**
       *  @private
       *  Returns the bounds for the passed in element.
       */
      private function getElementBounds(element:IVisualElement):Rectangle
      {
         if (!elementBounds)
            elementBounds = new Rectangle();
         elementBounds.x = element.getLayoutBoundsX();
         elementBounds.y = element.getLayoutBoundsY();
         elementBounds.width = element.getLayoutBoundsWidth();
         elementBounds.height = element.getLayoutBoundsHeight();
         return elementBounds;
      }
      
      /**
       *  @private
       *  Clones the passed in renderer. The data item is not cloned.
       *  The clone and the original render the same item.
       */
      private function cloneItemRenderer(renderer:IItemRenderer, list:List):IItemRenderer
      {
         return null;
      }
   }
}
