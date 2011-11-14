package globalevents
{
   import models.planet.MPlanet;

   public class GPlanetEvent extends GlobalEvent
   {
      /**
       * Dispached when list of buildings in current planet changes.
       */      
      public static const BUILDINGS_CHANGE:String = "planetBuildingsChange";
      
      /**
       * Dispached when current planet changes.
       */     
      public static const PLANET_CHANGE:String = "latestPlanetChange";
      
      
      private var _planet:MPlanet;
      /**
       * Instance of <code>MPlanet</code> that caused this event to be dispatched some way.
       */      
      public function get planet() : MPlanet
      {
         return _planet;
      }
      
      /**
       * Constructor. 
       */      
      public function GPlanetEvent(type:String, p:MPlanet = null)
      {
         _planet = p;
         super(type, true);
      }
   }
}