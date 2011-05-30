package ext.hamcrest.date
{
   import org.hamcrest.Matcher;
   import org.hamcrest.core.allOf;
   import org.hamcrest.date.dateAfter;
   import org.hamcrest.date.dateBefore;
   import org.hamcrest.date.dateEqual;
   
   
   /**
    * Matches if the date item falls into the range <code>(value - eps; value + eps)</code>.
    *
    * @param value Date the matched item must be equal.
    * @param eps epsilon (error tolerance in milliseconds)
    * 
    * @return Matcher
    *
    * @see org.hamcrest.date.dateEqual
    */
   public function dateEqual(value:Date, eps:Number = 1000) : Matcher
   {
      if (eps <= 0)
      {
         return org.hamcrest.date.dateEqual(value);
      }
      return allOf(
         dateAfter (new Date(value.time - eps)),
         dateBefore(new Date(value.time + eps))
      );
   }
}