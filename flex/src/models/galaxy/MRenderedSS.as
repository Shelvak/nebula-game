package models.galaxy
{
   import flash.display.BitmapData;
   
   import utils.ObjectStringBuilder;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   import utils.locale.Localizer;

   
   public final class MRenderedSS extends MRenderedObjectType
   {

      public function MRenderedSS(entireGalaxy: IMEntireGalaxy, miniSSType: String) {
         super(entireGalaxy);
         _type = miniSSType;
      }

      private var _type: String;
      public function get type(): String {
         return _type;
      }

      override public function get legendText(): String {
         return getString(_type);
      }
      
      override public function get legendImage(): BitmapData {
         return ImagePreloader.getInstance().getImage(AssetNames.getMiniSSIconImageName(_type));
      }
      
      override public function equals(o: Object): Boolean {
         const another: MRenderedSS = o as MRenderedSS;
         return another != null && another._type == this._type;
      }
      
      public function toString(): String {
         return new ObjectStringBuilder(this).addProp("type").finish();
      }
   }
}