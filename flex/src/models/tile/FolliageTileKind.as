package models.tile
{
   import flash.geom.Point;

   public class FolliageTileKind
   {
	   /**
		* Defines constant for folliage(3x4) tile kind.
		*/
	   public static const _3X4:int = 14;
	   
      /**
       * Defines constant for folliage(3x3) tile kind.
       */
      public static const _3X3:int = 8;
      
      /**
       * Defines constant for folliage(4x3) tile kind.
       */
      public static const _4X3:int = 9;
      
      /**
       * Defines constant for folliage(4x4) tile kind.
       */
      public static const _4X4:int = 10;
      
      /**
       * Defines constant for folliage(4x6) tile kind.
       */
      public static const _4X6:int = 11;
      
      /**
       * Defines constant for folliage(6x6) tile kind.
       */
      public static const _6X6:int = 12;
      
      /**
       * Defines constant for folliage(6x2) tile kind.
       */
      public static const _6X2:int = 13;
      
      
      /**
       * @return true if the given tile kind is a folliage tile kind,
       * false - otherwise.
       */
      public static function isFolliageKind(kind:int) : Boolean
      {
         return kind == _3X3 ||
                kind == _3X4 ||
                kind == _4X3 ||
                kind == _4X4 ||
                kind == _4X6 ||
                kind == _6X6 ||
                kind == _6X2;
      }

      /**
       * Returns the string that is equivalent to given folliage tile kind.
       * 
       * @param kind Kind of the folliage tile.
       * 
       * @return String that represents given folliage tile kind. 
       */
      public static function getName(kind:int) : String
      {
         return String(kind);
      }
      
      
      private static const SIZE_MAPPINGS:Object = {
         (String(_3X3)): new Point(3, 3),
         (String(_3X4)): new Point(3, 4),
         (String(_4X3)): new Point(4, 3),
         (String(_4X4)): new Point(4, 4),
         (String(_4X6)): new Point(4, 6),
         (String(_6X6)): new Point(6, 6),
         (String(_6X2)): new Point(6, 2)
      };
      /**
       * Retruns the size of given folliage tile kind.
       * 
       * @param kind kind of the folliage tile
       * 
       * @return size of the given folliage tile kind
       */
      public static function getSize(kind:int) : Point
      {
         return SIZE_MAPPINGS[kind];
      }
   }
}