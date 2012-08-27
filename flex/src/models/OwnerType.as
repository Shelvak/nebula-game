package models
{
   import flash.display.BitmapData;

   import utils.Enum;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;


   public final class OwnerType extends Enum
   {
      public static const UNDEFINED: OwnerType = new OwnerType("UNDEFINED", Owner.UNDEFINED);
      public static const PLAYER: OwnerType = new OwnerType("PLAYER", Owner.PLAYER);
      public static const ALLIANCE: OwnerType = new OwnerType("ALLIANCE", Owner.ALLY);
      public static const NAP: OwnerType = new OwnerType("NAP", Owner.NAP);
      public static const ENEMY: OwnerType = new OwnerType("ENEMY", Owner.ENEMY);
      public static const NPC: OwnerType = new OwnerType("NPC", Owner.NPC);

      public function OwnerType(name: String, value: int) {
         super(name);
         _value = value;
      }

      private var _value: int;
      /**
       * Value from <code>models.Owner<code>.
       */
      public function get value(): int {
         return _value;
      }

      /**
       * Value from <code>OwnerColor</code>.
       */
      public function get color(): uint {
         return OwnerColor.getColor(value);
      }

      /**
       * Ship icon of this type of owner. For <code>UNDEFINED</code> returns black pixel.
       */
      public function get shipIcon(): BitmapData {
         return this === UNDEFINED
            ? new BitmapData(1, 1, false, 0)
            : getIcon("Ships");
      }

      /**
       * Planet icon of this type of owner. For <code>UNDEFINED</code> returns black pixel.
       */
      public function get planetIcon(): BitmapData {
         return this === UNDEFINED
            ? new BitmapData(1, 1, false, 0)
            : getIcon("Planets");
      }

      private function getIcon(type: String): BitmapData {
         return ImagePreloader.getInstance().getImage(
            AssetNames.getSSStatusIconName(name.toLowerCase() + type)
         );
      }
   }
}
