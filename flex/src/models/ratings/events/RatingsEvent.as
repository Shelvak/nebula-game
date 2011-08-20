package models.ratings.events
{
   import flash.events.Event;
   
   public class RatingsEvent extends Event
   {
      public static const RATINGS_SCROLL: String = "ratingsScroll";
      public static const RATINGS_FILTER: String = "ratingsFilter";
      
      public function RatingsEvent(type:String)
      {
         super(type);
      }
   }
}