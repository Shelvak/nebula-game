package utils
{
   import com.adobe.errors.IllegalStateError;

   import errors.AppError;

   import flash.errors.IllegalOperationError;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;

   import interfaces.IAutoCreated;

   import models.BaseModel;

   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.utils.ObjectUtil;

   import namespaces.client_internal;

   import utils.logging.Log;


   /**
    * Has a bunch of methods for working with objects and classes. 
    */
   public final class Objects
   {
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


      private static const INNER_CLASS_FILE_REGEXP: RegExp = /^.+\$\d+::/;

      /**
       * Returns the fully qualified class name of a given object.
       * 
       * @param replaceColons if <code>true</code>, will replace the two colons that separate package
       * from class name with a dot (.) symbol.
       */
      public static function getClassName(o:Object, replaceColons:Boolean = false) : String {
         var className:String = getQualifiedClassName(o).replace(INNER_CLASS_FILE_REGEXP, "");
         if (replaceColons)
            className = className.replace("::", ".");
         return className;
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
      public static function getPublicProperties(type: Class,
                                                 writeOnly: Boolean = true): Array {
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
       * <code>ObjectPropertyType</code>.
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
       * <code>ObjectPropertyType</code>.
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
       * <code>ObjectPropertyType</code>.
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
       * Checks if <code>value</code> is greater than (or equal to if
       * <code>allowLow</code> is <code>true</code>) <code>low</code>.
       *
       * @throws Error if assertion fails
       */
      public static function greaterThanNumber(value: Number,
                                               low: Number,
                                               allowLow: Boolean = false,
                                               errorMessage: String = null): Number {
         if (allowLow ? value < low : value <= low) {
            if (errorMessage == null) {
               errorMessage = StringUtil.substitute(
                  "[param value] is required to be greater than {0} but was "
                     + "equal to {1}",
                  (allowLow ? "or equal to " : "") + low, value
               );
            }
            throw new Error(errorMessage);
         }
         return value;
      }

      /**
       * Checks if <code>value</code> is less than (or equal to if
       * <code>allowHigh</code> is <code>true</code>) <code>high</code>.
       *
       * @throws Error if assertion fails
       */
      public static function lessThanNumber(value: Number,
                                            high: Number,
                                            allowHigh: Boolean = false,
                                            errorMessage: String = null): Number {
         if (allowHigh ? value > high : value >= high) {
            if (errorMessage == null) {
               errorMessage = StringUtil.substitute(
                  "[param value] is required to be less than {0} but was "
                     + "equal to {1}",
                  (allowHigh ? "or equal to " : "") + high, value
               );
            }
            throw new Error(errorMessage);
         }
         return value;
      }
      
      /**
       * Checks if <code>paramValue</code> is greater than (or equal to, if
       * <code>allowLow</code> is <code>true</code>) <code>low</code>.
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
       * Checks if <code>paramValue</code> can be an ID value.
       * 
       * @return <code>paramValue</code>
       */
      public static function paramIsId(paramName:String, paramValue:int): int {
         if (paramValue <= 0) {
            throw new ArgumentError(
               "[param " + paramName + "] must be an ID value (greater than "
                  + "0) but was " + paramValue
            );
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
                                                 allowHigh:Boolean = false) : Number {
         if (low >= high) {
            throw new ArgumentError(
               "paramInRangeNumbers(): [param low] must be less than [param high] but\n"
               + "   [param low] was equal to" + low + "\n"
               + "   [param high] was equal to " + high
            );
         }
         paramGreaterThanNumber(paramName, low, paramValue, allowLow);
         paramLessThanNumber(paramName, high, paramValue, allowHigh);
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
       * @param value an instance to check the type of
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
      public static function throwStateOutOfSyncError(oldObject: Object, newObject: Object): void
      {
         throw new IllegalStateError("Object can not be created, old mismatching " +
            "object detected!\n" +
            "old object: " + ObjectUtil.toString(oldObject) + "\n" +
            "new object: " + ObjectUtil.toString(newObject));
      }

      /**
       * @throws flash.errors.IllegalOperationError
       */
      public static function throwReadOnlyPropertyError(customMessage: String = null): void {
         throwIllegalOperationError("Property is read-only", customMessage);
      }

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
      public static function throwAbstractMethodError(customMessage:String = null) : void {
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
      
      
      /* ################### */
      /* ### AUTO-CREATE ### */
      /* ################### */
      
      private static const WHITESPACE_REGEXP:RegExp = /\s/g;
      
      client_internal static const TYPE_PROCESSORS:Dictionary = new Dictionary();
      /**
       * Sets processor function to handle properties of specific type.
       * 
       * @param type a Class that requires special handling | <b>Not null</b>
       * 
       * @param creator function that will be called when an object of the
       * given type needs to be constructed | <b>Not null</b>
       * Signature of this function should be: <code>function(currValue:&#42, value:Object) : Object</code>.
       * Parameters of the function:
       * <ul>
       *    <li><code>currValue</code> - currentValue of the property in the host object.</li>
       *    <li><code>value</code> - an object that is a generic representation of an instance beeing constructed.</li>
       * </ul>
       * The function should create and return a new instance of <code>type</code> only if <code>currValue</code>
       * is <code>null</code>. If not, it should fill the <code>currValue</code> object with appropriate data
       * and return it.
       *
       * @param sameDataChecker a function that will be called when
       * it is necessary to check if an object of given type contains the same
       * data as some generic object.
       * Signature of this function should be: <code>function(currValue:&#42, value:Object) : Boolean</code>.
       * Parameters of the function:
       * <ul>
       *    <li><code>currValue</code> - currentValue of the property in the host object.</li>
       *    <li><code>value</code> - an object that is a generic representation of an instance to be checked.</li>
       * </ul>
       * Both parameters are guaranteed to be not null.
       * The function must return <code>true</code> if the data contained inside
       * <code>currValue</code> is the same as in <code>value</code> or
       * <code>false</code> otherwise.
       */
      public static function setTypeProcessors(type: Class,
                                               creator: Function,
                                               sameDataChecker: Function): void {
         paramNotNull("type", type);
         paramNotNull("creator", creator);
         paramNotNull("sameDataChecker", sameDataChecker);
         client_internal::TYPE_PROCESSORS[type] =
            new TypeProcessors(creator, sameDataChecker);
      }
      private static function getTypeProcessors(type:Class) : TypeProcessors {
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

      public static function update(object: Object, data: Object): void {
         createImpl(getClass(object), object, data, null, false);
         if (object is BaseModel) {
            BaseModel(object).refresh();
         }
      }

      private static var _typeInfoHash: TypeInfoHash = null;
      private static function get TYPE_INFO_HASH(): TypeInfoHash {
         if (_typeInfoHash == null) {
            _typeInfoHash = new TypeInfoHash();
         }
         return _typeInfoHash;
      }

      /**
       * Checks if properties of given complex object hold the same values
       * as the given generic data object.
       *
       * This method supports:
       * <ul>
       *    <li>property aliases</li>
       *    <li>properties with type processors</li>
       *    <li>properties of nested complex and generic objects</li>
       * </ul>
       * This method does not support:
       * <ul>
       *    <li>collections and properties of collection types</li>
       *    <li>aggregated properties</li>
       *    <li>properties with mapping</li>
       * </ul>
       *
       * @param complex a non-primitive object to check | <b>not null, not a collection</b>
       * @param data generic object that holds the data to check against
       *
       * @return <code>true</code> if all properties of the complex object
       * contain the same values as their counterparts in generic
       * <code>data</code> object or <code>false</code> otherwise
       */
      public static function containsSameData(complex: Object,
                                              data: Object): Boolean {
         paramNotNull("object", complex);
         if (TypeChecker.isOfPrimitiveType(complex)
                || TypeChecker.isCollection(complex)
                || TypeChecker.isGenericObject(complex)) {
            throw new ArgumentError(
               "[param complex] can't be a primitive, collection "
                  + "or generic object but was " + getClassName(complex)
            );
         }
         return data == null ? false : containsSameDataImpl(complex, data);
      }

      private static function containsSameDataImpl(complex: Object,
                                                   data: Object): Boolean {
         paramNotNull("complex", complex);
         paramNotNull("data", data);
         const type: Class = getClass(complex);
         if (!TYPE_INFO_HASH.hasInfo(type)) {
            buildTypeInfoFor(type);
         }

         for each (var propInfo: PropInfo in TYPE_INFO_HASH.getInfo(type)) {
            if (propInfo.includeInConstruction
                   && !propInfo.typeIsAnyCollection
                   && !propInfo.isAggregator
                   && !propInfo.hasMapping
                   && data[propInfo.alias] !== undefined) {
               const valueInComplex: * = complex[propInfo.name];
               const valueInData: * = data[propInfo.alias];
               if (propInfo.typeIsPrimitive) {
                  if (valueInComplex != valueInData) {
                     return false;
                  }
               }
               else if (propInfo.typeIsGenericObject) {
                  if (ObjectUtil.compare(valueInComplex, valueInData) != 0) {
                     return false;
                  }
               }
               else {
                  if (valueInComplex == null && valueInData != null
                         || valueInComplex != null && valueInData == null) {
                     return false;
                  }
                  if (valueInComplex == null && valueInData == null) {
                     break;
                  }
                  const typeProcessors: TypeProcessors =
                           getTypeProcessors(propInfo.type);
                  if (typeProcessors != null) {
                     if (!typeProcessors.sameDataChecker
                             .call(null, valueInComplex, valueInData)) {
                        return false;
                     }
                  }
                  else {
                     if (!containsSameDataImpl(valueInComplex, valueInData)) {
                        return false;
                     }
                  }
               }
            }
         }
         return true;
      }

      private static function createImpl(type: Class,
                                         object: Object,
                                         data: Object,
                                         itemType: Class = null,
                                         rawCreation: Boolean = true): Object {
         paramNotNull("type", type);

         if (data == null) {
            return null;
         }
         
         // type processors come first so that special types could be created directly using 
         // create() method
         var typeProcessors: TypeProcessors = getTypeProcessors(type);
         if (typeProcessors != null) {
            object = typeProcessors.creator.call(null, object, data);
            callAfterCreate(object, data);
            return object;
         }
         
         // primitives and generic objects don't need any handling at all
         if (TypeChecker.isPrimitiveClass(type) || type === Object) {
            return data;
         }

         // the rest operations also need an instance of given type
         // assuming that all types from this point forward have constructors without arguments
         if (object == null) {
            object = new type();
         }
         
         // collections
         if (TypeChecker.isCollection(object)) {
            if (object is IList) {
               IList(object).removeAll();
            }
            else {
               object.splice(0, object.length);
            }
            fillCollection(object, itemType, data);
            // afterCreate() callback is not supported on the collections because including this feature
            // would be too much dependent on internals of each collection type
            return object;
         }

         if (!TYPE_INFO_HASH.hasInfo(type)) {
            buildTypeInfoFor(type);
         }

         const errs: Array = new Array();
         for each (var propInfo: PropInfo in TYPE_INFO_HASH.getInfo(type)) {

            /* FOR NEW OBJECTS UPDATE SYSTEM */
            if (propInfo.skipProperty && !rawCreation) {
               continue;
            }

            if (!propInfo.includeInConstruction) {
               continue;
            }

            const propName: String = propInfo.name;
            const propType: Class = propInfo.type;
            const propData: * = data[propInfo.alias];
            var propValue: * = undefined;
            try {
               propValue = object[propName];
            }
            catch (err: Error) {
               Log.getMethodLogger(Objects, "createImpl").warn(
                  "Error '{0}' while reading property '{1}' of instance of {2}. "
                     + "Assuming 'undefined' value.", err.message, propName, type
               );
            }
            // read-only null property
            if (!propInfo.typeIsPrimitive && propInfo.readOnly && propValue == null) {
               createImpl_pushError(
                  errs, "Read-only property '{0}' of type {1} not initialized",
                  propName, propInfo.type
               );
               continue;
            }

            if (propInfo.isAggregator) {
               const aggregatesProps: Array = propInfo.aggregatesProps;
               const aggregatesPrefix: String = propInfo.aggregatesPrefix;
               const aggrData: Object =
                        aggregatesProps != null
                           ? extractProps(aggregatesProps, data)
                           : extractPropsWithPrefix(aggregatesPrefix, data);

               if (!hasAnyProp(aggrData)) {
                  if (propInfo.required) {
                     var errorMsg: String =
                            "Aggregator defined by property '" + propName
                               + "' is required but ";
                     if (aggregatesProps != null) {
                        errorMsg += "none of aggregated properties [" + aggregatesProps + "]";
                     }
                     else {
                        errorMsg += "no properties with prefix '" + aggregatesPrefix + "'";
                     }
                     errorMsg += " are provided.";
                     createImpl_pushError(errs, errorMsg);
                  }
               }
               else {
                  try {
                     createImpl_setProp(object, propName, createImpl(
                        propInfo.type, propValue,
                        performMapping(aggrData, propInfo), null, rawCreation
                     ));
                  }
                  catch (err: MappingError) {
                     createImpl_pushMappingError(errs, propName, err);
                  }
               }
               continue;
            }

            if (propInfo.required && propData === undefined) {
               createImpl_pushError(
                  errs,
                  "Property '{0}' does not exist in source object but "
                     + "is required.",
                  propName
               );
               continue;
            }

            // skip null and undefined values in source object
            if (rawCreation && propData == null) {
               continue;
            }

            // error when property is a primitive but the value in data object
            // is generic object or an instance of some non-primitive class
            if (TypeChecker.isPrimitiveClass(propType) &&
                   !TypeChecker.isOfPrimitiveType(propData)) {
               createImpl_pushError(
                  errs,
                  "Property '{0}' is of primitive type {1}, but the value "
                     + "'{2}' in the data object is of complex type {3}",
                  propName, propType, propData, getClass(propData)
               );
               continue;
            }

            if (getTypeProcessors(propType) != null ||
                   TypeChecker.isPrimitiveClass(propType) ||
                   propType == Object) {
               try {
                  createImpl_setProp(object, propName, createImpl(
                     propType, propValue, performMapping(propData, propInfo),
                     null, rawCreation
                  ));
               }
               catch (err: MappingError) {
                  createImpl_pushMappingError(errs, propName, err);
               }
               continue;
            }

            if (propValue == null) {
               propValue = new propType();
            }

            if (propInfo.typeIsAnyCollection) {
               createImpl_setProp(object, propName, createImpl(
                  propType, propValue, propData, propInfo.itemType, rawCreation
               ));
            }
            else {
               try {
                  createImpl_setProp(object, propName, createImpl(
                     propType, propValue, performMapping(propData, propInfo), null, rawCreation
                  ));
               }
               catch (err: MappingError) {
                  createImpl_pushMappingError(errs, propName, err);
               }
            }
         }

         if (errs.length != 0) {
            throw new AppError(
               errs.join("\n") + "\nFix properties in " + type + " or see to "
                  + "it that data object holds values for all required "
                  + "properties of correct type. Data object was:\n" +
                  ObjectUtil.toString(data)
            );
         }

         callAfterCreate(object, data);
         
         return object;
      }

      private static function createImpl_pushError(errs: Array,
                                                   message: String,
                                                   ...params): void {
         errs.push(StringUtil.substitute(message, params));
      }

      private static function createImpl_pushMappingError(errs: Array,
                                                          propName: String,
                                                          err: MappingError): void {
         createImpl_pushError(
            errs,
            "Error while performing mappings of prop '{0}':\n{1}",
            propName, err.message
         );
      }

      private static function createImpl_setProp(object: Object,
                                                 propName: String,
                                                 propValue: *): void {
         if (object[propName] != propValue) {
            object[propName] = propValue;
         }
      }

      /**
       * @throws MappingError 
       */
      private static function performMapping(sourceData: Object,
                                             propInfo: PropInfo): Object {
         if (!propInfo.hasMapping) {
            return sourceData;
         }
         const srcToDestMap: Object = propInfo.srcToDestMap;
         const propDataMapped: Object = new Object();
         for (var sourcePropName: String in sourceData) {
            var destPropName: String = srcToDestMap[sourcePropName];
            if (destPropName == null) {
               destPropName = sourcePropName;
            }
            propDataMapped[destPropName] = sourceData[sourcePropName];
         }
         return propDataMapped;
      }

      private static function buildTypeInfoFor(type: Class): void {
         const typeInfoXML: XML = describeType(type).factory[0];
         const typeInfo: Vector.<PropInfo> = new Vector.<PropInfo>();

         const errs: Array = new Array();
         function pushError(message: String, ...params): void {
            errs.push(
               StringUtil.substitute.apply(null, [message].concat(params))
            );
         }
         function pushMappingError(propName: String,
                                   message: String,
                                   ...params): void {
            message =
               "Mapping error for property '" + propName + "': " + message;
            pushError.apply(null, [message].concat(params));
         }

         for each (var propsInfoList:XMLList in [typeInfoXML.accessor,
                                                 typeInfoXML.variable,
                                                 typeInfoXML.constant]) {
            for each (var propInfoXML: XML in propsInfoList) {
               const propMetadata: XMLList = propInfoXML.metadata;
               const metaRequired: XML = propMetadata.(@name == "Required")[0];
               const metaOptional: XML = propMetadata.(@name == "Optional")[0];
               var metaActual: XML = metaRequired != null
                                        ? metaRequired
                                        : metaOptional;
               const skipProperty: Boolean =
                        propMetadata.(@name == "SkipProperty")[0];

               if (metaActual == null && !skipProperty) {
                  continue;
               }

               const propInfo: PropInfo = new PropInfo();
               propInfo.skipProperty = skipProperty;
               propInfo.name = propInfoXML.@name[0];
               propInfo.required = metaRequired != null;
               propInfo.optional = metaOptional != null;

               if (!propInfo.includeInConstruction) {
                  continue;
               }

               if (propInfo.required && propInfo.optional) {
                  pushError(
                     "Property '{0}' has both - [Required] and [Optional] - "
                        + "metadata tags declared which is illegal.",
                     propInfo.name
                  );
                  continue;
               }

               propInfo.alias = metaActual.arg.(@key == "alias").@value[0];
               var aggregatesProps: String =
                      metaActual.arg.(@key == "aggregatesProps" ).@value[0];
               if (aggregatesProps != null) {
                  propInfo.aggregatesProps =
                        aggregatesProps
                           .replace(WHITESPACE_REGEXP, "")
                           .split(",");
               }
               propInfo.aggregatesPrefix =
                  metaActual.arg.(@key == "aggregatesPrefix" ).@value[0];


               if (propInfo.alias != null && propInfo.isAggregator) {
                  pushError(
                     "Property '{0}' has both - alias and aggregatesProps "
                        + "(or aggregatesPrefix) - attributes defined which "
                        + "is illegal.",
                     propInfo.name
                  );
                  continue;
               }
               if (propInfo.alias == null) {
                  propInfo.alias = propInfo.name;
               }
               if (propInfo.aggregatesProps != null
                      && propInfo.aggregatesPrefix != null) {
                  pushError(
                     "Property '{0}' has both - aggregatesProps and "
                        + "aggregatesPrefix - attributes defined which "
                        + "is illegal.", propInfo.name
                  );
                  continue;
               }
               if (propInfo.typeIsPrimitive && propInfo.isAggregator) {
                  pushError(
                     "aggregatesProps and aggregatesPrefix attributes not "
                        + "allowed in [Optional|Required] tags attached to "
                        + "a property of primitive type, but such tag was "
                        + "found on property '{0}'",
                     propInfo.name
                  );
                  continue;
               }

               const propClassName: String =
                        String(propInfoXML.@type[0]).replace("&lt;", "<");
               propInfo.type = getDefinitionByName(propClassName) as Class;

               if (propInfo.type === type && metaRequired != null) {
                  pushError(
                     "Property '{0}' is marked with [Required] and is of "
                        + "exact type as given object type {1}. This is not "
                        + "legal. Use [Optional] instead.",
                     propInfo.name, type
                  );
                  continue;
               }

               const metaPropsMap: XML = propMetadata.(@name == "PropsMap")[0];
               propInfo.readOnly =
                  propInfoXML.name() == "constant"
                     || propInfoXML.name() == "accessor"
                           && propInfoXML.@access[0] == "readonly";


               if (propInfo.typeIsPrimitive) {
                  if (metaPropsMap != null) {
                     pushError(
                        "[PropsMap] not allowed on a property '{0}' of "
                           + "primitive type", propInfo.name
                     );
                     continue;
                  }
                  if (propInfo.readOnly) {
                     pushError(
                        "Read-only property '{0}' of primitive type {1}",
                        propInfo.name, propInfo.type
                     );
                     continue;
                  }
               }

               if (metaPropsMap != null) {
                  propInfo.srcToDestMap = new Object();
                  const srcToDestMap: Object = propInfo.srcToDestMap;
                  const destToSrcMap: Object = new Object();
                  for each (var sdPair: XML in metaPropsMap.arg) {
                     const sourceProp: String = sdPair.@key[0];
                     const destProp: String = sdPair.@value[0];
                     if (destProp.length == 0) {
                        pushMappingError(
                           propInfo.name,
                           "invalid destination (value) prop '{0}' for "
                              + "source (key) prop {'1'}",
                           destProp, sourceProp
                        );
                        continue;
                     }
                     if (srcToDestMap[sourceProp] !== undefined) {
                        pushMappingError(
                           propInfo.name,
                           "source (key) prop '{0}' duplication (destination "
                              + "(value) prop '{1}')",
                           sourceProp, destProp
                        );
                     }
                     else {
                        srcToDestMap[sourceProp] = destProp;
                     }
                     if (destToSrcMap[destProp] !== undefined) {
                        pushMappingError(
                           "destination (value) prop '{0}' duplication (source "
                              + "(key) prop '{1}')",
                           destProp, sourceProp
                        );
                     }
                     else {
                        destToSrcMap[destProp] = sourceProp;
                     }
                  }
               }


               const propTypeInfoXML: XML = describeType(propInfo.type);
               const propTypeName: String = propTypeInfoXML.@name[0];
               propInfo.typeIsArray = propTypeName == "Array";
               propInfo.typeIsVector = TypeChecker.isVectorName(propTypeName);
               propInfo.typeIsList = propTypeInfoXML
                                        .factory.implementsInterface
                                        .(@type == "mx.collections::IList")[0]
                                        != null;
               if (propInfo.typeIsAnyCollection) {
                  // elementType attribute is mandatory element for Array and IList properties
                  var propItemTypeName: String =
                         metaActual.arg.(@key == "elementType").@value[0];
                  if (!propInfo.typeIsVector && propItemTypeName == null) {
                     pushError(
                        "Property '{0}' is of [class IList] or [class Array] "
                           + "type and therefore requires elementType "
                           + "attribute of [Required|Optional] metadata tag "
                           + "declared.",
                        propInfo.name
                     );
                     continue;
                  }
                  // [PropsMap] on collections not supported
                  if (metaPropsMap != null) {
                     pushError(
                        "[PropsMap] not allowed on a property '{0}' of "
                           + "collection type",
                        propInfo.name
                     );
                     continue;
                  }

                  if (propInfo.typeIsVector) {
                     propItemTypeName = propClassName.substring(
                        propClassName.indexOf("Vector.<") + 8,
                        propClassName.length - 1
                     );
                  }
                  propInfo.itemType =
                     getDefinitionByName(propItemTypeName) as Class;
               }
               typeInfo.push(propInfo);
            }
         }

         if (errs.length != 0) {
            throw new AppError(
               "Errors found in metadata of " + type + ":\n" + errs.join("\n")
            );
         }

         TYPE_INFO_HASH.setInfo(type, typeInfo);
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

import flash.utils.Dictionary;

import utils.TypeChecker;

class TypeProcessors
{
   public function TypeProcessors(creator: Function,
                                  sameDataChecker: Function) {
      this.creator = creator;
      this.sameDataChecker = sameDataChecker;
   }

   public var creator: Function;
   public var sameDataChecker: Function;
}


class MappingError extends Error
{
   public function MappingError(message:String) {
      super(message);
   }
}

class TypeInfoHash
{
   private const HASH: Dictionary = new Dictionary();

   public function getInfo(type: Class): Vector.<PropInfo> {
      return HASH[type];
   }

   public function setInfo(type: Class, info: Vector.<PropInfo>): void {
      HASH[type] = info;
   }

   public function hasInfo(type: Class): Boolean {
      return getInfo(type) != null;
   }
}

class PropInfo
{
   public var name: String = null;
   public var alias: String = null;
   public var readOnly: Boolean = false;
   public var required: Boolean = false;
   public var optional: Boolean = false;
   public function get includeInConstruction(): Boolean {
      return required || optional;
   }

   public var skipProperty: Boolean;

   public var type: Class = null;
   public function get typeIsPrimitive(): Boolean {
      return TypeChecker.isPrimitiveClass(type);
   }
   public function get typeIsGenericObject(): Boolean {
      return type === Object;
   }
   public var typeIsList: Boolean = false;
   public var typeIsArray: Boolean = false;
   public var typeIsVector: Boolean = false;
   public function get typeIsAnyCollection(): Boolean {
      return typeIsList || typeIsVector || typeIsArray;
   }
   public var itemType: Class = null;

   public var aggregatesPrefix: String = null;
   public var aggregatesProps: Array = null;
   public function get isAggregator(): Boolean {
      return aggregatesPrefix != null || aggregatesProps != null;
   }

   public var srcToDestMap: Object = null;
   public function get hasMapping(): Boolean {
      return srcToDestMap != null;
   }
}

