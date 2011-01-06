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
      
      
      /**
       * Rounds given number to as many as <code>fractionalDigits</code> fractional digits and returns
       * rounded value. Have in mind that floating point operations are not exact and this rounding might
       * generate small errors.
       * 
       * @param value a value to be rounded
       * @param fractionalDigits how many fractional digits should be left
       * 
       * @return rounded value
       */
      public static function round(value:Number, fractionalDigits:uint) : Number
      {
         var roundingMultiplier:Number = Math.pow(10, fractionalDigits);
         return Math.round(value * roundingMultiplier) / roundingMultiplier; 
      }
	}
}