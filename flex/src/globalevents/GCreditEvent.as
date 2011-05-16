package globalevents
{
   public class GCreditEvent extends GlobalEvent
   {
      public static const ACCELERATE_CONFIRMED: String = 'accelerate_confirmed';
      public static const BOOST_CONFIRMED: String = 'boost_confirmed';
      
      public function GCreditEvent(type:String)
      {
         super(type);
      }
   }
}