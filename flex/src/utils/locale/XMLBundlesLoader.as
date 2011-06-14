package utils.locale
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   
   import org.osmf.utils.URL;
   
   
   /**
    * Dispatched when data has been loaded successfully or when an error occured.
    */
   [Event(name="complete", type="flash.events.Event")]
   
   
   /**
    * Loads all bundles from the XML file.
    */
   public class XMLBundlesLoader extends EventDispatcher
   {
      private var _loader:URLLoader;
      private var _locale:String;
      
      
      public function XMLBundlesLoader(locale:String)
      {
         init(locale);
      }
      
      
      private var _data:XML;
      public function get data() : XML
      {
         return _data;
      }
      
      
      private var _loadSuccessful:Boolean;
      /**
       * Will be true if XML file with locale data was loaded successfully. If <code>false</code>,
       * <code>error</code> contains error information.
       */
      public function get loadSuccessful() : Boolean
      {
         return _loadSuccessful;
      }
      
      
      private var _error:String
      /**
       * Error message if loading of XML file has failed.
       */
      public function get error() : String
      {
         return _error;
      }
      
      
      private function init(locale:String) : void
      {
         _locale = locale;
         _loader = new URLLoader();
         _loader.addEventListener(Event.COMPLETE, loader_completeHandler);
         _loader.addEventListener(IOErrorEvent.IO_ERROR, loader_ioErrorHandler);
         _loader.dataFormat = URLLoaderDataFormat.TEXT;
      }
      
      
      /**
       * Call to load XML file.
       */
      public function load() : void
      {
         _loader.load(new URLRequest("locale/" + _locale + ".xml"));
      }
      
      
      private function loader_completeHandler(event:Event) : void
      {
         _data = new XML(_loader.data);
         for each (var bundleData:XML in data.children())
         {
            Localizer.addBundle(new XMLBundle(_locale, bundleData.name(), bundleData));
         }
         _loadSuccessful = true;
         dispatchCompleteEvent();
      }
      
      
      private function loader_ioErrorHandler(event:IOErrorEvent) : void
      {
         _loadSuccessful = false;
         _error = event.text;
         dispatchCompleteEvent();
      }
      
      
      private function dispatchCompleteEvent() : void
      {
         _loader.close();
         _loader = null;
         if (hasEventListener(Event.COMPLETE))
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
   }
}