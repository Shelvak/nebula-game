package components.gameobjects.planet
{
   import interfaces.ICleanable;
   
   import models.planet.PlanetObject;
   
   import mx.core.IVisualElement;

   
   /**
    * Interface that is required for all objects on the map.
    * Primitive obejcts should implement this interface directly.
    */
   public interface IPrimitivePlanetMapObject extends IVisualElement, ICleanable
   {
      /**
       * Model this component represents.
       * 
       * @default null
       */
      function get model() : PlanetObject;
      
      
      /**
       * Sets model for the component. Should only be called once.
       * 
       * @param model Model that this component will represent.
       * 
       * @throws flash.errors.IllegalOperationError when this method is called second time.
       * @throws flash.errors.IllegalOperationError when <code>model</code> is null or undefined.
       */
      function initModel(model:PlanetObject) : void;
      
      
      /**
       * Sets object's <code>depth</code> property. <code>model</code> must have been set
       * before calling this method.
       */
      function setDepth() : void;
   }
}