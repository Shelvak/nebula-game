package models.building.events
{
   import flash.events.Event;
   
   import models.building.Building;
   
   public class BuildingEvent extends Event
   {
      /**
       * Dispached when <code>hp</code> or <code>hpMax</code> properties
       * of <code>Building</code> change. As a result of this change <code>isDamaged</code>
       * also changes.
       * 
       * @eventType buildingHpChange
       */
      public static const HP_CHANGE:String="buildingHpChange";
      
      /**
       * Dispached when current upgrade time for chosen
       * building change. As a result of this change, BildingSidebar refreshes
       * its labels.
       * 
       * @eventType buildTimeChanged
       */
      public static const BUILD_TIME_CHANGED:String="buildTimeChanged";

      
      /**
       * Dispached when <code>constructionQueryEntries</code> property
       * of <code>Building</code> change.
       * 
       * @eventType buildingQueryChange
       */
      public static const QUERY_CHANGE:String="buildingQueryChange";
      
      /**
       * Dispached when building as unit facility needs to collapse
       * 
       * @eventType facilityCollapse
       */
      public static const COLLAPSE:String="facilityCollapse";
      
      /**
       * Dispached when building as unit facility needs to expand
       * 
       * @eventType facilityExpand
       */
      public static const EXPAND:String="facilityExpand";
      
      /**
       * Dispached when building as unit facility finished it's expand
       * 
       * @eventType facilityExpandFinished
       */
      public static const EXPAND_FINISHED:String="facilityExpandFinished";
      
      /**
       * Dispached when <code>type</code> property
       * of <code>Building</code> change.
       * 
       * @eventType buildingTypeChange
       */
      public static const TYPE_CHANGE:String="buildingTypeChange";
      
      /**
      * Dispatched when <code>BuildingFacilities</code> finishes creating it's
      * elements list, building sidebar handles this event and selects first facility
      * 
      * @eventType facilitiesListCreated
      */
      public static const FACILITIES_LIST_CREATED:String="facilitiesListCreated";
      
      /**
       * Dispatched when <code>BUILDINGS|UPDATED</code> is received, <code>FacilitiesElement</code>
       * refreshes it's state on this event
       * 
       * @eventType constructionFinished
       */
      public static const CONSTRUCTION_FINISHED:String="constructionFinished";
      

      
      
      /**
       * Type alias for <code>target</code> property.  
       */      
      public function get building() : Building
      {
         return target as Building;
      }
      
      
      /**
       * Constructor. 
       */
      public function BuildingEvent(type:String)
      {
         super(type, false, false);
      }
   }
}