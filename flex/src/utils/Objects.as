package utils
{
   import flash.errors.IllegalOperationError;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   import mx.collections.ArrayCollection;
   

   /**
    * Has a bunch of methods for working with objects and classes. 
    */
   public class Objects
   {
      /* ############# */
      /* ### CLASS ### */
      /* ############# */
      
      /**
       * Use this to retrieve <code>Class</code> object from the given instance.
       * 
       * @param instance an instance of some class you wan't to retrieve it from.
       * Can't be <code>null</code> or instance of <code>Class</code>.
       * 
       * @return class object of a given instance
       * 
       * @throws ArgumentError if <code>instance</code> is <code>null</code>, is of
       * <code>Class</code> type or is of <code>Function</code> type.
       */
      public static function getClass(instance:Object) : Class {
         paramNotNull("instance", instance);
         if (instance is Class || instance is Function)
            throw new ArgumentError("[param instance] can't be of type [class Class] or " +
                                    "[class Function]");
         return Class(getDefinitionByName(getQualifiedClassName(instance)));
      }
      
      /**
       * Creates new object of the same type as the given instance. A class of the given
       * instance must have no-args constructor for this method to work.
       * 
       * @param instance an object of some class you want to get new instance of.
       * Can't be <code>null</code> or instance of <code>Class</code>.
       * 
       * @return new instance of the same type as the given instance
       * 
       * @throws ArgumentError if <code>instance</code> is <code>null</code> or is of
       * <code>Class</code> type
       */
      public static function getInstance(instance:Object) : * {
         return new (getClass(instance))();
      }
      
      /**
       * Returns the fully qualified class name of a given object.
       * 
       * @param replaceColons if <code>true</code>, will replace the two colons that separate package
       * from class name with a dot (.) symbol.
       */
      public static function getClassName(o:Object, replaceColons:Boolean = false) : String {
         var className:String = getQualifiedClassName(o);
         if (replaceColons)
            className = className.replace("::", ".");
         return className;
      }
      
      /**
       * Returns the class name (without package) of a given object. This is a shorcut method for
       * <code>toSimpleClassName(getClassName(o))</code>.
       */
      public static function getClassNameSimple(o:Object) : String {
         return toSimpleClassName(getClassName(o));
      }
      
      /**
       * Strips package part from full class name and leaves only the name itself.
       * 
       * @param className fully qualified class name or simple class name
       * 
       * @return simple class name without package
       * 
       * @throws ArgumentError if given [param className] is illegal name of a class
       */
      public static function toSimpleClassName(className:String) : String {
         if (className == null || className.length == 0)
            throwIllegalClassNameError(className);
         var indexColon:int = className.lastIndexOf(":");
         var indexPoint:int = className.lastIndexOf(".");
         if (indexColon == -1 && indexPoint == -1)
            return className;
         if (indexColon == className.length - 1 ||
            indexColon != -1 && indexColon < indexPoint)
            throwIllegalClassNameError(className);
         return className.substring(indexColon + 1);
      }
      
      /**
       * Lets you find out if a given class has got a given metadata tag.
       * This method uses ActionScript reflection feature.
       * 
       * @param value a Class to be examined
       * @param tag Name of metadata tag
       * 
       * @return <code>true</code> if the given class has a given metadata tag defined or <code>false</code>
       * otherwise.
       */
      public static function hasMetadata(type:Class, tag:String) : Boolean {
         if (type == null)
            return false;
         var typeData:XML = describeType(type).factory[0];
         if (typeData.metadata.(@name == tag)[0] != null)
            return true;
         else
            return false;
      }
      
      /**
       * Returns array all public properties of a given type.
       *  
       * @param type a class you want to introspect
       * @param writeOnly If <code>true</code> only writable properties will be returned
       * 
       * @return Array of properties that are defined either as variables or setter/getter pairs.
       */      
      public static function getPublicProperties(type:Class, writeOnly:Boolean=true) : Array {
         var result:Array = [];
         var info:XML = describeType(type).factory[0];
         for each (var prop:XML in info.accessor) {
            if (!writeOnly || prop.@access != "readonly")
               result.push(prop.@name.toString());
         }
         for each (prop in info.variable) {
            result.push(prop.@name.toString())
         }
         return result;
      }
      
      
      /* ############### */
      /* ### STATICS ### */
      
      /**
       * For each public static variable/property/constant calls the given callback
       * function and passes <strong>value</strong> of that static.
       * 
       * <p>This is an alias method for
       * <code>ClassUtil.forEachStatic(CLASS,type,<strong>false</strong>,callback)</code></p>
       * 
       * @param CLASS a class that will be examined.
       * @param type type Type of the static property. Use values from
       * <code>ClassPropertyType</code>.
       * @param callback A function that will be called for each static.
       * 
       * @see #forEachStatic()
       */
      public static function forEachStaticValue(CLASS:Class,
                                                type:int,
                                                callback:Function,
                                                exclusions:Array = null) : void {
         forEachStatic(CLASS, type, false, callback, exclusions);
      }
      
      /**
       * For each public static variable/property/constant calls the given callback
       * function and passes <strong>name</strong> of that static.
       *
       * <p>This is an alias method for
       * <code>ClassUtil.forEachStatic(CLASS,type,<strong>true</strong>,callback)</code></p> 
       * 
       * @param CLASS a class that will be examined.
       * @param type type Type of the static property. Use values from
       * <code>ClassPropertyType</code>.
       * @param callback A function that will be called for each static.
       * @param exclusions Array of statics' names to exclude.
       * 
       * @see #forEachStatic()
       */
      public static function forEachStaticName(CLASS:Class,
                                               type:int,
                                               callback:Function,
                                               exclusions:Array = null) : void {
         forEachStatic(CLASS, type, true, callback, exclusions);
      }
      
      /**
       * For each public static variable/property/constant (determined by
       * <code>type</code>) calls the given callback function.
       * 
       * @param CLASS a class that will be examined.
       * @param type Type of the static property. Use values from
       * <code>ClassPropertyType</code>.
       * @param name If <code>true</code>, name of the static will be passed to the
       * callback function, if <code>false</code> value of the static will
       * be passed instead.
       * @param callback A function that will be called for each static.
       * Following formats of callback function are legal:
       * <ul>
       *    <li><code>function(name:String)</code> - if <code>name</code> is
       *        <code>true</code>;</li>
       *    <li><code>function(value:&#8727;)</code> - if <code>name</code> is
       *        <code>true</code> or <code>false</code></li>;
       * </ul>
       * @param exclusions Array of statics' names to exclude.
       */
      public static function forEachStatic(CLASS:Class,
                                           type:int,
                                           name:Boolean,
                                           callback:Function,
                                           exclusions:Array = null) : void {
         var loopVar:Boolean = false;
         var loopConst:Boolean = false;
         var loopAccess:Boolean = false;
         
         switch(type)
         {
            case ObjectPropertyType.STATIC_CONST:
               loopConst = true;
               break;
            
            case ObjectPropertyType.STATIC_PROP:
               loopAccess = true;
               break;
            
            case ObjectPropertyType.STATIC_VAR:
               loopVar = true;
               break;
            
            case ObjectPropertyType.STATIC_ANY:
               loopVar = true;
               loopConst = true;
               loopAccess = true;
               break;
         }
         
         var classData:XML = describeType(CLASS);
         var excl:ArrayCollection = new ArrayCollection(exclusions);
         var helper:Function = function(propType:String) : void {
            loopThroughStatics(CLASS, classData[propType], name, callback, excl)
         }
         if (loopAccess) helper("accessor");
         if (loopConst) helper("constant");
         if (loopVar) helper("variable");
      }
      
      private static function loopThroughStatics(CLASS:Class,
                                                 data:XMLList,
                                                 name:Boolean,
                                                 callback:Function,
                                                 exclusions:ArrayCollection) : void {
         for each (var prop:XML in data) {
            if (! exclusions.contains(prop.@name.toString())) {
               if (name) callback(prop.@name)
               else callback(CLASS[prop.@name])
            }
         }
      }
      
      
      /* ############## */
      /* ### OBJECT ### */
      /* ############## */
      
      /**
       * Extracts all properties starting with given prefix to a new object and reruns that object.
       * Of no properties are found, the object returned will also have no properties.
       * 
       * <p>This method loops through all dynamic properties of the source object so it take time
       * to extract properties from large objects.</p>
       * 
       * @param prefix <b>Not null. Not empty string.</b>
       * @param source source object that holds properties.
       *        <b>Not null. Generic object only.</b>
       */
      public static function extractPropsWithPrefix(prefix:String, source:Object) : Object {
         paramNotNull("source", source);
         paramNotEquals("prefix", prefix, [null, ""]);
         var result:Object = new Object();
         for (var prop:String in source) {
            if (prop.length > prefix.length && prop.indexOf(prefix) == 0)
               result[StringUtil.firstToLowerCase(prop.substr(prefix.length))] = source[prop];
         }
         return result;
      }
      
      /**
       * @return true if obj has any keys, false otherwise
       */
      public static function hasAnyProperty(obj: Object): Boolean {
         for (var key:String in obj) {
            return true;
         }
         return false;
      }
      
      
      /* ############################ */
      /* ### FAIL-FAST ASSERTIONS ### */
      /* ############################ */
      
      /**
       * Checks if <code>paramValue</code> is <code>null</code> or <code>undefined</code>. If this is
       * case, throws <code>ArgumentError</code> error.
       * 
       * @param paramName name of a <code>paramValue</code> object in a context where this method is called
       * @param paramValue object to check
       * 
       * @return <code>paramValue</code>
       * 
       * @throws ArgumentError if <code>paramValue</code> is <code>null</code>
       * 
       * @see #paramNotEquals()
       */
      public static function paramNotNull(paramName:String, paramValue:Object) : * {
         return paramNotEquals(paramName, paramValue, [null, undefined]);
      }
      
      /**
       * Checks if <code>paramValue</code> is not equal to any of given restricted values. If it is equal at
       * least to one of them, throws <code>ArgumentError</code> error. Operator <code>===</code> is used for
       * comparision.
       * 
       * <p>Format of the error message is: "[param &lt;paramName&gt;] can't be equal to
       * &lt;restrictedValues&gt; but was equal to &lt;paramValue&gt;".
       * </p>
       * 
       * @param paramName name of a <code>paramValue</code> object in a context where this method is called
       * @param paramValue actual parameter value
       * @param restrictedValues values which are illegal for <code>paramValue</code>
       * 
       * @return <code>paramValue</code>
       * 
       * @throws ArgumentError if <code>paramValue</code> equals to one of values in
       * <code>restrictedValues</code>
       */
      public static function paramNotEquals(paramName:String, paramValue:Object, restrictedValues:Array) : * {
         for each (var value:* in restrictedValues) {
            if (paramValue === value)
               throw new ArgumentError(
                  "[param " + paramName + "] can't be equal to " + arrayJoin(restrictedValues, ", ") +
                  " but was equal to " + paramValue
               );
         }
         
         return paramValue;
      }
      
      /**
       * Does the same as <code>paramNotNull</code> just allows you to specify a custom error message.
       */
      public static function notNull(value:Object, errorMessage:String) : * {
         return notEquals(value, [null, undefined], errorMessage);
      }
      
      /**
       * Does the same as <code>paramNotEquals</code> just allows you to specify a custom error message.
       */
      public static function notEquals(value:Object, restrictedValues:Array, errorMessage:String) : * {
         for each (var val:* in restrictedValues) {
            if (value === val)
               throw new Error(errorMessage);
         }
         return value;
      }
      
      /**
       * Checks if <code>paramValue</code> is greater than (or equal to, if <code>allowLow</code> is
       * <code>true</code>) <code>low</code>.
       * 
       * @return <code>paramValue</code>
       */
      public static function paramGreaterThanNumber(paramName:String,
                                                    low:Number,
                                                    paramValue:Number,
                                                    allowLow:Boolean = false) : Number {
         var errorMessage:String = null; 
         if (allowLow) {
            if (paramValue < low) {
               errorMessage = "[param " + paramName + "] must be greater than or equal to " + low
                  + " but was equal to " + paramValue;
            }
         }
         else {
            if (paramValue <= low) {
               errorMessage = "[param " + paramName + "] must be greater than " + low
                  + " but was equal to " + paramValue;
            }
         }
         if (errorMessage != null) {
            throw new ArgumentError(errorMessage);
         }
         return paramValue;
      }
      
      /**
       * Checks if <code>paramValue</code> is less than (or equal to, if <code>allowHigh</code> is
       * <code>true</code>) <code>high</code>.
       * 
       * @return <code>paramValue</code>
       */
      public static function paramLessThanNumber(paramName:String,
                                                 high:Number,
                                                 paramValue:Number,
                                                 allowHigh:Boolean = false) : Number {
         var errorMessage:String = null; 
         if (allowHigh) {
            if (paramValue > high) {
               errorMessage = "[param " + paramName + "] must be less than or equal to " + high
                  + " but was equal to " + paramValue;
            }
         }
         else {
            if (paramValue >= high) {
               errorMessage = "[param " + paramName + "] must be less than " + high
                  + " but was equal to " + paramValue;
            }
         }
         if (errorMessage != null) {
            throw new ArgumentError(errorMessage);
         }
         return paramValue;
      }
      
      /**
       * Checks if <code>paramValue</code> is greater than (or equal to, if <code>allowLow</code> is
       * <code>true</code>) <code>low</code> and less than (or equal to, if <code>allowHigh</code> is
       * <code>true</code>) <code>high</code>.
       * 
       * @return <code>paramValue</code>
       */
      public static function paramInRangeNumbers(paramName:String,
                                                 low:Number,
                                                 high:Number,
                                                 paramValue:Number,
                                                 allowLow:Boolean = false,
                                                 allowHight:Boolean = false) : Number {
         if (low >= high) {
            throw new ArgumentError(
               "paramInRangeNumbers(): [param low] must be less than [param high] but\n"
               + "   [param low] was equal to" + low + "\n"
               + "   [param hight] was equal to " + high
            );
         }
         paramGreaterThanNumber(paramName, low, paramValue, allowLow);
         paramLessThanNumber(paramName, high, paramValue, allowHight);
         return paramValue;
      }
      
      /**
       * Checks if <code>paramValue</code> is a positive number (or equal to <code>0</code>, if
       * <code>allowZero</code> is <code>true</code>).
       *  
       * @return <code>paramValue</code>
       */
      public static function paramPositiveNumber(paramName:String,
                                                 paramValue:Number,
                                                 allowZero:Boolean = true) : * {
         return paramGreaterThanNumber(paramName, 0, paramValue, allowZero);
      }
      
      /**
       * Checks if the given <code>value</code> is of given <code>type</code>. If so, returns
       * <code>value</code> otherwise throws an error with a given <code>errorMessage</code>.
       * 
       * @param value an isntance to check the type of.
       * @param type required type of the instance referenced by <code>value</code>.
       * @param errorMessage optional error message to use when throwing an error.
       * 
       * @return <code>value</code>.
       */
      public static function requireType(value:Object, type:Class, errorMessage:String = null) : * {
         paramNotNull("type", type);
         if (!(value is type)) {
            if (errorMessage == null) {
               errorMessage = "Required type " + type + " but " + value +
                              " was of type " + getClassName(value);
            }
            throw new Error(errorMessage);
         }
         return value;
      }
      
      private static function throwIllegalClassNameError(name:String) : void {
         throw new ArgumentError("'" + name + "' is illegal class name");
      }
      
      /**
       * Does the same as <code>Array.join()</code> just converts <code>null</code> to <code>"null"</code>.
       * 
       * @see Array#join()
       */
      private static function arrayJoin(array:Array, sep:String) : String {
         var strings:Array = array.map(
            function(item:*, index:int, array:Array) : String {
               if (item === null)
                  return "null";
               if (item === undefined)
                  return "undefined";
               return Object(item).toString();
            }
         );
         return strings.join(sep);
      }
      
      /* ######################## */
      /* ### FAIL-FAST ERRORS ### */
      /* ######################## */
      
      /**
       * @throws flash.errors.IllegalOperationError
       */
      public static function throwAbstractMethodErrror(customMessage:String = null) : void {
         throwAbstractMemberAccessError("Method is abstract", customMessage);
      }
      
      /**
       * @throws flash.errors.IllegalOperationError
       */
      public static function throwAbstractPropertyError(customMessage:String = null) : void {
         throwAbstractMemberAccessError("Property is abstract", customMessage);
      }
      
      private static function throwAbstractMemberAccessError(defaultMessage:String,
                                                             customMessage:String) : void {
         throw new IllegalOperationError(customMessage != null ? customMessage : defaultMessage);
      }
      
      
      /* ##################### */
      /* ### DESCRIBE TYPE ### */
      /* ##################### */
      
      private static const DT_CACHE:Dictionary = new Dictionary(true);
      
      /**
       * Does the same as global function <code>describeType()</code> just caches the results of this function
       * and returns the same <code>XML</code> instance for the same argument. You should always use this
       * function instead of <code>flash.utils.describeType()</code> because the latter each time creates
       * new XML object and does not cache them (caching makes things a lot faster).
       */
      public static function describeType(type:Class) : XML {
         var typeInfo:XML = null
         if (DT_CACHE[type] !== undefined)
            typeInfo = DT_CACHE[type];
         else {
            typeInfo = flash.utils.describeType(type);
            DT_CACHE[type] = typeInfo;
         }
         return typeInfo;
      }
   }
}