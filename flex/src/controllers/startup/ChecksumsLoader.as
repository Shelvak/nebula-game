package controllers.startup
{
   import flash.events.Event;
   import flash.events.EventDispatcher;

   import utils.Events;
   import utils.Objects;


   /**
    * Dispatched when both checksum files have been downloaded.
    */
   [Event(name="complete", type="flash.events.Event")]
   
   public class ChecksumsLoader extends EventDispatcher
   {
      private static const FILES_TO_LOAD:int = 3;

      private var _startupInfo:StartupInfo;
      private var _assetsLoader:ChecksumsFileLoader;
      private var _unbundledAssetsLoader:ChecksumsFileLoader;
      private var _localesLoader:ChecksumsFileLoader;
      private var _filesLoaded:int;
      
      public function ChecksumsLoader(startupInfo:StartupInfo) {
         this._startupInfo = Objects.paramNotNull("startupInfo", startupInfo);
         this._filesLoaded = 0;
      }
      
      public function load() : void {
         _unbundledAssetsLoader = new ChecksumsFileLoader(
            "assets/unbundled", unbundledAssetsChecksumsLoader
         );
         _assetsLoader = new ChecksumsFileLoader(
            "assets", assetsChecksumsLoaded
         );
         _localesLoader = new ChecksumsFileLoader(
            "locale", localesChecksumsLoaded
         );
      }
      
      private function localesChecksumsLoaded(data:Object) : void {
         _localesLoader = null;
         _startupInfo.localeSums = data;
         fileLoadComplete();
      }
      
      private function assetsChecksumsLoaded(data:Object) : void {
         _assetsLoader = null;
         _startupInfo.assetsSums = data;
         fileLoadComplete();
      }

      private function unbundledAssetsChecksumsLoader(data:Object) : void {
         _unbundledAssetsLoader = null;
         _startupInfo.unbundledAssetsSums = data;
         fileLoadComplete();
      }
      
      private function fileLoadComplete() : void {
         _filesLoaded++;
         if (_filesLoaded == FILES_TO_LOAD) {
            Events.dispatchSimpleEvent(this, Event, Event.COMPLETE);
         }
      }
   }
}


import controllers.startup.StartupInfo;

import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import utils.Objects;
import utils.StringUtil;
import utils.logging.Log;


class ChecksumsFileLoader
{
   private function get startupInfo() : StartupInfo {
      return StartupInfo.getInstance();
   }

   private var _loader: HTTPService;
   private var _resource: String;
   private var _onComplete: Function;

   public function ChecksumsFileLoader(resource: String, onComplete: Function) {
      this._resource = Objects.paramNotNull("resource", resource);
      this._onComplete = Objects.paramNotNull("onComplete", onComplete);
      this._loader = new HTTPService();
      this._loader.url = startupInfo.assetsUrl + resource + "/checksums?" + new Date().time.toString();
      this._loader.addEventListener(ResultEvent.RESULT, loader_resultHandler, false, 0, true);
      this._loader.addEventListener(FaultEvent.FAULT, loader_faultHandler, false, 0, true);
      this._loader.send();
   }

   private function loader_faultHandler(event: FaultEvent): void {
      Log.getMethodLogger(ChecksumsFileLoader, "loader_faultHandler").warn(
         "Unable to download {0} checksums file: {1} {2}",
         _resource, event.fault.faultString, event.fault.faultDetail
      );
      _onComplete.call(null, null);
   }

   private function loader_resultHandler(event: ResultEvent): void {
      _onComplete.call(null, StringUtil.parseChecksums(String(event.result)));
   }   
}