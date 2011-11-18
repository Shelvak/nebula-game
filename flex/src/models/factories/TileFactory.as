package models.factories
{
   import models.tile.Tile;
   
   import utils.Objects;
   
   /**
    * Lets easily create instaces of tiles. 
    */
   public class TileFactory
   {
      /**
       * Creates a tile from a given simple object.
       *  
       * @param data An object representing a tile.
       * 
       * @return instance of <code>Tile</code> with values of properties
       * loaded from the data object.
       */
      public static function fromObject(data:Object) : Tile {
         return Objects.create(Tile, data);
      }
   }
}