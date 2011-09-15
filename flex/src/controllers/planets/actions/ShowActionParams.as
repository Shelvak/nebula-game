package controllers.planets.actions
{
   public class ShowActionParams
   {
      /**
       * Aggregates parameters of <code>controllers.planets.actions.ShowAction</code> client command.
       * 
       * @see ShowActionParams()
       * @see #planetId
       * @see #createMapOnly
       */
      public function ShowActionParams(planetId:int, createMapOnly:Boolean) {
         if (planetId <= 0)
            throw new ArgumentError("[param planetId must be greater than 0 but was " + planetId);
         this.planetId = planetId;
         this.createMapOnly = createMapOnly;
      }
      
      /**
       * Only create map (<code>true</code>) or also switch the screen (<code>false</code>)?
       * <ul><b>
       *    <li>Required.</li>
       * </b></ul>
       */
      public var createMapOnly:Boolean = false;
      
      /**
       * Id of a planet to download and create.
       * <ul><b>
       *    <li>Required.</li>
       *    <li>Greater than 0.</li>
       * </b></ul>
       */
      public var planetId:int;
   }
}