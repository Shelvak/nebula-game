package models
{
   import com.adobe.errors.IllegalStateError;
   
   import models.location.LocationMinimal;
   import models.map.MMap;
   
   import mx.utils.ObjectUtil;
   
   import utils.ClassUtil;
   
   
   /**
    * Aggregates different static space objects in the same location. At least one static space object must
    * be added to this list. Can only hold one instance of <code>IStaticSpaceObject</code>
    */
   public class StaticSpaceSectorObjects extends ModelsCollection
   {
      public static const TYPE_NATURAL:String = "naturalSpaceObject";
      public static const TYPE_WRECKAGE:String = "wreckage";
      
      
      public function StaticSpaceSectorObjects(source:Array = null)
      {
         super(source);
      }
      
      
      /**
       * Location all agregated space objects are in.
       */
      public function get currentLoction() : LocationMinimal
      {
         if (isEmpty)
         {
            throw new IllegalStateError("None of static spase objects properties are set in " + this);
         }
         return IStaticSpaceObject(getFirst()).currentLocation;
      }
      
      
      private var _naturalSpaceObject:IStaticSpaceObject;
      [Bindable]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]</i></p>
       */
      public function set naturalSpaceObject(value:IStaticSpaceObject) : void
      {
         if (_naturalSpaceObject != value)
         {
            _naturalSpaceObject = value;
         }
      }
      /**
       * @private
       */
      public function get naturalSpaceObject() : IStaticSpaceObject
      {
         return _naturalSpaceObject;
      }
      
      
      private var _wreckage:Wreckage;
      [Bindable]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]</i></p>
       */
      public function set wreckage(value:Wreckage) : void
      {
         if (_wreckage != value)
         {
            _wreckage = value;
         }
      }
      /**
       * @private
       */
      public function get wreckage() : Wreckage
      {
         return _wreckage;
      }
      
      
      public function toString() : String
      {
         return "[class: " + ClassUtil.getClassName(this) + ", naturalSpaceObject: " + naturalSpaceObject
                ", wreckage: " + wreckage + "]";
      }
   }
}