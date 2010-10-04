package globalevents
{
   import models.planet.Planet;

   public class GPlanetEvent extends GlobalEvent
   {
      /**
       * Dispached when list of buildings in current planet changes.
       */      
      public static const BUILDINGS_CHANGE:String = "planetBuildingsChange";
      
      
      private var _planet:Planet;
      /**
       * Instance of <code>Planet</code> that caused this event to be dispatched some way. 
       */      
      public function get planet() : Planet
      {
         return _planet;
      }
      
      /**
       * Constructor. 
       */      
      public function GPlanetEvent(type:String, p:Planet, eagerDispatch:Boolean=true)
      {
         _planet = p;
         super(type, eagerDispatch);
      }
   }
}