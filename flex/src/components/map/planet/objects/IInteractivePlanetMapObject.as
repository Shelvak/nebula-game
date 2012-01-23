package components.map.planet.objects
{
   import components.markers.IActiveCursorUser;


   /**
    * Interface of planet map object that responds to user interaction.
    */
   public interface IInteractivePlanetMapObject extends IPrimitivePlanetMapObject, IActiveCursorUser
   {
      /**
       * Indicates if the object is selected.
       */
      function set selected(v: Boolean): void;
      /**
       * @private
       */
      function get selected(): Boolean;

      /**
       * Indicates if this object is faded (alpha is lower that 1).
       * Set <code>alphaNormal</code> and <code>alphaFaded</code>
       * style properties to values you prefer.
       */
      function set faded(v: Boolean): void;
      /**
       * @private
       */
      function get faded(): Boolean;

      /**
       * Selects the object.
       */
      function select(): void;

      /**
       * Deselects the object.
       */
      function deselect(): void;
   }
}