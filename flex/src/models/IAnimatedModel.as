package models
{
   import flash.display.BitmapData;

   public interface IAnimatedModel extends IBaseModel
   {
      function get framesData() : Vector.<BitmapData>;
      function get frameWidth() : int;
      function get frameHeight() : int;
   }
}