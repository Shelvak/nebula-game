package globalevents
{
   public class GResourcesEvent extends GlobalEvent
   {
      public static const RESOURCES_CHANGE: String = "resourcesAmmountChanged";
      
      public static const WRECKAGES_UPDATED: String = "wreckagesUpdated";

      /* if any of resources increased */
      public var someIncreased: Boolean;
      /* if any of resources decreased */
      public var someDecreased: Boolean;
      
      public function GResourcesEvent(type:String,
                                      increased: Boolean = false,
                                      decreased: Boolean = false,
                                      eagerDispatch:Boolean=true)
      {
         someIncreased = increased;
         someDecreased = decreased;
         super(type, eagerDispatch);
      }
   }
}