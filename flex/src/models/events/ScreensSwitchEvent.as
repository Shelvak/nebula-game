package models.events
{
   import flash.events.Event;
   
   import mx.core.IVisualElement;
   
   public class ScreensSwitchEvent extends Event
   {
      /**
       * Dispatched when main screens container has been created
       * 
       * @eventType containerLoaded
       */
      public static const CONTAINER_LOADED:String = "containerLoaded";
      
      
      /**
       * Dispatched when destroying map elements
       * 
       * @eventType destroyMapElements
       */
      public static const DESTROY_MAP_ELEMENTS:String = "destroyMapElements";
      
      /**
       * Dispatched when switching to new map
       * 
       * @eventType mapElementsAdded
       */
      public static const MAP_ELEMENTS_ADDED:String = "mapElementsAdded";
      
      /**
       * Dispatched when currentScreen property is about to change
       * 
       * @eventType screenChanging
       */
      public static const SCREEN_CHANGING:String = "screenChanging";
      
      /**
       * Dispatched when currentScreen property changes
       * 
       * @eventType screenChanged
       */
      public static const SCREEN_CHANGED:String = "screenChanged";
      /**
       * Dispatched when screen switching operation has finished creating
       * new screen
       * 
       * @eventType newScreenCreated
       */
      public static const SCREEN_CREATED:String = "newScreenCreated";
      
      /**
       * Dispatched when screens creation complete method has ended
       * 
       * @eventType newScreenConstructionCompleted
       */      
      public static const SCREEN_CONSTRUCTION_COMPLETED:String = "newScreenConstructionCompleted";
      
      public var screenName: String;
      public var mapViewport:IVisualElement;
      public var mapController:IVisualElement;
      
      public function ScreensSwitchEvent(type:String,
                                         _screenName: String = null,
                                         mapViewport:IVisualElement = null,
                                         mapController:IVisualElement = null)
      {
         screenName = _screenName;
         this.mapViewport = mapViewport;
         this.mapController = mapController
         super(type, false, false);
      }
   }
}