package utils
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   import mx.collections.ArrayCollection;

   /**
    * 
    * @author Artūras 'arturaz' Šlajus <x11@arturaz.net>
    * 
    */   
   public class SyncUtil
   {
      private static const CHECK_DELAY:int = 50;
      
      /**
       * <p>Asynchronously calls callback when property or result of a method is not 
       * null.</p>
       * 
       * <p>This can be used to ensure that component exists before operating on it.</p>
       * 
       * <p>Callback function will receive these arguments:</p>
       * <ul>
       *    <li>value of either property or method call</li>
       *    <li>any additional arguments you provided</li> 
       * </ul>
       * 
       * <p>In addition <em>this</em> in the callback will be bound to 
       * <em>host</em>.</p> 
       * 
       * <p>The value that you check can be either simple object property or result of a
       * method.</p>
       * 
       * <p>The property or the method called <strong>must be public.</strong></p>
       * 
       * <p>If you want to ensure that property is not null:</p>
       * <pre>
       * SyncUtil.waitFor(object, 'property',
       *    // Function that will be called back when the property is ready
       *    //
       *    // (object.property != null)
       *    function(property:String, name:String):void {
       *       // 'this' is bound to 'object'
       *       // we can work with object.property safely now 
       *    },
       *    // Additional arguments to pass to callback function
       *    name
       * );
       * </pre>
       * 
       * <p>If you want to ensure that result of a method call is not null:</p>
       * <pre>
       * SyncUtil.waitFor(object, [otherObject, 'methodName', arg1, arg2],
       *    // Function that will be called back when the result of the method
       *    // call is not null.
       *    //
       *    // (otherObject.methodName(arg1, arg2) != null)
       *    function(result:String, name:String):void {
       *       // 'this' is bound to 'object'
       *       // result = otherObject.methodName(arg1, arg2)
       *    },
       *    // Additional arguments to pass to callback function
       *    name
       * );
       * </pre>
       * 
       * <strong>This method is ASYNCHRONOUS!</strong>
       * 
       * <p>You <strong>cannot</strong> do something like this:</p>
       * <pre>
       *    public function doStuff():void {
       *       SyncUtil.waitFor(this, 'niceComponent', 
       *          function(component:Component):void {
       *             this.niceComponent.property = 3;
       *          }
       *       );
       *       // This would fail, because SyncUtil.waitFor will return immediately 
       *       // and this.niceComponent would still be null.
       *       this.model.value = this.niceComponent.property;
       *    }
       * </pre>
       * 
       * <p>Instead you could do it like this:</p>
       * <pre>
       *    public function doStuff():void {
       *       SyncUtil.waitFor(this, 'niceComponent', this.doStuffCallback);
       *    }
       * 
       *    public function doStuffCallback(component:Component):void {
       *       this.niceComponent.property = 3;
       *       this.model.value = this.niceComponent.property;
       *    }
       * </pre>
       * 
       * @param host 
       * @param propertyOrFunction 
       * @param callback
       * @param args
       * 
       */      
      public static function waitFor(host: Object, propertyOrFunction:*,
                                        callback: Function, ...args:Array):void {
         
        if (! callbackHandler(null, host, propertyOrFunction, callback, args)) { 
           var timer:Timer = new Timer(CHECK_DELAY);
           timer.addEventListener(TimerEvent.TIMER, function(event:TimerEvent):void {
              callbackHandler(event.target as Timer, 
                 host, propertyOrFunction, callback, args)
           });        
           timer.start();
        }
      }
      
      private static function callbackHandler(timer:Timer, host: Object, 
                                              propertyOrFunction:*,
                                              callback: Function, args:Array):Boolean
      {
         var value:*;
         if (propertyOrFunction is Array) {
            var input:Array = propertyOrFunction as Array;
            
            var methodHost:Object = input[0];
            var methodName:String = input[1];
            var methodArgs:Array = input.slice(2);
            
            value = (methodHost[methodName] as Function).apply(methodHost, methodArgs);
         }
         else {
            value = host[propertyOrFunction as String];
         }
         
         if (value != null) {
            if (timer){
               timer.stop();
            }
            
            args.unshift(value);
            callback.apply(host, args);
            return true;
         }
         else {
            return false;
         }
      }
      
      
      /**
       * Calls a function after given amount of time.
       * 
       * @param callback A function to call
       * @param delay Time in milliseconds to call the function after
       * @param thisArg see <code>Function.call()</code> or <code>Function.apply()</code>
       * @param args arguments for the function
       * 
       * @throws ArgumentError if <code>callback</code> is <code>null</code>
       * 
       * @see Function#call()
       * @see Function#apply()
       */
      public static function callLater(callback:Function, delay:uint, thisArg:* = null, ... args) : void
      {
         ClassUtil.checkIfParamNotNull("callback", callback);
         var timer:Timer = new Timer(delay, 1);
         timer.addEventListener(
            TimerEvent.TIMER_COMPLETE,
            function(event:TimerEvent) : void
            {
               callback.apply(thisArg, args as Array);
            }
         );
         timer.start();
      }
   }
}