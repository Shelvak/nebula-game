package controllers.planets.actions
{
   import models.planet.Planet;
   
   import utils.Objects;

   /**
    * Aggregates parameters of <code>controllers.planets.actions.EditAction</code> client command.
    * 
    * @see EditActionParams()
    * @see #planetId
    * @see #planet
    */
   public class EditActionParams
   {
      /**
       * See documentation of corresponding variables for information about parameters.
       * 
       * @see #planet
       * @see #newName
       */
      public function EditActionParams(planet:Planet, newName:String) {
         this.planet = Objects.paramNotNull("planet", planet);
         this.newName = Objects.paramNotEquals("newName", newName, [null, ""]);
      }
      
      /**
       * A planet that will be renamed.
       * <p>Not null.</p>
       */
      public var planet:Planet;
      
      /**
       * New name of a planet.
       * <p><b>Required. Not null. Not empty string.</b></p>
       */
      public var newName:String;
   }
}