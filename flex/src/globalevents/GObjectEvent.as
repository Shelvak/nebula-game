package globalevents
{
   public class GObjectEvent extends GlobalEvent
   {
      public static const OBJECT_APPROVED: String = "objectApproved";
      
      public function GObjectEvent(type:String)
      {
         super(type);
      }
   }
}