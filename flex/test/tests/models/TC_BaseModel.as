package tests.models
{
   import ext.hamcrest.object.equals;
   
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import models.BaseModel;
   
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   
   import namespaces.client_internal;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.array;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.core.allOf;
   import org.hamcrest.core.isA;
   import org.hamcrest.core.not;
   import org.hamcrest.core.throws;
   import org.hamcrest.number.isNotANumber;
   import org.hamcrest.object.equalTo;
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.hasProperty;
   import org.hamcrest.object.notNullValue;
   
   import tests.models.classes.ModelAggregator;
   import tests.models.classes.ModelNested;
   import tests.models.classes.ModelRequiredSelf;
   
   import utils.Objects;

   public class TC_BaseModel
   {
      [Test]
      public function createModel_error() : void
      {
         assertThat(
            function():void{ create(ModelInvalidMetadata, {invalid: "invalid"}) },
            throws(Error)
         );
         
         assertThat(
            function():void{ create(ModelMissingCollectionMetadata, {collection: [1]}) },
            throws (Error)
         );
         
         assertThat(
            function():void{ create(ModelRequiredProps, {name: "MikisM"}) },
            throws (Error)
         );
         
         assertThat(
            function():void{ create(ModelRequiredProps, {name: new Date(), age: 5}) },
            throws (Error)
         );
         
         assertThat(
            function():void{ create(ModelDateProp, {date: "not a date"}) },
            throws (Error)
         );
         
         assertThat(
            function():void{ create(ModelRequiredSelf, {id: 2, self: {id: 3}}) },
            throws (Error)
         );
         
         
         assertThat(
            function():void{ create(ModelAliasProperties, {}) },
            throws (Error)
         );
      };
      
      
      /**
       * Checks if tree-like structures are created using createModel().
       */
      public function createModel_nestedModels() : void
      {
         var model:ModelNested = create(ModelNested, {id: 1, nested: {id: 2}});
         assertThat( model.id, equalTo (1) );
         assertThat( model.nested, notNullValue() );
         assertThat( model.nested.id, equalTo (2) );
      };
      
      
      /**
       * Checks if null and undefined values are not copied when [Optional] tag is used. 
       */
      public function createModel_optional_undefinedAndNull() : void
      {
         var model:ModelOptionalMetadata = null;
         
         model = create(ModelOptionalMetadata, {optional: null});
         assertThat( model.optional, equalTo ("default") );
         
         model = create(ModelOptionalMetadata, {});
         assertThat( model.optional, equalTo ("default") );
      };
      
      
      [Test]
      /**
       * When "alias" attribute of [Optional] or [Required] metadata tag is specified property of
       * source object named as specified by that attribute should be used instead of staticly
       * typed property name of object beeing created.
       */
      public function createModel_propertyAlias() : void
      {
         var model:ModelAliasProperties = create(ModelAliasProperties, {
            "requiredAlias": "required",
            "optionalAlias": "optional",
            "requiredModelAlias": new BaseModel()
         });
         assertThat( model.required, equalTo ("required") );
         assertThat( model.optional, equalTo ("optional") );
         assertThat( model.requiredModel, notNullValue() );
      };
      
      [Test]
      public function createModel_aggregatesPropsErrors() : void {
         assertThat(
            "when no properties provided for required aggregator",
            function():void{ create(ModelPropsAggregatorRequired, {}) }, throws (Error)
         );
         assertThat(
            "when no properties provided for optional aggregator",
            function():void{ create(ModelPropsAggregatorOptional, {}) }, not (throws (Error))
         );
         assertThat(
            "not providing required property for aggregator",
            function():void{ create(ModelPropsAggregatorRequired, {"optional": 0}) }, throws (Error)
         );
         assertThat(
            "not providing optional but providing required property for aggregator",
            function():void{ create(ModelPropsAggregatorRequired, {"required": 0}) }, not (throws (Error))
         );
         assertThat(
            "alias attribute not allowed on aggregators",
            function():void{ create(ModelPropsAggregatorAlias, {"required": 0}) }, throws (Error)
         );
         assertThat(
            "aggregatesPrefix attribute not allowed together",
            function():void{ create(ModelPropsAndPrefixAggregator, {"required": 0, "optional": 0}) }, throws (Error)
         );
         assertThat(
            "it is illegal to define aggregatesProps for primitives",
            function():void{ create(ModelAggregatesPropsPrimitive, {}) }, throws (Error)
         );
      }
      
      [Test]
      public function createModel_aggregatesPrefixErrors() : void {
         assertThat(
            "when no properties provided for required aggregator",
            function():void{ create(ModelPrefixAggregatorRequired, {}) }, throws (Error)
         );
         assertThat(
            "when no properties provided for optional aggregator",
            function():void{ create(ModelPrefixAggregatorOptional, {}) }, not (throws (Error))
         );
         assertThat(
            "not providing required property for aggregator",
            function():void{ create(ModelPrefixAggregatorRequired, {"prefixOptional": 0}) }, throws (Error)
         );
         assertThat(
            "not providing optional but providing required property for aggregator",
            function():void{ create(ModelPrefixAggregatorRequired, {"prefixRequired": 0}) }, not (throws (Error))
         );
         assertThat(
            "it is illegal to define aggregatesPrefix for primitives",
            function():void{ create(ModelAggregatesPrefixPrimitive, {}) }, throws (Error)
         );
      }
      
      [Test]
      public function createModel_aggregatesProps() : void {
         var aggregatorUser:IAggregatorUser;
         var aggregator:ModelAggregator;
         
         aggregatorUser = create(ModelPropsAggregatorRequired, {"required": 0});
         aggregator = aggregatorUser.getAggregator();
         assertThat( "aggregator without optional prop created", aggregator, notNullValue() );
         assertThat( "aggregator.required", aggregator.required, equals (0) );
         assertThat( "aggregator.optional", aggregator.optional, isNotANumber() );
         
         aggregatorUser = create(ModelPropsAggregatorRequired, {"required": 0, "optional" :1});
         aggregator = aggregatorUser.getAggregator();
         assertThat( "aggregator with optional prop created", aggregator, notNullValue() );
         assertThat( "aggregator.required", aggregator.required, equals (0) );
         assertThat( "aggregator.optional", aggregator.optional, equals (1) );
      }
      
      [Test]
      public function createModel_aggregatesPrefix() : void {
         var aggregatorUser:IAggregatorUser;
         var aggregator:ModelAggregator;
         
         aggregatorUser = create(ModelPrefixAggregatorRequired, {"prefixRequired": 0});
         aggregator = aggregatorUser.getAggregator();
         assertThat( "aggregator without optional prop created", aggregator, notNullValue() );
         assertThat( "aggregator.required", aggregator.required, equals (0) );
         assertThat( "aggregator.optional", aggregator.optional, isNotANumber() );
         
         aggregatorUser = create(ModelPrefixAggregatorRequired, {"prefixRequired": 0, "prefixOptional" :1});
         aggregator = aggregatorUser.getAggregator();
         assertThat( "aggregator with optional prop created", aggregator, notNullValue() );
         assertThat( "aggregator.required", aggregator.required, equals (0) );
         assertThat( "aggregator.optional", aggregator.optional, equals (1) );
      }
      
      [Test]
      public function createModelUsesTypeProcessorsForObjects() : void {
         addPointProcessor();
         
         var point:Point = create(Point, {"x": 1, "y": 2});
         assertThat( "point created", point, notNullValue() );
         assertThat( "point.x", point.x, equals (1) );
         assertThat( "point.y", point.y, equals (2) ); 
         
         removePointProcessor();
      }
      
      [Test]
      public function createModelUsesTypeProcessorsForProperties() : void {
         addRectangleProcessor();
         
         var data:Object = {"rect": {"x": 1, "y": 2, "width": 3, "height": 4}};
         
         var modelNull:ModelRectangleNull = create(ModelRectangleNull, data);
         assertThat( "rect", modelNull.rect, notNullValue() );
         assertThat( "rect.x", modelNull.rect.x, equals (1) );
         assertThat( "rect.y", modelNull.rect.y, equals (2) );
         assertThat( "rect.width", modelNull.rect.width, equals (3) );
         assertThat( "rect.height", modelNull.rect.height, equals (4) );
         
         var modelDefault:ModelRectangleDefault = create(ModelRectangleDefault, data);
         assertThat( "rect", modelDefault.rect, notNullValue() );
         assertThat( "rect.x", modelDefault.rect.x, equals (1) );
         assertThat( "rect.y", modelDefault.rect.y, equals (2) );
         assertThat( "rect.width", modelDefault.rect.width, equals (3) );
         assertThat( "rect.height", modelDefault.rect.height, equals (4) );
         
         removeRectangleProcessor();
      }
      
      [Test]
      public function createModelAllowsAnyTypeInCollections() : void {
         addPointProcessor();
         
         var model:ModelCollectionsAnyType = create(ModelCollectionsAnyType, {
            "points": [{"x": 1, y: "1"}, {"x": 2, "y": 2}],
            "numbers": [1, 2, 3]
         });
         
         assertThat( "numbers", model.numbers, array (1, 2, 3) );
         assertThat( "points", model.points, array(
            allOf( isA(Point), hasProperties ({"x": 1, "y": 1}) ),
            allOf( isA(Point), hasProperties ({"x": 2, "y": 2}) ) 
         ));
         
         removePointProcessor();
      }
      
      [Test]
      public function createModelSupportsInstanceConstants() : void {
         addPointProcessor();
         
         var model:ModelPublicConstants = create(ModelPublicConstants, {
            "point": {"x": 1, "y": 2},
            "model": {"id": 10}
         });
         assertThat( "point.x", model.point.x, equals (1) );
         assertThat( "point.y", model.point.y, equals (2) );
         assertThat( "model.id", model.model.id, equals (10) );
         
         var modelCollection:ModelConstantCollection =
            create(ModelConstantCollection, {"numbers": [1, 2, 3]});
         assertThat( "constant collection of numbers", modelCollection.numbers, array (1, 2, 3) );
         
         removePointProcessor();
      }
      
      [Test]
      public function fillCollectionErrors() : void {
         function _fillCollection(collectionInstance:*, itemType:Class, data:Object) : Function {
            return function() : void {
               Objects.fillCollection(collectionInstance, itemType, data);
            }
         }
         
         assertThat(
            "[param collectionInstance] may not be null",
            _fillCollection(null, Point, []), throws (ArgumentError)
         );
         assertThat(
            "[param collectionInstance] can be Array",
            _fillCollection(new Array(), Point, []), not (throws (Error))
         );
         assertThat(
            "[param collectionInstance] can be Vector",
            _fillCollection(new Vector.<Point>(), Point, []), not (throws (Error))
         );
         assertThat(
            "[param collectionInstance] can be IList",
            _fillCollection(new ArrayCollection(), Point, []),  not (throws (Error))
         );
         assertThat(
            "[param collectionInstance] may not be other type than Array, Vector or IList",
            _fillCollection(new Object(), Point, []), throws (TypeError)
         );
         assertThat(
            "[param itemTime] may not be null",
            _fillCollection(new ArrayCollection(), null, []), throws (ArgumentError)
         );
         assertThat(
            "[param data] may not be null",
            _fillCollection(new ArrayCollection(), Point, null), throws (ArgumentError)
         );
         assertThat(
            "[param data] can be Array",
            _fillCollection([], Point, new Array()), not (throws (Error))
         );
         assertThat(
            "[param data] can be Vector",
            _fillCollection([], Point, new Vector.<Object>()), not (throws (Error))
         );
         assertThat(
            "[param data] can be IList",
            _fillCollection([], Point, new ArrayCollection()),  not (throws (Error))
         );
         assertThat(
            "[param data] may not be other type than Array, Vector or IList",
            _fillCollection([], Point, new Object()), throws (TypeError)
         );
      }
      
      [Test]
      public function fillCollectionFillsCollectionPassedToTheMethod() : void {
         addPointProcessor();
         var collection:IList;
         var collectionReturned:IList;
         function getPoint(idx:int) : Point {
            return Point(collection.getItemAt(idx));
         }
         
         collection = new ArrayCollection();
         collectionReturned = Objects.fillCollection(collection, Point, [{"x": 1, "y": 1}, {"x": 2, "y": 2}]);
         assertThat( "returns same collection", collectionReturned, equals (collection) );
         assertThat( "number of items", collection, arrayWithSize (2) );
         assertThat( "0th point: x", getPoint(0).x, equals (1) );
         assertThat( "0th point: y", getPoint(0).y, equals (1) );
         assertThat( "1st point: x", getPoint(1).x, equals (2) );
         assertThat( "1st point: y", getPoint(1).y, equals (2) );
         
         removePointProcessor();
      }
      
      [Test]
      public function fillCollectionSupportsDifferentCollectionTypes() : void {
         addPointProcessor();
         function fillCollection(collectionInstance:*, itemType:Class, data:Object) : void {
            Objects.fillCollection(collectionInstance, itemType, data);
         }
         
         var list:IList = new ArrayCollection();
         fillCollection(list, String, new ArrayCollection(["one", "two"]));
         assertThat( "fills IList from IList", list, array ("one", "two") );
         
         var arr:Array = new Array();
         fillCollection(arr, BaseModel, [{"id": 1}, {"id": 2}]);
         assertThat( "fills Array form Array", arr, array (
            allOf (isA(BaseModel), hasProperty("id", 1)),
            allOf (isA(BaseModel), hasProperty("id", 2))
         ));
         
         var vector:Vector.<Point> = new Vector.<Point>();
         fillCollection(vector, Point, Vector.<Object>([{"x": 1, "y": 1}, {"x": 2, "y": 2}]));
         assertThat("fills Vector from Vector", vector, array (
            allOf (isA(Point), hasProperties({"x": 1, "y": 1})),
            allOf (isA(Point), hasProperties({"x": 2, "y": 2}))
         ));
         
         removePointProcessor();
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function create(type:Class, data:Object) : * {
         return Objects.create(type, data);
      }
      
      private function addPointProcessor() : void {
         Objects.setTypeProcessor(Point, function(currValue:*, value:Object) : Object {
            var point:Point = currValue == null ? new Point() : currValue;
            point.x = value["x"];
            point.y = value["y"];
            return point;
         });
      }
      
      private function removePointProcessor() : void {
         delete Objects.client_internal::TYPE_PROCESSORS[Point];
      }
      
      private function addRectangleProcessor() : void {
         Objects.setTypeProcessor(Rectangle, function(currValue:*, value:Object) : Object {
            var rect:Rectangle = currValue == null ? new Rectangle() : currValue;
            rect.x = value["x"];
            rect.y = value["y"];
            rect.width = value["width"];
            rect.height = value["height"];
            return rect;
         });
      }
      
      private function removeRectangleProcessor() : void {
         delete Objects.client_internal::TYPE_PROCESSORS[Rectangle];
      }
   }
}


import flash.geom.Point;
import flash.geom.Rectangle;

import models.BaseModel;

import mx.collections.ArrayCollection;

import tests.models.classes.ModelAggregator;


class ModelInvalidMetadata extends BaseModel
{
   [Required]
   [Optional]
   public var invalid:String = null;
}


class ModelOptionalMetadata extends BaseModel
{
   [Optional]
   public var optional:String = "default";
}


class ModelMissingCollectionMetadata extends BaseModel
{
   [Required]
   public var collection:Array = null;
}


class ModelRequiredProps extends BaseModel
{
   [Required]
   public var name:String = "";
   [Required]
   public var age:int = 0;
}


class ModelDateProp extends BaseModel
{
   [Required]
   public var date:Date = null;
}


class ModelAliasProperties extends BaseModel
{
   [Required(alias="requiredAlias")]
   /**
    * [Required(alias="requiredAlias")]
    */
   public var required:String = null;
   
   [Optional(alias="optionalAlias")]
   /**
    * [Optional(alias="optionalAlias")]
    */
   public var optional:String = null;
   
   [Required(alias="requiredModelAlias")]
   /**
    * [Required(alias="requiredModelAlias")]
    */
   public var requiredModel:BaseModel = null;
}

interface IAggregatorUser
{
   function getAggregator() : ModelAggregator;
}

class ModelPropsAggregatorAlias extends BaseModel implements IAggregatorUser {
   [Required(alias="aggregatorAlias", aggregatesProps="optional, required")]
   public var aggregator:ModelAggregator;
   public function getAggregator() : ModelAggregator {
      return aggregator;
   }
}

class ModelPropsAggregatorRequired extends BaseModel implements IAggregatorUser
{
   [Required(aggregatesProps="optional, required")]
   public var aggregator:ModelAggregator;
   public function getAggregator() : ModelAggregator {
      return aggregator;
   }
}

class ModelPropsAggregatorOptional extends BaseModel implements IAggregatorUser
{
   [Optional(aggregatesProps="optional, required")]
   public var aggregator:ModelAggregator;
   public function getAggregator() : ModelAggregator {
      return aggregator;
   }
}

class ModelPrefixAggregatorRequired extends BaseModel implements IAggregatorUser
{
   [Required(aggregatesPrefix="prefix")]
   public var aggregator:ModelAggregator;
   public function getAggregator() : ModelAggregator {
      return aggregator;
   }
}

class ModelPrefixAggregatorOptional extends BaseModel implements IAggregatorUser
{
   [Optional(aggregatesPrefix="prefix")]
   public var aggregator:ModelAggregator;
   public function getAggregator() : ModelAggregator {
      return aggregator;
   }
}

class ModelPropsAndPrefixAggregator extends BaseModel implements IAggregatorUser
{
   [Required(aggregatesProps="required", aggregatesPrefix="prefix")]
   public var aggregator:ModelAggregator;
   public function getAggregator() : ModelAggregator {
      return aggregator;
   }
}

class ModelAggregatesPrefixPrimitive extends BaseModel
{
   [Required(aggregatesPrefix="prefix")]
   public var primitive:Number;
}

class ModelAggregatesPropsPrimitive extends BaseModel
{
   [Required(aggregatesProps="value")]
   public var primitive:String;
}

class ModelRectangleNull extends BaseModel
{
   [Required] public var rect:Rectangle = null;
}

class ModelRectangleDefault extends BaseModel
{
   [Required] public var rect:Rectangle = new Rectangle();
}

class ModelCollectionsAnyType extends BaseModel
{
   [Required(elementType="Number")]
   public var numbers:Array;
   [Required(elementType="flash.geom.Point")]
   public var points:Array;
}

class ModelPublicConstants extends BaseModel
{
   [Required] public const point:Point = new Point();
   [Required] public const model:BaseModel = new BaseModel();
}

class ModelConstantCollection extends BaseModel
{
   [Required(elementType="Number")]
   public const numbers:ArrayCollection = new ArrayCollection();
}