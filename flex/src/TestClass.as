package
{
   import flash.utils.ByteArray;

   public class TestClass
   {
      public function TestClass(w:int, h:int, bytes:ByteArray)
      {
         this.w = w;
         this.h = h;
         this.bytes = bytes;
      }
      
      public var w:int;
      public var h:int;
      public var bytes:ByteArray;
   }
}