package globalevents
{
   public class GTechnologiesEvent extends GlobalEvent
   {
      public static const TECHNOLOGIES_CREATED: String = "techsCreated";
      
      public static const TECHNOLOGY_LEVEL_CHANGED: String = "techLvlChange";
      
      public function GTechnologiesEvent(type:String, eagerDispatch:Boolean=true)
      {
         super(type, eagerDispatch);
      }
   }
}