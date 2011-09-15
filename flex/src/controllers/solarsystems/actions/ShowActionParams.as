package controllers.solarsystems.actions
{
   import utils.Objects;

   /**
    * Aggregates parameters of <code>controllers.solarsystems.actions.ShowAction</code> client command.
    * 
    * @see ShowActionParams()
    * @see #solarSystemId
    * @see #createMapOnly
    */
   public class ShowActionParams
   {
      /**
       * See documentation of corresponding variables for information about parameters.
       * 
       * @see #solarSystemId
       * @see #createMapOnly
       */
      public function ShowActionParams(solarSystemId:int, createMapOnly:Boolean) {
         if (solarSystemId <= 0)
            throw new ArgumentError("[param solarSystemId must be greater than 0 but was " + solarSystemId);
         this.solarSystemId = solarSystemId;
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
       * Id of a solar system to download and create.
       * <ul><b>
       *    <li>Required.</li>
       *    <li>Greater than 0.</li>
       * </b></ul>
       */
      public var solarSystemId:int;
   }
}