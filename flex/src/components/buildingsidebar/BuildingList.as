package components.buildingsidebar
{
   import com.developmentarc.core.utils.EventBroker;
   
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   
   import globalevents.GSelectConstructableEvent;
   
   import models.building.Building;
   import models.building.MCSidebarBuilding;
   import models.factories.BuildingFactory;
   
   import mx.collections.ArrayCollection;
   import mx.core.ClassFactory;
   import mx.events.CollectionEvent;
   
   import spark.components.List;
   import spark.layouts.TileLayout;
   
   public class BuildingList extends List
   {
      public function BuildingList()
      {
         super();
         EventBroker.subscribe(KeyboardEvent.KEY_DOWN, handleKeyDown);
         addEventListener(MouseEvent.MOUSE_DOWN, changeHandler);
         miniML = new ArrayCollection();
         dataProvider = miniML;
         itemRenderer = new ClassFactory(BuildingElement);
         var listLayout: TileLayout = new TileLayout();
         listLayout.requestedColumnCount = 2;
         layout = listLayout;
      }
      
      public function toggleToDemo(apply: Boolean):void
      {
         for each(var element: MCSidebarBuilding in miniML)
         {
            if (element != null)
               if (element.demo != apply)
               {
                  element.demo = apply;
               }
         }
      }
      
      public function refreshBuildingsStates(constructing: Boolean = false, deploying: Boolean = false):void
      {
         for each(var element: MCSidebarBuilding in miniML)
         {
            element.constructing = constructing;
            element.refresh();
         }
         if (!constructing)
         {
            var selElement: Object = selectedItem;
            if (selElement == null || selElement.disabled)
            {
               if (selElement == null && !deploying)
                  deselectBuilding();
               else
               {
                  if (constructionActive)
                  {
                     new GSelectConstructableEvent(null); 
                     constructionActive = false;
                  }
               }
            }
         }
      }
      
      private function getByType(type: String): Object
      {
         for each (var element: MCSidebarBuilding in miniML)
         { 
            if (element.type == type)
            {
               return element;
            }
         }
         return null;
      }
      
      private function changeSelectedByType(selType: String): void
      {
         selectedItem = getByType(selType);
         selectedIndex = miniML.getItemIndex(selectedItem);
         changeHandler();
      }
      
      public function deselectBuilding(): void
      {
         selectedIndex = undefined;
         selectedItem = null;
         changeHandler();
         if (!moving)
         {
            new GSelectConstructableEvent(null);
         }
      }
      
      
      private function handleKeyDown(e:KeyboardEvent):void{
         if (e.keyCode == 27)
         {
            if (moving)
            {
               moving = false;
            }
            deselectBuilding();
         }
      }
      
      private function changeHandler(e: MouseEvent = null): void
      {
         if (!dontDispatch)
         {
            if (selectedItem != null)
            {
               var element: MCSidebarBuilding = selectedItem;
               if ((!element.disabled) && (!element.demo))
               {
                  var b:Building = BuildingFactory.createDefault(element.type);
                  b.cleanup();
                  new GSelectConstructableEvent(b);
                  constructionActive = true;
               }
               else
               {
                  new GSelectConstructableEvent(null);
                  dispatchEvent(
                     new DemoChangedEvent(DemoChangedEvent.DEMO_SELECTION_CHANGED, element.type));
                  constructionActive = false;
               }
            }
            else
            {
               // new GSelectConstructableEvent(null); 
               constructionActive = false;
            }
         }
      }
      
      private var constructionActive: Boolean = false;
      
      public var moving: Boolean = false;
      
      public function buildGalleryGrid(e: Event = null):void {
         dontDispatch = true;
         if (_constructableTypes != null)
         {
            miniML.removeAll();
            for each (var building: String in _constructableTypes)
            {
               var element:MCSidebarBuilding = new MCSidebarBuilding(building);
               miniML.addItem(element);
            }
         }
         dontDispatch = false;
         constructionActive = false;
      }
      
      [Bindable]
      public var miniML:ArrayCollection; 
      
      
      private var _constructableTypes: ArrayCollection;
      
      public function set constructableTypes(value: ArrayCollection): void
      {
         if (_constructableTypes != null)
            _constructableTypes.removeEventListener(CollectionEvent.COLLECTION_CHANGE, buildGalleryGrid);
         
         var oldSelectedBuilding: MCSidebarBuilding = selectedItem;
         _constructableTypes = value;
         
         if (_constructableTypes != null)
            _constructableTypes.addEventListener(CollectionEvent.COLLECTION_CHANGE, buildGalleryGrid);
         
         buildGalleryGrid();
         if (oldSelectedBuilding != null)
            changeSelectedByType(oldSelectedBuilding.type);
      }
      
      private var dontDispatch: Boolean = false;
   }
}