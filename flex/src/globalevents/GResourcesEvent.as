package globalevents
{
   public class GResourcesEvent extends GlobalEvent
   {
      public static const UPDATE: String = "update_resources";
      
      public static const RESOURCES_CHANGE: String = "resourcesAmmountChanged";
      
      //time passed from last update
      private var _timePassed: Number;
      
      public function get timePassed(): Number
      {
         return _timePassed;
      }
      
      public function GResourcesEvent(type:String, timePast: Number = 0, eagerDispatch:Boolean=true)
      {
         _timePassed = timePast;
         super(type, eagerDispatch);
      }
   }
}