package models.technology.events
{
   import flash.events.Event;
   
   import models.technology.Technology;
   
   public class TechnologyEvent extends Event
   {
      
      public static const UPGR_PROP_CHANGE: String = "upgradePropertyChanged";
      
      
      public static const LVL_CHANGE: String = "technologyLevelChange";
      
      public static const SELECTED_CHANGE: String = "selectedTechnologyChanged";
      
      public static const TECHNOLOGY_CREATED: String = "newTechnologyCreated";
      
      /**
       * Type alias for <code>target</code> property.  
       */      
      public function get technology() : Technology
      {
         return target as Technology;
      }
      
      
      public function TechnologyEvent(type:String)
      {
         super(type, false, false);
      }
   }
}