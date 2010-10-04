package globalevents
{
   public class GQuestEvent extends GlobalEvent
   {
      public static const CLAIM_APROVED: String = "claimRevardsAproved";
      
      public function GQuestEvent(type:String)
      {
         super(type);
      }
   }
}