package controllers.planets.actions
{
   /**
    * Aggregates parameters of <code>controllers.planets.actions.RemoveFoliageAction</code> client command.
    * 
    * @see #RemoveFoliageActionParams()
    * @see #planetId
    * @see #foliageX
    * @see #foliageY
    */
   public class RemoveFoliageActionParams extends Object
   {
      /**
       * See documentation of corresponding variables for information about parameters.
       * 
       * @see #planetId
       * @see #foliageX
       * @see #foliageY
       */
      public function RemoveFoliageActionParams(planetId:int, foliageX:int, foliageY:int) {
         super();
         if (planetId <= 0)
            throw new ArgumentError("[param planetId] must be greater than 0 but was " + planetId);
         this.planetId = planetId;
         if (foliageX < 0)
            throw new ArgumentError("[param foliageX] must be greater than or equal to 0 but was " + foliageX);
         this.foliageX = foliageX;
         if (foliageX < 0)
            throw new ArgumentError("[param foliageY] must be greater than or equal to 0 but was " + foliageY);
         this.foliageY = foliageY;
      }
      
      /**
       * Id of a planet to remove foliage from.
       * <p><b>Required. Greater than 0.</b></p>
       */
      public var planetId:int;
      
      /**
       * X coordinate of foliage's bottom-left corner.
       * <p><b>Required. Greater than or equal to 0.</b></p>
       */
      public var foliageX:int;
      
      /**
       * Y coordinate of foliage's bottom-left corner.
       * <p><b>Required. Greater than or equal to 0.</b></p>
       */
      public var foliageY:int;
   }
}