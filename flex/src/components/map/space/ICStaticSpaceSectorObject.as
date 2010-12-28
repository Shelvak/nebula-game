package components.map.space
{
   import models.IStaticSpaceSectorObject;

   public interface ICStaticSpaceSectorObject extends IMapSpaceObject
   {
      /**
       * Model of this static space object.
       */
      function set staticObject(value:IStaticSpaceSectorObject) : void;
      /**
       * @private
       */
      function get staticObject() : IStaticSpaceSectorObject
   }
}