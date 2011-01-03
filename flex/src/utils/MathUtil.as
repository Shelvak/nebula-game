package utils
{
   import utils.random.Rndm;

   /**
    * Defines a few usefull static methods for manipulating numbers.
    */ 
	public class MathUtil
	{
	   /**
	    * Converts angle degrees to radians.
	    * 
	    * @param value Angle in degrees
	    * 
	    * @return Same angle in radians
	    */ 
		public static function degreesToRadians(value:Number) : Number
		{
		   return value * Math.PI / 180;
		}
      
      
      /**
       * Converts angle radians to degrees.
       * 
       * @param value Angle in radians
       * 
       * @return Same angle in degrees
       */
      public static function radiansToDegrees(value:Number) : Number
      {
         return value * 180 / Math.PI;
      }
      
      
      /**
       * Returns a random number between two given bounding numbers.
       *  
       * @param lowerBound lower bound of desired range (including)
       * @param upperBound upper bound of desired range (excluding)
       * 
       * @return random number form range <code>[lowerBound; upperBound)</code>
       */      
      public static function randomBetween(lowerBound:Number, upperBound:Number) : Number
      {
         return (upperBound - lowerBound) * Math.random() + lowerBound;
      }
	}
}