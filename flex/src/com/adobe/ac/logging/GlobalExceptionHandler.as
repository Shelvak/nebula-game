package com.adobe.ac.logging
{
    import flash.display.LoaderInfo;
    import flash.events.IEventDispatcher;
    
    import mx.managers.ISystemManager;
    
    import org.osmf.events.LoaderEvent;

    [Mixin]
    [DefaultProperty("handlerActions")]
    public class GlobalExceptionHandler
    {
        private static var loaderInfo:LoaderInfo;

        [ArrayElementType("com.adobe.ac.logging.GlobalExceptionHandlerAction")]
        public var handlerActions:Array;

        public var preventDefault:Boolean;

        public static function init(sm:ISystemManager):void
        {
            loaderInfo = sm.loaderInfo;
        }

        public function GlobalExceptionHandler()
        {
           if (loaderInfo.hasOwnProperty("uncaughtErrorEvents")){
            IEventDispatcher(loaderInfo["uncaughtErrorEvents"]).addEventListener('uncaughtError',
                                                            uncaughtErrorHandler);
           }
        }

        private function uncaughtErrorHandler(event:*):void
        {
            for each (var action:GlobalExceptionHandlerAction in handlerActions)
            {
                action.handle(event.error);
            }

            if (preventDefault == true)
            {
                event.preventDefault();
            }
        }
    }
}