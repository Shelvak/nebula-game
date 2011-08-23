package utils
{
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   
   import namespaces.client_internal;
   

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
       * Extracts all properties starting with given prefix from the source object to a new object and retuns
       * that object. If no properties are found, the object returned will also have no properties.
       * 
       * <p>This method loops through all dynamic properties of the source object so it take time
       * to extract properties from large objects.</p>
       * 
       * @param prefix <b>Not null. Not empty string.</b>
       * @param source source object that holds properties.
       *               <b>Not null. Generic object only.</b>
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
       *                   <b>Not null. Not empty.</b>
       * @param source source object that holds properties.
       *               <b>Not null. Generic object only.</b>
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
       * @return true if obj has any keys, false otherwise
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
      
      
      /* ################### */
      /* ### AUTO-CREATE ### */
      /* ################### */
      
      private static const WHITESPACE_REGEXP:RegExp = /\s/g;
      
      client_internal static const TYPE_PROCESSORS:Dictionary = new Dictionary();
      /**
       * Sets processor function to handle properties of specific type.
       * 
       * @param type a Class that requires special handling
       * @param processor function that will be called when an object of the given type needs to be constructed.
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
      
      public static function createImpl(type:Class, object:Object, data:Object, itemType:Class = null) : Object {
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
         
         // TODO: replace with type processor. Left over only not to break old tests.
         if (type == Date)
            return DateUtil.parseServerDTF(String(data), false);
         
         // the rest operations also need an instance of given type
         // assuming that all types from this point forward have constructors without arguments
         if (object == null)
            object = new type();
         
         // collections
         var isVector:Boolean = TypeChecker.isVector(object);
         var isArray:Boolean = object is Array;
         var isList:Boolean = object is IList;
         var isCollection:Boolean = isVector || isArray || isList;
         if (isCollection) {
            // different interfaces of different collections require small but different piece of code
            var addItem:Function;
            if (isVector || isArray)
               addItem = function(item:Object) : void { object.push(item) };
            else
               addItem = function(item:Object) : void { object.addItem(item) };
            // now create items
            for each (var itemData:Object in data) {
               addItem(createImpl(itemType, null, itemData));
            }
            
            // afterCreate() callback is not supported on the collections because including this feature
            // would be too much dependent on internals of each collection type
            return object;
         }
         
         var errors:Array = new Array();
         function pushError(message:String, ... params) : void {
            errors.push(StringUtil.substitute(message, params));
         }
         
         // other types: assuming they have metadata tags attached to properties
         var typeInfo:XML = describeType(type).factory[0];
         for each (var propsInfoList:XMLList in [typeInfo.accessor, typeInfo.variable, typeInfo.constant]) {
            for each (var propInfo:XML in propsInfoList) {
               var propMetadata:XMLList = propInfo.metadata;
               var propName:String  = propInfo.@name[0];
               var propClassName:String = String(propInfo.@type[0]).replace("&lt;", "<");
               var propClass:Class = getDefinitionByName(propClassName) as Class;
               var metaRequired:XML = propMetadata.(@name == "Required")[0];
               var metaOptional:XML = propMetadata.(@name == "Optional")[0];
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
               
               if (propAlias == null)
                  propAlias = propName;
               var propValue:* = object[propName];
               var propData:* = data[propAlias];
               
               function setProp(value:Object) : void {
                  if (object[propName] != value)
                     object[propName] = value;
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
                  else
                     setProp(createImpl(propClass, propValue, aggrData));
                  
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
               if (TypeChecker.isPrimitiveClass(propClass)) {
                  if (!TypeChecker.isOfPrimitiveType(propData)) {
                     pushError(
                        "Property '{0}' is of primitive type {1}, but the value '{2}' in the data object " +
                        "is of complex type {3}", propName, propClass, propData, getClass(propData)
                     );
                     continue;
                  }
               }
               
               if (getTypeProcessor(propClass) != null ||
                   TypeChecker.isPrimitiveClass(propClass) ||
                   propClass == Object) {
                  setProp(createImpl(propClass, propValue, propData));
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
                  if (propIsVector) {
                     itemTypeName = propClassName.substring(
                        propClassName.indexOf("Vector.<") + 8,
                        propClassName.length - 1
                     );
                  }
                  setProp(createImpl(propClass, propValue, propData, getDefinitionByName(itemTypeName) as Class));
               }
                  
               // other objects
               else
                  setProp(createImpl(propClass, propValue, propData));
            }
         }
         
         callAfterCreate(object, data);
         
         if (errors.length != 0)
            throw new Error(
               errors.join("\n") + "\nFix properties in " + type + " or see to it that source " +
               "object holds values for all required properties of correct type."
            );
         
         return object;
      }
      
      private static function callAfterCreate(target:Object, data:Object) : void {
         paramNotNull("target", target);
         paramNotNull("data", data);
         try {
            var afterCreateCallback:Function = target["afterCreate"]; 
            if (afterCreateCallback != null)
               afterCreateCallback.call(null, data);
         }
         // ignore this error since afterCreate() method is optional and dynamic read of this method
         // from the static class ends up with this error
         catch (err:ReferenceError) {}
      }
   }
}