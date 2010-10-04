package models.planet
{
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   import utils.MathUtil;
   
   
   [ResourceBundle("Planets")]

   
	/**
	 * Defines properties that determines location of the planet.
	 * <p>
	 * The location of a planet is defined by two properties:
	 * <ul>
	 *   <li>
	 *      position - number of the orbit (elipce or a circle; maybe should be
	 *      renamed to orbit) the greater it is the larger the distance is
	 *      between a star and planet.
	 *   </li>
	 *   <li>
	 *      angle - measured from the X-axis in counterclockwise direction and
	 *      indicates in which place (a ray acually) planet is with respect to
	 *      X-axis.
	 *   </li>
	 * </ul>
	 * Intersection of an ellipse (position) and a ray (angle) gives a point
	 * in a solar system where the planet is located.  
	 * </p>
	 */
	[Bindable]
	public class PlanetLocation
	{
	   /**
	    * Angle that defines a ray on which a planet is located. Measured in
	    * degrees with respect to X-axis in counterclockwise direction.
	    * 
	    * @default 0 
	    */
	   public var angle: int = 0;
	   
	   
	   /**
	    * Same as <code>angle</code> just measured in radians. 
	    */	   
	   public function get angleRadians () :Number
	   {
	      return MathUtil.degreesToRadians (angle);
	   }
	   
	   
	   /**
	    * Number of the orbit. An orbit is just an ellipse (or maybe a circle)
	    * around a star of a solar system.
	    * <p><b>Should be renamed to orbit!</b></p>
	    * 
	    * @default 0 
	    */	   
	   public var position: int = 0;
      
      
      [Bindable("willNotChange")]
      /**
       * Builds and returns a string that represents planet's location. Format of this
       * string is: <code>Orbit: {position}, Angle: {angle}</code>. 
       */
      public function toString() : String
      {
         var rm:IResourceManager = ResourceManager.getInstance();
         return rm.getString("Planets", "location.position") + ": " + position + "\n" +
                rm.getString("Planets", "location.angle") + ": " + angle;
      }
	}
}