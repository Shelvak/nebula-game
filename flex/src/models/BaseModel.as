package models
{
   import com.adobe.errors.IllegalStateError;
   
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   import interfaces.IEqualsComparable;
   
   import models.events.BaseModelEvent;
   
   import mx.collections.ICollectionView;
   import mx.collections.IList;
   import mx.events.PropertyChangeEvent;
   
   import namespaces.client_internal;
   import namespaces.prop_name;
   
   import utils.DateUtil;
   import utils.EventUtils;
   import utils.Objects;
   import utils.TypeChecker;
   import utils.assets.ImagePreloader;
   
   
   /** 
    * @see models.events.BaseModelEvent#PENDING_CHANGE
    * @eventType models.events.BaseModelEvent.PENDING_CHANGE
    */
   [Event(name="pendingChange", type="models.events.BaseModelEvent")]
   
   /**
    * @see models.events.BaseModelEvent#FLAG_DESTRUCTION_PENDING_SET
    * @eventType models.events.BaseModelEvent.FLAG_DESSTRUCTION_PENDING_SET
    */
   [Event(name="flagDestructionPendingSet", type="models.events.BaseModelEvent")]
   
   /**
    * @see models.events.BaseModelEvent#MODEL_ID_CHANGE
    * @eventType models.events.BaseModelEvent.MODEL_ID_CHANGE
    */
   [Event(name="modelIdChange", type="models.events.BaseModelEvent")]
   
   /**
    * @see mx.events.PropertyChangeEvent
    * @eventType mx.events.PropertyChangeEvent.PROPERTY_CHANGE
    */   
   [Event(name="propertyChange", type="mx.events.PropertyChangeEvent")]
   
   
   /**
    * Defines common fields and behaviour for all models.
    */
   public class BaseModel extends EventDispatcher implements IBaseModel
   {
      private static const WHITESPACE_REGEXP:RegExp = /\s/g;
      
      /**
       * Reference to <code>ImagePreloader</code> singleton.
       */
      protected static function get IMG() : ImagePreloader {
         return ImagePreloader.getInstance();
      }
      
      /**
       * Reference to <code>ModelLocator</code> singleton.
       */
      protected static function get ML() : ModelLocator {
         return ModelLocator.getInstance();
      }
      
      
      /**
       * Checks if the given two or more instances of <code>BaseModel</code>
       * are equal. Two models are considered to be equal if they are:
       * <ul>
       *    <li>of the same actual type <strong>and</strong></li>
       *    <li>id's of those two models are equal</li>
       * </ul>
       * 
       * @param params List of instances of <code>BaseModel</code>
       * 
       * @return <code>true</code> if all given models are equal or <code>false</code>
       * otherwise
       */
      public static function modelsAreEqual(... params) : Boolean {
         var model:BaseModel = params[0];
         for each (var anotherModel:BaseModel in params) {
            if (model.CLASS != anotherModel.CLASS || model.id != anotherModel.id)
               return false;
         }
         return true;
      }
      
      
      private static const TYPE_POST_PROCESSORS:Dictionary = new Dictionary();
      /**
       * Sets post processor function for properties of given type.
       * 
       * @param type wich must have a post processor function called on each property of that type
       * encountered by <code>createModel()</code>
       * @param postProcessor a function wich will be called on a property of a given type after
       * it has been set. Function signature should be:
       * <pre>
       *    postProcessor(instance:BaseModel, property:String, value:*) : void
       * </pre>
       * Here:
       * <ul>
       *    <li><code>instance</code> - a model wich is beeing created</li>
       *    <li><code>property</code> - name of the property wich has been set</li>
       *    <li><code>value</code> - current value of that property</li>
       * </ul>
       */
      public static function setTypePostProcessor(type:Class, postProcessor:Function) : void {
         TYPE_POST_PROCESSORS[type] = postProcessor;
      }
      
      client_internal static const TYPE_PROCESSORS:Dictionary = new Dictionary();
      /**
       * Sets processor function to handle properties of specific type.
       * 
       * @param type a Class that requires special handling
       * @param processor function that will be called when an object of the given type needs to be constructed.
       * Signature of the function should be: <code>function(currValue:*, value:Object) : Object</code>.
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
         Objects.paramNotNull("type", processor);
         Objects.paramNotNull("processor", processor);
         client_internal::TYPE_PROCESSORS[type] = processor;
      }
      private static function getTypeProcessor(type:Class) : Function {
         return client_internal::TYPE_PROCESSORS[type];
      }
      
      /**
       * Creates a model and loads values to appropriate fields from a provided
       * object.
       * <ul>
       *    <li>Properties that need to be filled must be marked with either
       *        <code>[Optional]</code> or <code>[Required]</code> metadata tags;</li>
       *    <li>Properties of primitive type are copied from the source object;</li>
       *    <li>Properties that are of <code>BaseModel</code> type will cause recursive call to
       *        <code>createModel()</code>. A model can't have property of the same type (or subtype)
       *        as the model marked with <code>[Required]</code> and you can't created any similar loops
       *        containing only <code>[Required]</code> tag;</li>
       *    <li>Properties of <code>Array</code> and <code>IList</code> type must have
       *        <code>elementType</code> attribute of <code>[Required|Optional]</code> metadata tag defined.
       *        Properties of <code>Vector</code> type do not need this attribute. Currently element type can
       *        only be a primitive type or derivative of <code>BaseModel</code>;</li>
       *    <li>You can define properties of <code>BaseModel</code> as aggregators (<code>aggregatesProps
       *        </code> and <code>aggregatesPrefix</code> attributes of <code>[Required|Optional]</code>)
       *        tags. See <a target="_blank" href="http://wiki-dev.nebula44.com/wiki/Nebula_44:ClientCode">
       *        wiki page</a> for more information on this feature;</li>
       *    <li>If source object contains properties of different type than those that are defined
       *        in destination class, method invocation will end up with error thrown;</li>
       *    <li>Works only with dynamicly created properties of the data object.</li>
       * 
       * @param type Type of a model to be created.
       * @param data Raw object containing data to be loaded to the model.
       * 
       * @return Newly created model with values loaded to its properties from
       * the data object.
       * 
       * @throws Error if some properties in source object do not exist in the
       * destination object or if some of them are of different type. 
       */
      public static function createModel(type:Class, data:Object) : * {
         Objects.paramNotNull("type", type);
         
         return createModelImpl(type, null, data);
      };
      
      private static function createModelImpl(type:Class, model:Object, data:Object) : Object {
         Objects.paramNotNull("type", type);
         
         if (data == null)
            return null;
         
         // type processors come first so that special types could be created directly using 
         // createModel() method
         var typeProcessor:Function = getTypeProcessor(type);
         if (typeProcessor != null) {
            return typeProcessor.call(null, model, data);
         }
         
         model = new type();
         var info:XML = Objects.describeType(type).factory[0];
         
         var errors:Array = [];
         function pushError(message:String) : void {
            errors.push(message);
         }
         function copyProperty(propInfo:XML) : void
         {
            var propMetadata:XMLList = propInfo.metadata;
            var metaRequired:XML = propMetadata.(@name == "Required")[0];
            var metaOptional:XML = propMetadata.(@name == "Optional")[0];
            
            // Skip the property if its not required
            if (metaRequired == null && metaOptional == null)
               return;
            
            // Its illegal to declare both tags
            if (metaRequired != null && metaOptional != null) {
               pushError(
                  "Property '" + propName + "' has both - [Required] and [Optional] - " +
                  "metadata tags declared which is illegal."
               );
               return;
            }
            
            var srvMeta:XML = metaRequired ? metaRequired : metaOptional;
            var propName:String = propInfo.@name[0];
            var propAlias:String = srvMeta.arg.(@key == "alias").@value[0];
            var aggregatesProps:String = srvMeta.arg.(@key == "aggregatesProps").@value[0];
            var aggregatesPrefix:String = srvMeta.arg.(@key == "aggregatesPrefix").@value[0];
            
            if ((aggregatesProps != null || aggregatesPrefix != null) && propAlias != null) {
               pushError(
                  "Property '" + propName + "' on class '" + type + "' has both - alias and aggregatesProps " +
                  "(or aggregatesPrefix) - attributes defined which is illegal."
               );
               return;
            }
            if (aggregatesProps != null && aggregatesPrefix != null) {
               pushError(
                  "Property '" + propName + "' on class '" + type + "' has both - aggregatesProps and " +
                  "aggregatesPrefix - attributes defined which is illegal."
               );
               return;
            }
            
            if (propAlias == null)
               propAlias = propName;
            
            var propClass:Class = getDefinitionByName(propInfo.@type[0]) as Class;
            var propClassName:String = getQualifiedClassName(propClass);
            
            // Aggregator comes first
            if (aggregatesProps != null || aggregatesPrefix != null) {
               
               // aggregatesProps and aggregatesPrefix not allowed for primitives
               if (TypeChecker.isPrimitiveClass(propClass)) {
                  pushError(
                     "aggregatesProps and aggregatesPrefix attributes not allowed in [Optional] and " +
                     "[Required] tags attached to a property of primitive type, but such tag was found " +
                     "on property '" + propName + "' of type " + type
                  );
                  return;
               }
               
               var aggrData:Object;
               
               // aggregates props
               if (aggregatesProps != null) {
                  aggregatesProps = aggregatesProps.replace(WHITESPACE_REGEXP, "");
                  aggrData = Objects.extractProps(aggregatesProps.split(","), data);
               }
                  // aggregates prefix
               else
                  aggrData = Objects.extractPropsWithPrefix(aggregatesPrefix, data);
               
               if (!Objects.hasAnyProp(aggrData)) {
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
                  model[propName] = createModel(propClass, aggrData);
               return;
            }
            
            // Property does not exist and property is required
            if (metaRequired != null && data[propAlias] === undefined) {
               pushError(
                  "Property '" + propAlias + "' does not exist in source object but " +
                  "is required by " + type + "."
               );
               return;
            }
            
            // Skip null and undefined values in source object
            if (data[propAlias] == null)
               return;
            
            // Special treatment for Date fields
            if (propClass == Date) {
               try {
                  model[propName] = DateUtil.parseServerDTF(data[propAlias], false);
               }
               catch (e:Error) {
                  pushError(
                     "Error while parsing [Date] property '" + propAlias +
                     "'. Error message is: " + e.message + "."
                  );
                  return;
               }
            }
            // Simple types
            else if (TypeChecker.isPrimitiveClass(propClass)) {
               if (!TypeChecker.isOfPrimitiveType(data[propAlias])) {
                  pushError(
                     "'" + propAlias + "' property in source object is " +
                     getQualifiedClassName(data[propAlias]) + " but " + propClass + 
                     " was expected in destination object [" + type + "]."
                  );
                  return;
               }
               else
                  // Safely copy primitive property value
                  model[propName] = data[propAlias];
            }
            // Raw object type: just copy the source and don't run any checks
            else if (propClassName == "Object")
               model[propName] = data[propAlias];
            // type processor
            else if (getTypeProcessor(propClass) != null) {
               var propValue:Object = createModelImpl(propClass, model[propName], data[propAlias]);
               if (model[propName] !== propValue)
                  model[propName] = propValue;
            }
            else {
               var propInstance:Object = new propClass();
               var isVector:Boolean = TypeChecker.isVector(propInstance);
               
               // Collections
               if (propInstance is Array || propInstance is IList || isVector) {
                  // elementType attribute is mandatory element for Array and IList properties
                  var itemType:String = srvMeta.arg.(@key == "elementType").@value[0];
                  if (!isVector && itemType == null) {
                     pushError(
                        "Property '" + propName + "' is of [class IList] or [class Array] type and " +
                        "therefore requires elementType attribute of [Required|Optional] metadata tag " +
                        "declared."
                     );
                     return;
                  }
                  
                  if (isVector) {
                     itemType = propClassName.substring(
                        propClassName.indexOf("Vector.<") + 8,
                        propClassName.length - 1
                     );
                  }
                  
                  // Collections can only contain primitive types or BaseModel
                  var itemClass:Class = getDefinitionByName(itemType) as Class;
//                  var itemInstance:Object = new itemClass();
//                  if (!TypeChecker.isPrimitiveClass(itemClass) && !(itemInstance is BaseModel)) {
//                     pushError(
//                        "Property '" + propName + "' is a collection but the declared item type " + itemClass +
//                        " is not supported. BaseModel.createModel() only supports primitive types and " +
//                        "models.BaseModel as item type for collections."
//                     );
//                     return;
//                  }
                  
                  // Special case for ModelsCollection. See its documentation for more information.
                  if (propInstance is ModelsCollection) {
                     model[propName] = createCollection(ModelsCollection, itemClass, data[propAlias]);
                     return;
                  }
                  
                  // set model property collection
                  model[propName] = propInstance;
                  
                  // To distinguish between primitive type and other types
                  var createItem:Function;
                  if (TypeChecker.isPrimitiveClass(itemClass))
                     createItem = function(data:Object) : Object {
                        return data;
                     };
                  else
                     createItem = function(data:Object) : Object {
                        return BaseModel.createModel(itemClass, data);
                     };
                  
                  // Different interfaces of different collections require small but
                  // different piece of code
                  var addItem:Function;
                  if (isVector || propInstance is Array)
                     addItem = function(item:Object) : void {
                        propInstance.push(item);
                     };
                  else if (propInstance is IList)
                     addItem = function(item:Object) : void {
                        propInstance.addItem(item);
                     };
                  
                  // Now create items
                  for each (var item:Object in data[propAlias]) {
                     addItem(createItem(item));
                  }
               }
               else {
                  if (propInstance is type && metaRequired) {
                     pushError(
                        "Property '" + propName + "' is marked with [Required] and is of exact type " +
                        "as given model type " + type + ". This is not legal. Use [Optional] instead."
                     );
                     return;
                  }
                  model[propName] = createModel(propClass, data[propAlias]);
               }
            }
            // run post-processor function on the property, if any
            var postProcessor:Function = TYPE_POST_PROCESSORS[propClass]
            if (postProcessor != null)
               postProcessor(model, propName, model[propName]);
         };
         
         for each (var propInfo:XML in info.accessor) {
            copyProperty(propInfo);
         }
         for each (propInfo in info.variable) {
            copyProperty(propInfo);
         }
         
         if (errors.length != 0)
            throw new Error(
               errors.join("\n") + "\nFix properties in " + type + " or see to it that source " +
               "object holds values for all required properties of correct type."
            );
         
         callAfterCreate(model, data);
         
         return model;
      }
      
      private static function callAfterCreate(target:Object, data:Object) : void {
         Objects.paramNotNull("target", target);
         Objects.paramNotNull("data", data);
         try {
            (target["afterCreateModel"] as Function).call(null, data);
         }
         // ignore this error since afterCreateModel() method is optional and dynamic read of this method
         // form the static class ends up with this error
         catch (err:ReferenceError) {}
      }
      
      
      /**
       * Creates a list of models of given type from the given list or array.
       * 
       * @param collectionType type of a collection to return. Must be collection class
       * implementing <code>IList</code> 
       * @param modelType type of models in the resulting list
       * @param list an <code>IList</code> or <code>Array</code> of generic objects to use as
       * data source for the resulting collection.
       * 
       * @return collection of <code>collectionType</code> type where each element is
       * of <code>modelType</code> type.
       * 
       * @throws ArgumentError when
       * <ul>
       *    <li><code>collectionType</code> does not implement <code>IList</code></li>
       *    <li>
       *       <code>list</code> does not implement <code>IList</code> and is not an
       *       <code>Array</code>
       *    </li>
       * </ul>
       * @throws Error when <code>BaseModel.createModel()</code> throws any error.
       * 
       * @see #createModel()
       */
      public static function createCollection(collectionType:Class, modelType:Class, list:Object) : *
      {
         if ( !(new collectionType() is IList) )
         {
            throw new ArgumentError(
               "[param collectionType] must be a class of collection implementing " +
               "[interface IList] but was " + collectionType
            );
         }
         if ( !(list is Array || list is IList) )
         {
            throw new ArgumentError(
               "[param list] must be instance of [class Array] or [interface IList]"
            );
         }
         var collection:IList = IList(new collectionType());
         var item:Object;
         
         // Special case for ModelsCollection as that bastard has performance issues. See
         // documentation of ModelsCollection for more insight on this problem.
         if (collection is ModelsCollection)
         {
            var source:Array = new Array();
            for each (item in list)
            {
               source.push(createModel(modelType, item));
            }
            return new collectionType(source);
         }
         
         for each (item in list)
         {
            collection.addItem(createModel(modelType, item));
         }
         return collection;
      }
      
      
      public function BaseModel()
      {
         super();
         addSelfEventHandlers();
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      /**
       * Copies given properties from the given model to this model.
       * 
       * @param source Source model. If <code>null</code>, method will return immediately, nothing
       * will be copied and <code>afterCopyProperties()</code> won't be called.
       * @param ignoreSkipProperty if <code>true</code>, <code>[SkipProperty]</code> attached to
       * properties won't have any effect. <code>[SkipProperty]</code> does not have any effect if
       * you provide the third parameter other than <code>null</code> or empty array
       * @param props List of properties to be copied. If no properties are given all public
       * properties (without <code>[SkipProperty]</code> tag, unless <code>ingnoreSkipProperty</code>
       * is <code>true</code>) will be copied.
       * 
       * @throws Error if property can't be found or is not accessible.
       * @throws Error if <code>model</code> is of different type than
       * <code>this</code>.
       */
      public function copyProperties(source:BaseModel, ignoreSkipProperty:Boolean = false, props:Array = null) : void
      {
         if (! source)
         {   
            return;
         }
         if (!(source is CLASS))
         {
            throw new Error("'source' is " + source.className + " but " + className + " was expected.");
         }
         var typeInfo:XML = Objects.describeType(CLASS).factory[0];
         ignoreSkipProperty = ignoreSkipProperty || props && props.length > 0;
         if (!props || props.length == 0)
         {
            props = Objects.getPublicProperties(CLASS);
         }
         for each (var prop:String in props)
         {
            if (!(this[prop] == source[prop] || (this[prop] is IEqualsComparable) && IEqualsComparable(this[prop]).equals(source[prop])))
            {
               var propInfo:XML = typeInfo.accessor.(@name == prop)[0];
               if (!propInfo)
               {
                  propInfo = typeInfo.variable.(@name == prop)[0];
               }
               if (ignoreSkipProperty || !propInfo.metadata.(@name == "SkipProperty")[0])
               {
                  this[prop] = source[prop];
               }
            }
         }
         afterCopyProperties(source, props);
      }
      
      
      /**
       * Checks if this instance is equal to a given model. If <code>model</code> is
       * <code>null</code> returns <code>false</code>.
       * 
       * @see interfaces.IEqualsComparable#equals()
       */
      public function equals(o:Object) : Boolean
      {
         if (o == this)
         {
            return true;
         }
         if (o is BaseModel)
         {
            return modelsAreEqual(this, BaseModel(o));
         }
         return false;
      }
      
      
      /**
       * <code>BaseModel.hashKey()</code> returns key of the following format:
       * <pre>{className},{id}</pre>
       */
      public function hashKey() : String
      {
         return className + "," + id;
      }
      
      
      public override function toString() : String
      {
         return "[class: " + className + ", id: " + id + "]";
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var f_destructionPending:Boolean = false;
      [Bindable(event="flagDestructionPendingSet")]
      /**
       * Indicates if this model (probably corresponding controllers and components) will be destroyed in the near future.
       * If relevant for concrete model, component or controller, they should take value of this property into account
       * when performing their operations. This flag my be set with <code>setFlag_destructionPending()</code> method.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="flagDestructionPendingSet")]</i></p>
       */
      public function get flag_destructionPending() : Boolean
      {
         return f_destructionPending;
      }
      
      
      /**
       * Use this to mark the model as pending for destruction.
       * 
       * @see #flag_destructionPending
       */
      public function setFlag_destructionPending() : void
      {
         f_destructionPending = true;
         dispatchFlagDestructionPendingSetEvent();
      }
      
      
      /**
       * A reference to the class object of this object.
       */
      public function get CLASS() : Class
      {
         return Objects.getClass(this);
      }
      
      
      /**
       * Fully qualified class name of this object.
       */
      public function get className() : String
      {
         return Objects.getClassName(this);
      }
      
      
      prop_name static const id:String = "id";
      private var _id:int = 0;
      [Optional]
      [Bindable(event="modelIdChange")]
      /**
       * Id of the model's instance. Probably not all models needs it.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Optional]<br/>
       * [Bindable(event="modelIdChange")]</i></p>
       */
      public function set id(value:int) : void
      {
         _id = value;
         dispatchIdChangeEvent();
         dispatchPropertyUpdateEvent(prop_name::id, value);
      }
      /**
       * @private 
       */
      public function get id() : int
      {
         return _id;
      }
      
      
      private var _fake:Boolean = false;
      /**
       * If true, that means this model is not real and later might me replaced with a real model.
       * 
       * <p>Default value is <code>false</code>.</p>
       */
      public function set fake(value:Boolean) : void
      {
         if (_fake != value)
         {
            _fake = value;
         }
      }
      /**
       * @private
       */
      public function get fake() : Boolean
      {
         return _fake;
      }
      
      
      private var _pending:Boolean = false;
      [SkipProperty]
      [Bindable(event="pendingChange")]
      /**
       * Indicates if this instance is in some sort of transient state. Mostly used when a message has been sent to the
       * server concerning this instance and it needs to be updated (ore something else must be done) when response
       * message is recieved from the server.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [SkipProperty]<br/>
       * [Bindable(event="modelPendingChange")]</i></p>
       */
      public function set pending(value:Boolean) : void
      {
         if (_pending != value)
         {
            _pending = value;
            dispatchPendingChangeEvent();
         }
      }
      /**
       * @private
       */
      public function get pending() : Boolean
      {
         return _pending;
      }
      
      
      /**
       * Is called when <code>BaseModel.createModel()</code> has finished creation of a model.
       * You can hook any additional postprocessing to be performed after creation of a model
       * in this method. You must call invoke <code>super.afterCreateModel()</code> when overriding
       * this method.
       * 
       * @param data A generic object which was used as source for populating properties
       */
      protected function afterCreateModel(data:Object) : void
      {
         refresh();
      }
      
      
      /**
       * Is called when <code>this.copyProperties()</code> has copied all properties. You can hook
       * any additional postprocessing to be performed in this method after properties have been
       * copied. You must call invoke <code>super.afterCreateModel()</code> when overriding this method.
       * 
       * @param source a model which was used as source object for populating properties
       * @param props see <code>copyProperties()</code>
       * 
       * @see #copyProperties()
       */
      protected function afterCopyProperties(source:BaseModel, props:Array) : void
      {
         refresh();
      }
      
      
      /**
       * Call to refresh any collections in this model having filters dependent on some properties of
       * this model. Is called automaticly in <code>afterCreateModel()</code> and <code>afterCopyProperties()</code>.
       */
      public function refresh() : void
      {
         for (var collectionProp:String in collectionsFilterProperties)
         {
            if (this[collectionProp])
            {
               ICollectionView(this[collectionProp]).refresh();
            }
         }
      }
      
      
      /**
       * A hash which maps names of properties (public or protected) referencing collections to an
       * array of names of properties that are used in those collections filter functions.
       * Override this if you need any <code>ICollectionView</code> instance to get its <code>refresh()</code>
       * method called when any of properties defined by the custom model class and given in the corresponding
       * array has changed.
       * 
       * <p>BaseModel.collectionsFiltersProperties()</p> returns empty hash.
       */
      protected function get collectionsFilterProperties() : Object
      {
         return new Object();
      }
      
      
      private var _filterPropertiesCollections:Object;
      /**
       * Maps names of properties used by collections' filters to names of properties referencing
       * those collections.
       * 
       * @see #collectionsFilterProperties()
       */
      private function get filterPropertiesCollections() : Object
      {
         if (!_filterPropertiesCollections)
         {
            _filterPropertiesCollections = new Object();
            for (var collectionProp:String in collectionsFilterProperties)
            {
               for each (var filterProp:String in collectionsFilterProperties[collectionProp])
               {
                  var collections:Array = _filterPropertiesCollections[filterProp];
                  if (!collections)
                  {
                     collections = new Array();
                     _filterPropertiesCollections[filterProp] = collections;
                  }
                  collections.push(collectionProp);
               }
            }
         }
         return _filterPropertiesCollections;
      }
      
      
      /* ########################### */
      /* ### SELF EVENT HANDLERS ### */
      /* ########################### */
      
      
      private function addSelfEventHandlers() : void
      {
         var addPropChangeHandler:Boolean = false;
         for (var collectionProp:String in collectionsFilterProperties)
         {
            addPropChangeHandler = true;
            break;
         }
         if (addPropChangeHandler)
         {
            addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this_propertyChangeHandler);
         }
      }
      
      
      private function this_propertyChangeHandler(event:PropertyChangeEvent) : void
      {
         for each (var collectionProp:String in filterPropertiesCollections[event.property])
         {
            ICollectionView(this[collectionProp]).refresh();
         }
      }
      
      
      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */
      
      
      private function dispatchFlagDestructionPendingSetEvent() : void
      {
         dispatchSimpleEvent(BaseModelEvent, BaseModelEvent.FLAG_DESTRUCTION_PENDING_SET);
      }
      
      
      /**
       * Invoke this to dispatch <code>BaseModelEvent.PENDING_CHANGE</code> event.
       * (<code>PropertyChangeEvent</code> will be also dispatched) This event is dispatched
       * autommaticly by <code>BaseModel</code> class.
       */
      protected function dispatchPendingChangeEvent() : void
      {
         dispatchSimpleEvent(BaseModelEvent, BaseModelEvent.PENDING_CHANGE);
      }
      
      
      /**
       * Invoke this to dispatch <code>BaseModelEvent.ID_CHANGE</code> event
       * (<code>PropertyChangeEvent</code> will be also dispatched). This event is dispatched
       * autommaticly by <code>BaseModel</code> class.
       */
      protected function dispatchIdChangeEvent() : void
      {
         dispatchSimpleEvent(BaseModelEvent, BaseModelEvent.MODEL_ID_CHANGE);
      }
      
      
      /**
       * Creates <code>PropertyChangeEvent</code> event of <code>PropertyChangeEventKind.UPDATE</code>
       * kind and dispatches it.
       * 
       * @param property
       * @param newValue
       * @param oldValue
       * @param source if <code>null</code>, <code>this</code> will be used
       * 
       * @see mx.event.PropertyChangeEvent#createUpdateEvent()
       */
      protected function dispatchPropertyUpdateEvent(property:String, newValue:*, oldValue:* = null, source:Object = null) : void
      {
         if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
         {
            if (!source)
            {
               source = this;
            }
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(source, property, oldValue, newValue));
         }
      }
      
      
      /**
       * @see utils.EventUtils#dispatchSimpleEvent()
       */
      protected function dispatchSimpleEvent(CLASS:Class, type:String) : void
      {
         EventUtils.dispatchSimpleEvent(this, CLASS, type);
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      /**
       * Prefixes the given message with "Model ... is in illegal state. " and throws the error.
       */
      protected function throwIllegalStateError(message:String) : void {
         throw new IllegalStateError("Model " + this + " is in illegal state. " + message);
      }
   }
}