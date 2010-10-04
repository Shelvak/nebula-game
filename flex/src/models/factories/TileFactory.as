package models.factories
{
   import models.BaseModel;
   import models.tile.Tile;
   
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
      public static function fromObject (data: Object) :Tile
      {
         if (!data)
         {
            return null;
         }
         return BaseModel.createModel (Tile, data);
      }
   }
}