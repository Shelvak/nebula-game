package models
{
   import com.adobe.errors.IllegalStateError;
   
   import flash.events.EventDispatcher;
   
   import interfaces.IEqualsComparable;
   
   import models.events.BaseModelEvent;
   
   import mx.collections.ICollectionView;
   import mx.events.PropertyChangeEvent;
   
   import namespaces.prop_name;
   
   import utils.Events;
   import utils.Objects;
   import utils.assets.ImagePreloader;
   
   
   /** 
    * @see models.events.BaseModelEvent#PENDING_CHANGE
    * @eventType models.events.BaseModelEvent.PENDING_CHANGE
    */
   [Event(name="pendingChange", type="models.events.BaseModelEvent")]
   
   /**
    * @see models.events.BaseModelEvent#FLAG_DESTRUCTION_PENDING_SET
    * @eventType models.events.BaseModelEvent.FLAG_DESTRUCTION_PENDING_SET
    */
   [Event(name="flagDestructionPendingSet", type="models.events.BaseModelEvent")]
   
   /**
    * @see models.events.BaseModelEvent#MODEL_ID_CHANGE
    * @eventType models.events.BaseModelEvent.MODEL_ID_CHANGE
    */
   [Event(name="modelIdChange", type="models.events.BaseModelEvent")]
   
   /**
    * @see models.events.BaseModelEvent#UPDATE
    */
   [Event(name="update", type="models.events.BaseModelEvent")]
   
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
      public function copyProperties(source:BaseModel, ignoreSkipProperty:Boolean = false, props:Array = null) : void {
         if (source == null)
            return;
         if (!(source is CLASS))
            throw new TypeError("'source' is " + source.className + " but " + className + " was expected.");
         var typeInfo:XML = Objects.describeType(CLASS).factory[0];
         ignoreSkipProperty = ignoreSkipProperty || props && props.length > 0;
         if (!props || props.length == 0)
            props = Objects.getPublicProperties(CLASS);
         for each (var prop:String in props) {
            if (!(this[prop] == source[prop] ||
                 (this[prop] is IEqualsComparable) && IEqualsComparable(this[prop]).equals(source[prop]))) {
               var propInfo:XML = typeInfo.accessor.(@name == prop)[0];
               if (!propInfo)
                  propInfo = typeInfo.variable.(@name == prop)[0];
               if (ignoreSkipProperty || !propInfo.metadata.(@name == "SkipProperty")[0])
                  this[prop] = source[prop];
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
       * Is called when <code>Objects.create()</code> has finished creation of a model. You can hook any
       * additional postprocessing to be performed after creation of a model in this method. You must invoke
       * <code>super.afterCreate()</code> when overriding this method.
       * 
       * @param data A generic object which was used as source for populating properties
       */
      public function afterCreate(data:Object) : void {
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
      protected function afterCopyProperties(source:BaseModel, props:Array) : void {
         refresh();
      }
      
      
      /**
       * Call to refresh any collections in this model having filters dependent on some properties of
       * this model. Is called automatically in <code>afterCreateModel()</code> and <code>afterCopyProperties()</code>.
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
      
      
      private function addSelfEventHandlers(): void {
         for (var collectionProp: String in collectionsFilterProperties) {
            addEventListener(
               PropertyChangeEvent.PROPERTY_CHANGE, this_propertyChangeHandler
            );
            break;
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
         dispatchModelEvent(BaseModelEvent.FLAG_DESTRUCTION_PENDING_SET);
      }
      
      
      /**
       * Invoke this to dispatch <code>BaseModelEvent.PENDING_CHANGE</code> event.
       * (<code>PropertyChangeEvent</code> will be also dispatched) This event is dispatched
       * automatically by <code>BaseModel</code> class.
       */
      protected function dispatchPendingChangeEvent() : void
      {
         dispatchModelEvent(BaseModelEvent.PENDING_CHANGE);
      }
      
      
      /**
       * Invoke this to dispatch <code>BaseModelEvent.ID_CHANGE</code> event
       * (<code>PropertyChangeEvent</code> will be also dispatched). This event is dispatched
       * automatically by <code>BaseModel</code> class.
       */
      protected function dispatchIdChangeEvent() : void {
         dispatchModelEvent(BaseModelEvent.MODEL_ID_CHANGE);
      }
      
      /**
       * Call to dispatch <code>BaseModel.UPDATE</code> event. This event should only be dispached by
       * models implementing <code>IUpdatable</code> interface.
       * 
       * @see models.events.BaseModelEvent#UPDATE
       */
      protected function dispatchUpdateEvent() : void {
         dispatchModelEvent(BaseModelEvent.UPDATE);
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
            var event: PropertyChangeEvent = PropertyChangeEvent.createUpdateEvent(source, property, oldValue, newValue);
            dispatchEvent(event);
         }
      }
      
      
      /**
       * @see utils.Events#dispatchSimpleEvent()
       */
      protected function dispatchSimpleEvent(CLASS:Class, type:String) : void
      {
         Events.dispatchSimpleEvent(this, CLASS, type);
      }
      
      private function dispatchModelEvent(type:String) : void {
         dispatchSimpleEvent(BaseModelEvent, type);
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