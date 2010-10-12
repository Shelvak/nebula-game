package models
{
   import com.adobe.utils.DateUtil;
   
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   import interfaces.IEqualsComparable;
   
   import models.events.BaseModelEvent;
   import models.unit.Unit;
   
   import mx.collections.IList;
   import mx.events.PropertyChangeEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.utils.ObjectUtil;
   
   import utils.ClassUtil;
   import utils.TypeChecker;
   import utils.assets.ImagePreloader;
   import utils.profiler.Profiler;
   
   
   /**
    * Dispatched when <code>pending<code> property of changes.
    * 
    * @eventType models.events.BaseModelEvent.PENDING_CHANGE
    */
   [Event(name="pendingChange", type="models.events.BaseModelEvent")]
   
   /**
    * Dispached when <code>id</code> property changes.
    * 
    * @eventType models.events.BaseModelEvent.ID_CHANGE
    */
   [Event(name="idChange", type="models.events.BaseModelEvent")]
   
   
   /**
    * Defines common fields and behaviour for all models.
    */
   public class BaseModel extends EventDispatcher implements IBaseModel
   {
      /**
       * Reference to <code>ImagePreloader</code> singleton.
       */
      protected static const IMG:ImagePreloader = ImagePreloader.getInstance();
      
      
      /**
       * Reference to <code>IResourceManager</code> singleton.
       */
      protected static const RM:IResourceManager = ResourceManager.getInstance();
      
      
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
      public static function modelsAreEqual(... params) : Boolean
      {
         var model:BaseModel = params[0];
         for each (var anotherModel:BaseModel in params)
         {
            if (getQualifiedClassName(model) != getQualifiedClassName(anotherModel) ||
               model.id != anotherModel.id)
            {
               return false;
            }
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
      public static function setTypePostProcessor(type:Class, postProcessor:Function) : void
      {
         TYPE_POST_PROCESSORS[type] = postProcessor;
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
       *              as the model marked with <code>[Required]</code> and you can't created any
       *              similar loops containing only <code>[Required]</code> tag;</li>
       *    <li>Properties of <code>Array</code> and <code>IList</code> type must have
       *        <code>ArrayElementType</code> metadata tag. Properties of <code>Vector<code>
       *        type do not need this additional tag. Currently element type can be only a
       *        primitive type or derivative of <code>BaseModel</code>;</li>
       *    <li>If source object contains properties of different type than those that are defined
       *        in destination class method invocation will end up with error thrown;</li>
       *    <li>Works only with dynamicly created properties of the data object</li>
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
      public static function createModel(type:Class, data:Object) : *
      {
         if (data == null)
         {
            return null;
         }
         
         var model:BaseModel = new type();
         var info:XML = describeType(model);
         
         var errors:Array = [];
         function pushPropAbsenceError(prop:String, alias:String) : void
         {
            errors.push(
               "Property '" + prop + "' does not exist in source object but " +
               "is required by " + type + "."
            );
         };
         function pushDateFormatError(prop:String, alias:String, e:Error) : void
         {
            errors.push(
               "Error while parsing [Date] property '" + prop +
               "'. Error message is: " + e.message + "."
            );
         }
         function pushTypeMismatchError(prop:String, alias:String, destType:Class) : void
         {
            errors.push(
               "'" + prop + "' property in source object is " +
               getQualifiedClassName(data[prop]) + " but " +
               destType + " was expected in destination object [" + type + "]."
            );
         };
         function pushInvalidMetadataError(prop:String) : void
         {
            errors.push(
               "Property '" + prop + "' has both - [Required] and [Optional] - " +
               "metadata tags declared."
            );
         }
         function pushMissingArrayMetadataError(prop:String) : void
         {
            errors.push(
               "Property '" + prop + "' is of [class IList] or [class Array] type and therefore " +
               "requires [ArrayElementType] metadata tag declared."
            );
         };
         function pushUnsupportedCollectionItemTypeError(prop:String, itemType:Class) : void
         {
            errors.push(
               "Property '" + prop + "' is a collection but the declared item type " + itemType +
               " is not supported. BaseModel.createModel() only supports primitive types " +
               "and models.BaseModel as item type for collections."
            );
         };
         function pushUnsupportedPropTypeError(propName:String, propType:Class) : void
         {
            errors.push(
               "Property '" + propName + "' is of type " + propType + " which is not supported." 
            );
         };
         function pushRecursiveRequiredPropError(propName:String) : void
         {
            errors.push(
               "Property '" + propName + "' is marked with [Required] and is of exact type " +
               "as given model type " + type + ". This is not legal. Use [Optional] instead."
            );
         }
         
         function copyProperty(propInfo:XML) : void
         {
            var metadata:XMLList = propInfo.metadata;
            var metaRequired:XML = metadata.(@name == "Required")[0];
            var metaOptional:XML = metadata.(@name == "Optional")[0];
            
            // Skip the property if its not required
            if (!metaRequired && !metaOptional)
            {
               return;
            }
            
            // Its illegal to declare both tags
            if (metaRequired && metaOptional)
            {
               pushInvalidMetadataError(propName);
               return;
            }
            
            var srvMeta:XML = metaRequired ? metaRequired : metaOptional;
            var propName:String = propInfo.@name[0];
            var propAlias:String = srvMeta.arg.(@key == "alias").@value[0];
            if (!propAlias)
            {
               propAlias = propName
            }
            
            
            // Property does not exist and property is required
            if (metaRequired && data[propAlias] === undefined)
            {
               pushPropAbsenceError(propName, propAlias);
               return;
            }
            
            // Skip null and undefined values in source object
            if (data[propAlias] == null)
            {
               return;
            }
            
            var propClass:Class = getDefinitionByName(propInfo.@type[0]) as Class;
            var propClassName:String = getQualifiedClassName(propClass);
            // Special treatment for Date fields
            if (propClass == Date)
            {
               try
               {
                  model[propName] = DateUtil.parseW3CDTF(data[propAlias]);
               }
               catch (e:Error)
               {
                  pushDateFormatError(propName, propAlias, e);
                  return;
               }
            }
               // Simple types
            else if (TypeChecker.isPrimitiveClass(propClass))
            {
               if (!TypeChecker.isOfPrimitiveType(data[propAlias]))
               {
                  pushTypeMismatchError(propName, propAlias, propClass);
                  return;
               }
               else
               {
                  // Safely copy primitive property value
                  model[propName] = data[propAlias];
               }
            }
               // Raw object type: just copy the source and don't run any checks
            else if (propClassName == "Object")
            {
               model[propName] = data[propAlias];
            }
            else
            {
               var propInstance:Object = new propClass();
               var isVector:Boolean = propClassName.indexOf("Vector.<") >= 0;
               
               // Collections
               if (propInstance is Array ||
                  propInstance is IList ||
                  isVector)
               {
                  // ArrayElementType is mandatory element for Array and IList properties
                  var metaArray:XML = metadata.(@name == "ArrayElementType")[0];
                  if (!isVector && !metaArray)
                  {
                     pushMissingArrayMetadataError(propName);
                     return;
                  }
                  
                  // Collections can only contain primitive types or BaseModel
                  var itemClassName:String = null;
                  if (isVector)
                  {
                     itemClassName = propClassName.substring(
                        propClassName.indexOf("Vector.<") + 8,
                        propClassName.length - 1
                     );
                  }
                  else
                  {
                     itemClassName = metaArray.arg[0].@value[0];
                  }
                  
                  var itemClass:Class = getDefinitionByName(itemClassName) as Class;
                  var itemInstance:Object = new itemClass();
                  if (!TypeChecker.isPrimitiveClass(itemClass) && !(itemInstance is BaseModel))
                  {
                     pushUnsupportedCollectionItemTypeError(propName, itemClass);
                     return;
                  }
                  
                  // Special case for ModelsCollection. See its documentation for more information.
                  if (propInstance is ModelsCollection)
                  {
                     model[propName] = createCollection(ModelsCollection, itemClass, data[propAlias]);
                     return;
                  }
                  
                  // set model property collection
                  model[propName] = propInstance;
                  
                  // To distinguish between primitive type and BaseModel
                  var createItem:Function;
                  if (TypeChecker.isPrimitiveClass(itemClass))
                  {
                     createItem = function(data:Object) : Object
                     {
                        return data;
                     };
                  }
                  else
                  {
                     createItem = function(data:Object) : Object
                     {
                        return BaseModel.createModel(itemClass, data);
                     };
                  }
                  
                  // Different interfaces of different collections require small but
                  // different piece of code
                  var addItem:Function;
                  if (isVector || propInstance is Array)
                  {
                     addItem = function(item:Object) : void
                     {
                        propInstance.push(item);
                     };
                  }
                  else if (propInstance is IList)
                  {
                     addItem = function(item:Object) : void
                     {
                        propInstance.addItem(item);
                     };
                  }
                  
                  // Now create items
                  for each (var item:Object in data[propAlias])
                  {
                     addItem(createItem(item));
                  }
               }
               else if (propInstance is BaseModel)
               {
                  if (propInstance is type && metaRequired)
                  {
                     pushRecursiveRequiredPropError(propName);
                     return;
                  }
                  model[propName] = createModel(propClass, data[propAlias]);
               }
               else
               {
                  pushUnsupportedPropTypeError(propName, propClass);
                  return;
               }
            }
            // run post-processor function on the property, if any
            var postProcessor:Function = TYPE_POST_PROCESSORS[propClass]
            if (postProcessor != null)
            {
               postProcessor(model, propName, model[propName]);
            }
         };
         
         for each (var propInfo:XML in info.accessor)
         {
            copyProperty(propInfo);
         }
         for each (propInfo in info.variable)
         {
            copyProperty(propInfo);
         }
         
         if (errors.length != 0)
         {
            throw new Error(
               errors.join("\n") + "\nFix properties in " + type + " or see to it that source " +
               "object holds values for all required properties of correct type."
            );
         }
         
         model.afterCreateModel(data);
         return model;
      };
      
      
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
            return new ModelsCollection(source);
         }
         
         for each (item in list)
         {
            collection.addItem(createModel(modelType, item));
         }
         return collection;
      }
      
      
      public function BaseModel()
      {
         
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      /**
       * Copies given properties from the given model to this model.
       * 
       * @param source Source model. If <code>null</code>, method will return
       * immediately, nothing will be copied and <code>afterCopyProperties()</code>
       * won't be called.
       * @param props List of properties to be copied. If no properties are
       * given all public properties will be copied.
       * 
       * @throws Error if property can't be found or is not accessible.
       * @throws Error if <code>model</code> is of different type than
       * <code>this</code>.
       */
      public function copyProperties(source:BaseModel, ... props) : void
      {
         if (! source)
         {   
            return;
         }
         var typeInfo:XML = describeType(this);
         if (!(source is CLASS))
         {
            throw new Error("'source' is " + source.className + " but " + className + " was expected.");
         }
         if (props.length == 0)
         {
            props = ClassUtil.getPublicProperties(this);
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
               if (!propInfo.metadata.(@name == "SkipProperty")[0])
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
       * <p>
       * <code>{qualifiedClassName},{id}</code></br>
       * where:
       * <ul>
       *    <li><code>{qualifiedClassName}</code> - class name as returned by
       *        <code>getQualifiedClassName(this)</code></li>
       *    <li><code>{id}</code> - id of this model </li>
       * </ul>
       * </p>
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
      
      
      /**
       * A reference to the class object of this object.
       */
      public function get CLASS() : Class
      {
         return ClassUtil.getClass(this);
      }
      
      
      /**
       * Fully qualified class name of this object.
       */
      public function get className() : String
      {
         return getQualifiedClassName(this);
      }
      
      
      private var _id: int = 0;
      [Optional]
      [Bindable(event="modelIdChange")]
      /**
       * Id of the model's instance. Probably not all models needs it.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Optional]<br/>
       * [Bindable(event="modelIdChange")]</i></p>
       */
      public function set id(value: int): void
      {
         _id = value;
         dispatchIdChangeEvent();
      }
      /**
       * @private 
       */
      public function get id() :int
      {
         return _id;
      }
      
      
      /**
       * If true, that means this model is not real and later might me replaced with a real model.
       */
      public var fake:Boolean = false;
      
      
      private var _pending:Boolean = false;
      [SkipProperty]
      [Bindable(event="modelPendingChange")]
      /**
       * Indicates if this instance is in some sort of transient state. Mostly
       * used when a message has been sent to the server concerning this
       * instance and it needs to be updated (ore something else must be done)
       * when response message is recieved from the server.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [SkipProperty]<br/>
       * [Bindable(event="modelPendingChange")]</i></p>
       */
      public function set pending(v:Boolean) : void
      {
         _pending = v;
         dispatchPendingChangeEvent();
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
       * in this method.
       * 
       * @param data A generic object which was used as source for populating properties
       */
      protected function afterCreateModel(data:Object) : void
      {
      }
      
      
      /**
       * Is called when <code>this.copyProperties()</code> has copied all properties. You can hook
       * any additional postprocessing to be performed in this method after properties have been
       * copied.
       * 
       * @param source a model which was used as source object for populating properties
       * @param props see <code>copyProperties()</code>
       * 
       * @see #copyProperties()
       */
      protected function afterCopyProperties(source:BaseModel, props:Array) : void
      {
      }
      
      
      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */
      
      
      /**
       * Invoke this to dispatch <code>BaseModelEvent.PENDING_CHANGE</code> event.
       * (<code>PropertyChangeEvent</code> will be also dispatched) This event is dispatched
       * autommaticly by <code>BaseModel</code> class.
       */
      protected function dispatchPendingChangeEvent() : void
      {
         dispatchEvent(new BaseModelEvent(BaseModelEvent.PENDING_CHANGE));
      }
      
      
      /**
       * Invoke this to dispatch <code>BaseModelEvent.ID_CHANGE</code> event
       * (<code>PropertyChangeEvent</code> will be also dispatched). This event is dispatched
       * autommaticly by <code>BaseModel</code> class.
       */
      protected function dispatchIdChangeEvent() : void
      {
         dispatchEvent(new BaseModelEvent(BaseModelEvent.ID_CHANGE));
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
         if (!source)
         {
            source = null;
         }
         if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
         {
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(source, property, oldValue, newValue));
         }
      }
      
      
      public override function dispatchEvent(event:Event):Boolean
      {
         if (hasEventListener(event.type))
         {
            return super.dispatchEvent(event);
         }
         return false;
      }
   }
}