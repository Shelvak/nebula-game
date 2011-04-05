package utils.locale
{
   import mx.resources.IResourceBundle;
   
   
   /**
    * 
    * @author MikisM
    * 
    */
   public class XMLBundle implements IResourceBundle
   {
      public function XMLBundle(locale:String, bundleName:String, content:XML)
      {
         super();
         _locale = locale;
         _bundleName = bundleName;
         _content = new XMLBundleContentProxy(content);
      }
      
      
      private var _bundleName:String;
      public function get bundleName() : String
      {
         return _bundleName;
      }
      
      
      private var _content:XMLBundleContentProxy;
      public function get content() : Object
      {
         return _content;
      }
      
      
      private var _locale:String;
      public function get locale() : String
      {
         return _locale;
      }
   }
}