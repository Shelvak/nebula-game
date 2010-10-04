package globalevents
{
   public class GObjectEvent extends GlobalEvent
   {
      public static const OBJECT_APROVED: String = "objectAproved";
      
      public function GObjectEvent(type:String)
      {
         super(type);
      }
   }
}