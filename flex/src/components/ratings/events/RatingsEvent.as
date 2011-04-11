package components.ratings.events
{
   import flash.events.Event;
   
   public class RatingsEvent extends Event
   {
      public static const RATINGS_SORT: String = "ratingsSort";
      
      public var key: String;
      public function RatingsEvent(type:String, _key: String)
      {
         key = _key;
         super(type);
      }
   }
}