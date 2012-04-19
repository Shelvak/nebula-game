package models.tips
{
   import components.base.paging.MPage;

   import flash.display.BitmapData;

   import utils.assets.AssetNames;
   import utils.loaders.ImagesLoader;
   import utils.locale.Localizer;


   public class MTip extends MPage
   {
      private var _id: int;
      private var _loader: ImagesLoader;
      private var _errorOnLoadFail: Boolean;

      public function MTip(id: int,
                           loadImage: Boolean,
                           errorOnLoadFail: Boolean = true) {
         _id = id;
         _errorOnLoadFail = errorOnLoadFail;
         if (loadImage) {
            this.loadImage();
         }
      }

      private function loadImage(): void {
         if (!loading && _image == null) {
            loading = true;
            _loader = new ImagesLoader(
               new UrlProvider(this), loader_onComplete, _errorOnLoadFail
            );
         }
      }

      private function loader_onComplete(): void {
         _image = _loader.getImage(imageUrl);
         _loader = null;
         loading = false;
      }

      private var _image: BitmapData;
      [Bindable(event="loadingChange")]
      public function get image(): BitmapData {
         loadImage();
         return _image;
      }

      public function get imageUrl(): String {
         return AssetNames.getTipImageUrl(_id);
      }

      public function get text(): String {
         return Localizer.string("Tips", "tip." + _id)
      }
   }
}

import models.tips.MTip;

import utils.loaders.IUrlProvider;


class UrlProvider implements IUrlProvider
{
   private var _tip: MTip;

   public function UrlProvider(tip: MTip) {
      _tip = tip;
   }

   public function getUrlsToLoad(): Array {
      return [_tip.imageUrl];
   }
}