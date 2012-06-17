package utils.logging
{
   import mx.logging.ILogger;
   import mx.logging.ILoggingTarget;

   import utils.Objects;


   public class Log
   {
      private static const FACTORY_CACHE: Object = new Object();

      public static function getLogger(category: *): ILogger {
         return mx.logging.Log.getLogger(categoryString(Objects.paramNotNull("category", category)));
      }

      public static function categoryString(category: *): String {
         if (category is String) {
            return category;
         }
         return Objects.getClassName(category, true);
      }

      public static function getMethodLoggerFactory(category: *): IMethodLoggerFactory {
         const categoryStr: String = categoryString(Objects.paramNotNull("category", category));
         var factory: IMethodLoggerFactory = FACTORY_CACHE[categoryStr];
         if (factory == null) {
            factory = new MethodLoggerFactory(categoryStr);
            FACTORY_CACHE[categoryStr] = factory;
         }
         return factory;
      }

      public static function getMethodLogger(category: *, method: String): ILogger {
         return getMethodLoggerFactory(category).getLogger(method);
      }

      public static function addTarget(target: ILoggingTarget): void {
         mx.logging.Log.addTarget(Objects.paramNotNull("target", target));
      }

      public static function removeTarget(target: ILoggingTarget): void {
         mx.logging.Log.removeTarget(Objects.paramNotNull("target", target));
      }

      public static function hasIllegalCharacters(value: String): Boolean {
         return mx.logging.Log.hasIllegalCharacters(Objects.paramNotEmpty("value", value));
      }

      public static function flush(): void {
         mx.logging.Log.flush();
      }

      public static function isDebug(): Boolean {
         return mx.logging.Log.isDebug();
      }

      public static function isError(): Boolean {
         return mx.logging.Log.isError();
      }

      public static function isFatal(): Boolean {
         return mx.logging.Log.isFatal();
      }

      public static function isInfo(): Boolean {
         return mx.logging.Log.isInfo();
      }

      public static function isWarn(): Boolean {
         return mx.logging.Log.isWarn();
      }
   }
}


import flash.events.Event;

import mx.logging.ILogger;

import utils.Objects;

import utils.logging.IMethodLoggerFactory;
import utils.logging.Log;


class MethodLoggerFactory implements IMethodLoggerFactory
{
   private static const CACHE: Object = new Object();

   private var _category: String;

   public function MethodLoggerFactory(category: String) {
      _category = category;
   }

   public function getLogger(method: String): ILogger {
      const key: String = _category + "," + Objects.paramNotEmpty("method", method);
      var logger: ILogger = CACHE[key];
      if (logger == null) {
         logger = new MethodLogger(Log.getLogger(_category), method);
         CACHE[key] = logger;
      }
      return logger;
   }
}

class MethodLogger implements ILogger
{
   private var _logger: ILogger;
   private var _method: String;

   public function MethodLogger(logger: ILogger, method: String) {
      _logger = logger;
      _method = method;
   }

   public function get category(): String {
      return _logger.category;
   }

   private function addMethod(message: String): String {
      return "@" + _method + "():   " + message;
   }

   public function log(level: int, message: String, ... rest): void {
      _logger.log.apply(null, [level, addMethod(message)].concat(rest));
   }

   public function debug(message: String, ... rest): void {
      _logger.debug.apply(null, [addMethod(message)].concat(rest));
   }

   public function error(message: String, ... rest): void {
      _logger.error.apply(null, [addMethod(message)].concat(rest));
   }

   public function fatal(message: String, ... rest): void {
      _logger.fatal.apply(null, [addMethod(message)].concat(rest));
   }

   public function info(message: String, ... rest): void {
      _logger.info.apply(null, [addMethod(message)].concat(rest));
   }

   public function warn(message: String, ... rest): void {
      _logger.warn.apply(null, [addMethod(message)].concat(rest));
   }

   public function dispatchEvent(event: Event): Boolean {
      return _logger.dispatchEvent(event);
   }

   public function hasEventListener(type: String): Boolean {
      return _logger.hasEventListener(type);
   }

   public function willTrigger(type: String): Boolean {
      return _logger.willTrigger(type);
   }

   public function removeEventListener(
      type: String, listener: Function, useCapture: Boolean = false): void
   {
      _logger.removeEventListener(type, listener, useCapture);
   }

   public function addEventListener(
      type: String, listener: Function, useCapture: Boolean = false, priority: int = 0,
      useWeakReference: Boolean = false): void
   {
      _logger.addEventListener(type, listener, useCapture, priority, useWeakReference);
   }
}