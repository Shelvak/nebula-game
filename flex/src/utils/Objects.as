package utils
{
   import errors.AppError;

   import flash.errors.IllegalOperationError;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;

   import interfaces.IAutoCreated;

   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.utils.ObjectUtil;

   import namespaces.client_internal;


   /**
    * Has a bunch of methods for working with objects and classes. 
    */
   public class Objects
   {
      private static function get logger():ILogger {
         return Log.getLogger("utils.Objects");
      }

      /* ############# */
      /* ### CLASS ### */
      /* ############# */
      
      /**
       * Use this to retrieve of a given instance.
       * 
       * @param instance an instance of some class you want to retrieve it of.
       * <ul><b>
       * <li>Not null.</li>
       * <li>Not instance of a Class, Function.</li>
       * </b></ul>
       * 
       * @return class object of a given instance.
       */
      public static function getClass(instance:Object) : Class {
         paramNotNull("instance", instance);
         if (instance is Class || instance is Function)
            throw new ArgumentError("[param instance] can't be of type [class Class] or " +
                                    "[class Function] but was " + instance);
         return Class(getDefinitionByName(getQualifiedClassName(instance)));
      }
      
      /**
       * Creates new object of the same type as the given instance. A class of the given
       * instance must have no-args constructor for this method to work.
       * 
       * @param instance an object of some class you want to get new instance of.
       * <ul><b>
       *    <li>Not null.</li>
       *    <li>Not instance of Class or Function.</li>
       * </b></ul>
       * 
       * @return new instance of the same type as the given instance
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
       * Strips package part from full class name and leaves only the name only.
       * 
       * @param className fully qualified class name or simple class name
       * <ul><b>
       * <li>Not null.</li>
       * <li>Not empty string.</li>
       * <li>Legal class name.</li>
       * </b></ul>
       * 
       * @return simple class name without package
       */
      public static function toSimpleClassName(className:String) : String {
         paramNotEmpty("className", className);
         var indexColon:int = className.lastIndexOf(":");
         var indexPoint:int = className.lastIndexOf(".");
         if (indexColon == -1 && indexPoint == -1)
            return className;
         if (indexColon == className.length - 1 ||
             indexColon != -1 && indexColon < indexPoint)
            throw new ArgumentError("[pram className] contains illegal class name '" + className + "'");
         return className.substring(indexColon + 1);
      }
      
      /**
       * Lets you find out if a given class has got a given metadata tag.
       * 
       * @param type a Class to be examined
       * @param tag Name of metadata tag
       * <ul><b>
       * <li>Not null.</li>
       * <li>Not empty string.</li>
       * </b></ul>
       * 
       * @return <code>true</code> if the given class has a given metadata tag defined or <code>false</code>
       * otherwise.
       */
      public static function hasMetadata(type:Class, tag:String) : Boolean {
         paramNotEmpty("tag", tag);
         if (type == null)
            return false;
         var typeData:XML = describeType(type).factory[0];
         return typeData.metadata.(@name == tag)[0] != null;
      }
      
      /**
       * Returns array with all public properties of a given type.
       *  
       * @param type a class you want to introspect.
       * @param writeOnly If <code>true</code>, write-only properties will be returned.
       * 
       * @return array of properties that are defined either as variables or setter/getter pairs.
       */      
      public static function getPublicProperties(type:Class, writeOnly:Boolean = true) : Array {
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
      /* ############### */
      
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
         function helper(propType:String) : void {
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
               if (name) {
                  callback(prop.@name);
               }
               else {
                  callback(CLASS[prop.@name]);
               }
            }
         }
      }
      
      
      /* ############## */
      /* ### OBJECT ### */
      /* ############## */
      
      /**
       * Extracts all properties starting with given prefix from the source object to a new object and retuns
       * that object. If no properties are found, the object returned will also have no properties.
       * 
       * <p>This method loops through all dynamic properties of the source object so it take time
       * to extract properties from large objects.</p>
       * 
       * @param prefix
       * <ul><b>
       * <li>Not null.</li>
       * <li> Not empty string.</li>
       * </b></ul>
       * 
       * @param source source object that holds properties
       * <ul><b>
       * <li>Not null.</li>
       * <li>Generic object only..</li>
       * </b></ul>
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
       * Extracts all given properties from the source object to a new object and retuns that object. If no
       * properties are found, the object returned will also have no properties. 
       * 
       * @param properties list of properties to extract.
       * <ul><b>
       * <li>Not null.</li>
       * <li>Not empty array.</li>
       * </b></ul>
       * 
       * @param source source object that holds properties.
       * <ul><b>
       * <li>Not null.</li>
       * <li>Generic object only.</li>
       * </b></ul>
       */
      public static function extractProps(properties:Array, source:Object) : Object {
         paramNotNull("source", source);
         paramNotNull("properties", properties);
         if (properties.length == 0)
            throw new ArgumentError("[prop properties] must have at least one element");
         var result:Object = new Object();
         for each (var prop:String in properties) {
            if (source[prop] !== undefined)
               result[prop] = source[prop];
         }
         return result;
      }
      
      /**
       * @return true if <code>obj</code> has any keys, false otherwise.
       */
      public static function hasAnyProp(obj: Object): Boolean {
         for (var key:String in obj) {
            return true;
         }
         return false;
      }
      
      
      /* ############################ */
      /* ### FAIL-FAST ASSERTIONS ### */
      /* ############################ */
      
      /**
       * Checks if <code>paramValue</code> is not <code>null</code> or <code>undefined</code>. If that is not
       * the case, throws <code>ArgumentError</code> error.
       * 
       * @param paramName name of a <code>paramValue</code> object in a context where this method is called.
       * @param paramValue object to check.
       * 
       * @return <code>paramValue</code>.
       * 
       * @throws ArgumentError if <code>paramValue</code> is <code>null</code> or <code>undefined<code>.
       * 
       * @see #paramNotEquals()
       * @see #paramNotEmpty()
       */
      public static function paramNotNull(paramName:String, paramValue:*) : * {
         return paramNotEquals(paramName, paramValue, [undefined, null]);
      }
      
      /**
       * Checks if <code>paramValue</code> is not <code>null</code> or empty string. If that is not true,
       * throws <code>ArgumentError</code>.
       * 
       * @param paramName name of the parameters
       * @param paramValue value of the parameter
       * 
       * @return <code>paramValue</code>
       * 
       * @throws ArgumentError if <code>paramValue</code> is <code>null</code> or empty string.
       */
      public static function paramNotEmpty(paramName:String, paramValue:String) : String {
         return paramNotEquals(paramName, paramValue, [null, ""]);
      }
      
      /**
       * Checks if <code>paramValue</code> is not equal to any of given restricted values. If it is equal at
       * least to one of them, throws <code>ArgumentError</code> error. Operator <code>===</code> is used for
       * comparison.
       * 
       * <p>Format of the error message is: "[param &lt;paramName&gt;] can't be equal to
       * &lt;restrictedValues&gt; but was equal to &lt;paramValue&gt;".
       * </p>
       * 
       * @param paramName name of a <code>paramValue</code> object in a context where this method is called.
       * @param paramValue actual parameter value.
       * @param restrictedValues values which are illegal for <code>paramValue</code>.
       * 
       * @return <code>paramValue</code>.
       * 
       * @throws ArgumentError if <code>paramValue</code> is equal to one of values in
       * <code>restrictedValues</code> array.
       */
      public static function paramNotEquals(paramName:String, paramValue:*, restrictedValues:Array) : * {
         for each (var value:* in restrictedValues) {
            if (paramValue === value)
               throw new ArgumentError(
                  "[param " + paramName + "] can't be equal to " + arrayJoin(restrictedValues, ", ") +
                  " but was equal to " + toStr(paramValue)
               );
         }
         
         return paramValue;
      }

      /**
       * Checks if <code>paramValue</code> is equal to at least one value in the
       * <code>allowedValues</code> array. If that is not the case, throws an
       * instance of <code>ArgumentError</code>.
       *
       * @param paramName name of a <code>paramValue</code> object in a
       *        context where this method is called
       * @param paramValue actual parameter value
       * @param allowedValues values which are legal for <code>paramValue</code>
       * 
       * @return <code>paramValue</code>
       *
       * @throws ArgumentError if <code>paramValue</code> is not equal to any of
       * values in <code>restrictedValues</code> array.
       */
      public static function paramEquals(paramName: String,
                                         paramValue: *,
                                         allowedValues: Array): * {
         for each (var value: * in allowedValues) {
            if (paramValue === value) {
               return paramValue;
            }
         }
         throw new ArgumentError(
            "[param " + paramName + "] must be equal to at least one "
               + "value in " + arrayJoin(allowedValues, ", ")
               + " but was equal to " + toStr(paramValue)
         );
      }
      
      /**
       * Does the same as <code>paramNotNull()</code> just allows you to specify a custom error message.
       * 
       * @throws Error if assertion fails
       */
      public static function notNull(value:*, errorMessage:String) : * {
         return notEquals(value, [undefined, null], errorMessage);
      }
      
      /**
       * Does the same as <code>paramNotEmpty()</code> just allows you to specify a custom error message.
       * 
       * @throws Error if assertion fails
       */
      public static function notEmpty(value:String, errorMessage:String) : String {
         return notEquals(value, [null, ""], errorMessage);
      }
      
      /**
       * Does the same as <code>paramNotEquals()</code> just allows you to specify a custom error message.
       * 
       * @throws Error if assertion fails
       */
      public static function notEquals(value:*,
                                       restrictedValues:Array,
                                       errorMessage:String) : * {
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
       * <code>value</code> otherwise throws <code>TypeError</code> with a given <code>errorMessage</code>.
       * 
       * @param value an isntance to check the type of
       * @param type required type of the instance referenced by <code>value</code>
       * <ul><b>
       * <li>Not null.</li>
       * </b></ul>
       * 
       * @param errorMessage optional error message to use when throwing an error.
       * 
       * @return <code>value</code>.
       */
      public static function requireType(value:Object,
                                         type:Class,
                                         errorMessage:String = null) : * {
         paramNotNull("type", type);
         if (!(value is type)) {
            if (errorMessage == null)
               errorMessage = "Required type " + type + " but " + value +
                              " was of type " + getClassName(value);
            throw new TypeError(errorMessage);
         }
         return value;
      }
      
      /**
       * Does the same as <code>Array.join()</code> just converts <code>null</code> to <code>"null"</code>.
       * 
       * @see Array#join()
       */
      private static function arrayJoin(array:Array, sep:String) : String {
         var strings:Array = array.map(
            function(item:*, index:int, array:Array) : String {
               return toStr(item);
            }
         );
         return "[" + strings.join(sep) + "]";
      }
      
      private static function toStr(value:*) : String {
         if (value === undefined) return "undefined";
         if (value === null)      return "null";
         if (value is String)     return "'" + value + "'";
         return String(value);
      }
      
      /* ######################## */
      /* ### FAIL-FAST ERRORS ### */
      /* ######################## */

      /**
       * @throws flash.errors.IllegalOperationError
       */
      public static function throwNotSupportedPropertyError(customMessage:String = null): void {
         throwIllegalOperationError("Property not supported", customMessage);
      }

      /**
       * @throws flash.errors.IllegalOperationError
       */
      public static function throwNotSupportedMethodError(customMessage:String = null): void {
         throwIllegalOperationError("Method not supported", customMessage);
      }

      /**
       * @throws flash.errors.IllegalOperationError
       */
      public static function throwAbstractMethodErrror(customMessage:String = null) : void {
         throwIllegalOperationError("Method is abstract", customMessage);
      }
      
      /**
       * @throws flash.errors.IllegalOperationError
       */
      public static function throwAbstractPropertyError(customMessage:String = null) : void {
         throwIllegalOperationError("Property is abstract", customMessage);
      }
      
      private static function throwIllegalOperationError(defaultMessage:String,
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
         var typeInfo: XML = null;
         if (DT_CACHE[type] !== undefined)
            typeInfo = DT_CACHE[type];
         else {
            typeInfo = flash.utils.describeType(type);
            DT_CACHE[type] = typeInfo;
         }
         return typeInfo;
      }
      
      
      /* ################### */
      /* ### AUTO-CREATE ### */
      /* ################### */
      
      private static const WHITESPACE_REGEXP:RegExp = /\s/g;
      
      client_internal static const TYPE_PROCESSORS:Dictionary = new Dictionary();
      /**
       * Sets processor function to handle properties of specific type.
       * 
       * @param type a Class that requires special handling.
       * <ul><b>
       * <li>Not null.</li>
       * </b></ul>
       * 
       * @param processor function that will be called when an object of the given type needs to be constructed.
       * <ul><b>
       * <li>Not null.</li>
       * </b></ul>
       * Signature of the function should be: <code>function(currValue:&#42, value:Object) : Object</code>.
       * Parameters of the function:
       * <ul>
       *    <li><code>currValue</code> - currentValue of the property in the host object.</li>
       *    <li><code>value</code> - an object that is a generic representation of an instance beeing constructed.</li>
       * </ul>
       * The function should create and return a new instance of <code>type</code> only if <code>currValue</code>
       * is <code>null</code>. If not, it should fill the <code>currValue</code> object with appropriate data
       * and return it. 
       */
      public static function setTypeProcessor(type:Class, processor:Function) : void {
         paramNotNull("type", processor);
         paramNotNull("processor", processor);
         client_internal::TYPE_PROCESSORS[type] = processor;
      }
      private static function getTypeProcessor(type:Class) : Function {
         return client_internal::TYPE_PROCESSORS[type];
      }
      
      /**
       * Fills given <code>collectionInstance</code> with items that are created from the generic objects in
       * collection <code>data</code>.
       * 
       * @param collectionInstance an <code>Array</code>, <code>Vector</code> or <code>IList</code> to add items to.
       * <ul><b>
       * <li>Not null.</li>
       * </b></ul>
       * 
       * @param itemType type of items to create.
       * <ul><b>
       * <li>Not null.</li>
       * </b></ul>
       * 
       * @param data <code>Array</code>, <code>Vector</code> or <code>IList</code> that holds generic objects
       *             that need to be created and added to the <code>collectionInstance</code>.
       * <ul><b>
       * <li>Not null.</li>
       * </b></ul>
       * 
       * @return <code>collectionInstance</code>
       */
      public static function fillCollection(collectionInstance:*, itemType:Class, data:Object) : * {
         paramNotNull("collectionInstance", collectionInstance);
         paramNotNull("itemType", itemType);
         paramNotNull("data", data);
         var collIsList:Boolean = collectionInstance is IList;
         var collIsArray:Boolean = collectionInstance is Array || TypeChecker.isVector(collectionInstance);
         if (!collIsList && !collIsArray)
            throw new TypeError(
               "[param collectionInstance] must be of Array, Vector or IList type but was " +
               getClass(collectionInstance)
            );
         var dataIsList:Boolean = data is IList;
         var dataIsArray:Boolean = data is Array || TypeChecker.isVector(data);
         if (!dataIsList && !dataIsArray)
            throw new TypeError(
               "[param data] must be of Array, Vector or IList type but was " + 
               getClass(data)
            );
         
         function addItem(data:Object) : void {
            var item:Object = createImpl(itemType, null, data);
            if (collIsList) {
               IList(collectionInstance).addItem(item);
            }
            else {
               collectionInstance.push(item);
            }
         }
         if (dataIsList) {
            var list:IList = IList(data);
            var listLength:int = list.length;
            for (var idx:int = 0; idx < listLength; idx++) {
               addItem(list.getItemAt(idx));
            }
         }
         else {
            for each (var item:Object in data) {
               addItem(item);
            }
         }
         return collectionInstance;
      }
      
      /**
       * Creates an object and copies values to appropriate fields from a provided generic object that holds data.
       * <ul>
       *    <li>Properties that need to be filled must be marked with either
       *        <code>[Optional]</code> or <code>[Required]</code> metadata tags;</li>
       *    <li>Properties of primitive type are copied from the data object;</li>
       *    <li>Properties that are of any other type will cause recursive call to <code>create()</code>. A
       *        class can't have property of the same class (itself) type (or subtype) marked with
       *        <code>[Required]</code> and you can't created any similar loops containing only
       *        <code>[Required]</code> tag;</li>
       *    <li>Properties of <code>Array</code> and <code>IList</code> type must have <code>elementType</code>
       *        attribute for <code>[Required|Optional]</code> metadata tag defined. Properties of
       *        <code>Vector</code> type do not need this attribute. Element type can any class;</li>
       *    <li>You can define properties of your classes as aggregators (<code>aggregatesProps</code> and
       *        <code>aggregatesPrefix</code> attributes of <code>[Required|Optional]</code> tags).
       *        See <a target="_blank" href="http://wiki-dev.nebula44.com/wiki/Nebula_44:ClientCode"> wiki
       *        page</a> for more information on this feature;</li>
       *    <li>Properties of complex types (not collections) may also have <code>[PropsMap]</code> tag attached to them.
       *        This allows you to map properties from data object to properties of the complex type. For
       *        more information on this feature see
       *        <a target="_blank" href="http://wiki-dev.nebula44.com/wiki/Nebula_44:ClientCode">wiki page</a>;</li>
       *    <li>If data object contains properties of different type than those that are defined
       *        in destination class, method invocation will end up with an error;</li>
       *    <li>Works only with dynamicly created properties of the data object.</li>
       * </ul>
       * 
       * @param type type of an instance to be created | <b>not null</b>
       * @param data raw object containing data to be loaded to the instance to be created
       * 
       * @return newly created object with values loaded to its properties from the data object
       */
      public static function create(type:Class, data:Object) : * {
         Objects.paramNotNull("type", type);
         return createImpl(type, null, data);
      }
      private static function createImpl(type:Class, object:Object, data:Object, itemType:Class = null) : Object {
         paramNotNull("type", type);

         if (data == null)
            return null;
         
         // type processors come first so that special types could be created directly using 
         // create() method
         var typeProcessor:Function = getTypeProcessor(type);
         if (typeProcessor != null) {
            object = typeProcessor.call(null, object, data);
            callAfterCreate(object, data);
            return object;
         }
         
         // primitives and generic objects don't need any handling at all
         if (TypeChecker.isPrimitiveClass(type) || type == Object)
            return data;
         
         // the rest operations also need an instance of given type
         // assuming that all types from this point forward have constructors without arguments
         if (object == null)
            object = new type();
         
         // collections
         if (TypeChecker.isCollection(object)) {
            fillCollection(object, itemType, data);
            // afterCreate() callback is not supported on the collections because including this feature
            // would be too much dependent on internals of each collection type
            return object;
         }
         
         var errs:Array = new Array();
         function pushError(message:String, ... params) : void {
            errs.push(StringUtil.substitute(message, params));
         }
         
         // other types: assuming they have metadata tags attached to properties
         var typeInfo:XML = describeType(type).factory[0];
         for each (var propsInfoList:XMLList in [typeInfo.accessor, typeInfo.variable, typeInfo.constant]) {
            for each (var propInfo:XML in propsInfoList) {
               var readOnly:Boolean = propInfo.name() == "constant" ||
                                      propInfo.name() == "accessor" && propInfo.@access[0] == "readonly";
               var propMetadata:XMLList = propInfo.metadata;
               var propName:String  = propInfo.@name[0];
               var propClassName:String = String(propInfo.@type[0]).replace("&lt;", "<");
               var propClass:Class = getDefinitionByName(propClassName) as Class;
               var metaRequired:XML = propMetadata.(@name == "Required")[0];
               var metaOptional:XML = propMetadata.(@name == "Optional")[0];
               var metaPropsMap:XML = propMetadata.(@name == "PropsMap")[0];
               var metaActual:XML   = metaRequired != null ? metaRequired : metaOptional;
               if (metaActual != null) {
                  var propAlias:String = metaActual.arg.(@key == "alias").@value[0];
                  var aggregatesProps:String  = metaActual.arg.(@key == "aggregatesProps" ).@value[0];
                  var aggregatesPrefix:String = metaActual.arg.(@key == "aggregatesPrefix").@value[0];
               }
               
               
               // skip the property if its not tagged
               if (metaRequired == null && metaOptional == null)
                  continue;
               
               if (metaRequired != null && metaOptional != null) {
                  pushError(
                     "Property '{0}' has both - [Required] and [Optional] - metadata tags declared which " +
                     "is illegal.", propName
                  );
                  continue;
               }
               if ((aggregatesProps != null || aggregatesPrefix != null) && propAlias != null) {
                  pushError(
                     "Property '{0}' has both - alias and aggregatesProps (or aggregatesPrefix) - attributes " +
                     "defined which is illegal.", propName
                  );
                  continue;
               }
               if (aggregatesProps != null && aggregatesPrefix != null) {
                  pushError(
                     "Property '{0}' has both - aggregatesProps and aggregatesPrefix - " +
                     "attributes defined which is illegal.", propName
                  );
                  continue;
               }
               if (propClass == type && metaRequired != null) {
                  pushError(
                     "Property '{0}' is marked with [Required] and is of exact type as given object type " +
                     "{1}. This is not legal. Use [Optional] instead.", propName, type
                  );
                  continue;
               }
               
               if (propAlias == null) {
                  propAlias = propName;
               }
               var propValue:* = undefined;
               try {
                  propValue = object[propName];
               }
               catch(err:Error) {
                  logger.warn(
                     "@createImpl(): Error '{0}' while reading property '{1}' "
                        + "of instance of {2}. Assuming 'undefined' value.",
                     err.message, propName, type
                  );
               }
               var propData:* = data[propAlias];
               
               if (TypeChecker.isPrimitiveClass(propClass)) {
                  // [PropsMap] not supported on primitives
                  if (metaPropsMap != null) {
                     pushError("[PropsMap] not allowed on a property '{0}' of primitive type", propName);
                     continue;
                  }
                  // read-only primitive error
                  if (readOnly) {
                     pushError("Read-only property '{0}' of primitive type {1}", propName, propClass);
                     continue;
                  }
               }
               // read-only null property
               else if (propValue == null && readOnly) {
                  pushError("Read-only property '{0}' of type {1} not initialized", propName, propClass);
                  continue;
               }
               
               function setProp(value:Object) : void {
                  if (object[propName] != value)
                     object[propName] = value;
               }
               function pushMappingError(err:MappingError) : void {
                  pushError("Error while performing mappings of prop '{0}': {1}", propName, err.message);
               }
               
               // aggregator comes first
               if (aggregatesProps != null || aggregatesPrefix != null) {
                  
                  // aggregatesProps and aggregatesPrefix not allowed for primitives
                  if (TypeChecker.isPrimitiveClass(propClass)) {
                     pushError(
                        "aggregatesProps and aggregatesPrefix attributes not allowed in [Optional|Required] " +
                        "tags attached to a property of primitive type, but such tag was found on property " +
                        "'{0}'", propName
                     );
                     continue;
                  }
                  
                  var aggrData:Object;
                  // aggregates props
                  if (aggregatesProps != null) {
                     aggregatesProps = aggregatesProps.replace(WHITESPACE_REGEXP, "");
                     aggrData = extractProps(aggregatesProps.split(","), data);
                  }
                  // aggregates prefix
                  else
                     aggrData = extractPropsWithPrefix(aggregatesPrefix, data);
                  
                  if (!hasAnyProp(aggrData)) {
                     if (metaRequired != null) {
                        var errorMsg:String = "Aggregator defined by property '" + propName + "' is required but ";
                        if (aggregatesProps != null)
                           errorMsg += "none of aggregated properties [" + aggregatesProps + "]"; 
                        else
                           errorMsg += "no properties with prefix '" + aggregatesPrefix + "'";
                        errorMsg += " are provided.";
                        pushError(errorMsg);
                     }
                  }
                  else {
                     try {
                        setProp(createImpl(propClass, propValue, performMapping(aggrData, metaPropsMap)));
                     }
                     catch (err:MappingError) {
                        pushMappingError(err);
                     }
                  }
                  
                  continue;
               }
               
               if (metaRequired != null && propData === undefined) {
                  pushError("Property '{0}' does not exist in source object but is required.", propName);
                  continue;
               }
               
               // skip null and undefined values in source object
               if (propData == null)
                  continue;
               
               // error when property is a primitive but the value in data object is generic object or 
               // an instance of some non-primitive class
               if (TypeChecker.isPrimitiveClass(propClass) && !TypeChecker.isOfPrimitiveType(propData)) {
                  pushError(
                     "Property '{0}' is of primitive type {1}, but the value '{2}' in the data object " +
                     "is of complex type {3}", propName, propClass, propData, getClass(propData)
                  );
                  continue;
               }
               
               if (getTypeProcessor(propClass) != null ||
                   TypeChecker.isPrimitiveClass(propClass) ||
                   propClass == Object) {
                  try {
                     setProp(createImpl(propClass, propValue, performMapping(propData, metaPropsMap)));
                  }
                  catch (err:MappingError) {
                     pushMappingError(err);
                  }
                  continue;
               }
               
               if (propValue == null)
                  propValue = new propClass();
               
               // collections
               var propIsVector:Boolean = TypeChecker.isVector(propValue);
               var propIsArray:Boolean = propValue is Array;
               var propIsList:Boolean = propValue is IList;
               if (propIsArray || propIsList || propIsVector) {
                  
                  // elementType attribute is mandatory element for Array and IList properties
                  var itemTypeName:String = metaActual.arg.(@key == "elementType").@value[0];
                  if (!propIsVector && itemTypeName == null) {
                     pushError(
                        "Property '{0}' is of [class IList] or [class Array] type and therefore requires " +
                        "elementType attribute of [Required|Optional] metadata tag declared.", propName
                     );
                     continue;
                  }
                  // [PropsMap] on collections not supported
                  if (metaPropsMap != null) {
                     pushError("[PropsMap] not allowed on a property '{0}' of collection type", propName);
                     continue;
                  }
                  
                  if (propIsVector) {
                     itemTypeName = propClassName.substring(
                        propClassName.indexOf("Vector.<") + 8,
                        propClassName.length - 1
                     );
                  }
                  setProp(createImpl(propClass, propValue, propData, getDefinitionByName(itemTypeName) as Class));
               }
                  
               // other objects
               else {
                  try {
                     setProp(createImpl(propClass, propValue, performMapping(propData, metaPropsMap)));
                  }
                  catch (err:MappingError) {
                     pushMappingError(err);
                  }
               }
            }
         }
         
         if (errs.length != 0)
            throw new AppError(
               errs.join("\n") + "\nFix properties in " + type + " or see to it that data " +
               "object holds values for all required properties of correct type. Data object was:\n" +
               ObjectUtil.toString(data)
            );
         
         callAfterCreate(object, data);
         
         return object;
      }
      
      /**
       * @throws MappingError 
       */
      private static function performMapping(sourceData:Object, metaPropsMap:XML) : Object {
         if (metaPropsMap == null)
            return sourceData;
         
         var errs:Array = new Array();
         function pushError(message:String, ... parameters) : void {
            errs.push(StringUtil.substitute(message, parameters));
         }
         
         var propDataMapped:Object = new Object();
         // Maybe cache these maps?
         // But I don't expect this feature used heavily so maybe not worth the trouble?
         var sdMap:Object = new Object();
         var dsMap:Object = new Object();
         for each (var sdPair:XML in metaPropsMap.arg) {
            var sourceProp:String = sdPair.@key[0];
            var destProp:String = sdPair.@value[0];
            if (destProp.length == 0) {
               pushError(
                  "invalid destination (value) prop '{0}' for source (key) prop {'1'}",
                  destProp, sourceProp
               );
               continue;
            }
            if (sdMap[sourceProp] !== undefined)
               pushError(
                  "source (key) prop '{0}' duplication (destination (value) prop '{1}')",
                  sourceProp, destProp
               );
            else
               sdMap[sourceProp] = destProp;
            if (dsMap[destProp] !== undefined)
               pushError(
                  "destination (value) prop '{0}' duplication (source (key) prop '{1}')",
                  destProp, sourceProp
               );
            else
               dsMap[destProp] = sourceProp;
         }
         
         if (errs.length > 0) {
            var ident1:String = "\n   ";
            var ident2:String = "\n      ";
            throw new MappingError(
               "MappingError:" + ident1 + "Mapping metadata: " + metaPropsMap.toXMLString() + ident1 +
               "Errors:" + ident2 + errs.join(ident2)
            );
         }
         
         for (sourceProp in sourceData) {
            destProp = sdMap[sourceProp];
            if (destProp == null)
               destProp = sourceProp;
            propDataMapped[destProp] = sourceData[sourceProp];
         }
         
         return propDataMapped;
      }
      
      private static function callAfterCreate(target:Object, data:Object) : void {
         paramNotNull("target", target);
         paramNotNull("data", data);
         if (target is IAutoCreated) {
            IAutoCreated(target).afterCreate(data);
         }
      }
   }
}


class MappingError extends Error
{
   public function MappingError(message:String) {
      super(message);
   }
}