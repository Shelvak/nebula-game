package utils.assets
{
   import utils.SingletonFactory;
   
   import flash.display.BitmapData;

   
   
   
   /**
    * Holds embeded cursors used in this game.
    * 
    * <p>This class should be treaded as a singleton and instance of it should
    * be retrieved either using static method <code>getInstance()</code> or
    * using <code>utils.SingletonFactory</code>.</p>
    */
   [Bindable]
	public class Cursors
	{
      /**
       * @return instance of <code>Cursors</code> for application wide use.
       */ 
      public static function getInstance () :Cursors
      {
         return SingletonFactory.getSingletonInstance (Cursors);
      }
      
      
      public function get DEFAULT() : BitmapData
      {
         return getCursor("normal");
      }
      
      public function get OVER() : BitmapData
      {
         return getCursor("active");
      }
      
	   public function get MAP_GRIP() : BitmapData
      {
         return getCursor("dragging");
      }
      
		public function get MAP_DEFAULT() : BitmapData
      {
         return getCursor("drag");
      }
      
      
      private static function getCursor(name:String) : BitmapData
      {
         return ImagePreloader.getInstance().getImage("cursors/" + name);
      }
	}
}