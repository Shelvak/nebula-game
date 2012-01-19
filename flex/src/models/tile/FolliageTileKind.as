package models.tile
{
   import flash.geom.Point;

   public final class FolliageTileKind
   {
	   public static const _3X4:int = 14;
      public static const _3X3:int = 8;
      public static const _4X3:int = 9;
      public static const _4X4:int = 10;
      public static const _4X6:int = 11;
      public static const _6X6:int = 12;
      public static const _6X2:int = 13;
      
      
      /**
       * @return true if the given tile kind is a folliage tile kind,
       * false - otherwise.
       */
      public static function isFolliageKind(kind:int) : Boolean {
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
      public static function getName(kind:int) : String {
         return String(kind);
      }
      
      private static const SIZE_MAPPINGS:Object = new Object();
      SIZE_MAPPINGS[_3X3] = new Point(3, 3);
      SIZE_MAPPINGS[_3X4] = new Point(3, 4);
      SIZE_MAPPINGS[_4X3] = new Point(4, 3);
      SIZE_MAPPINGS[_4X4] = new Point(4, 4);
      SIZE_MAPPINGS[_4X6] = new Point(4, 6);
      SIZE_MAPPINGS[_6X6] = new Point(6, 6);
      SIZE_MAPPINGS[_6X2] = new Point(6, 2);
   
      /**
       * Returns the size of given foliage tile kind.
       * 
       * @param kind kind of the foliage tile
       * 
       * @return size of the given foliage tile kind
       */
      public static function getSize(kind:int) : Point {
         return SIZE_MAPPINGS[kind];
      }
   }
}