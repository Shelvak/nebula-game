package components.map.controllers
{
   import components.base.viewport.Viewport;
   
   import interfaces.ICleanable;
   
   import mx.core.IVisualElement;
   import mx.core.IVisualElementContainer;

   
   public interface IMapViewportController extends IVisualElement, ICleanable
   {
      /**
       * Sets isntance of <code>Viewport</code> to be controlled by this instance of <code>IMapViewportController</code>
       * 
       * @param viewport instance of <code>Viewport</code>, can't be <code>null</code>
       */
      function setViewport(viewport:Viewport) : void;
   }
}