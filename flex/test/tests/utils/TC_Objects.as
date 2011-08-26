package tests.utils
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
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.hasProperty;
   import org.hamcrest.object.isTrue;
   import org.hamcrest.object.notNullValue;
   
   import tests.utils.classes.Aggregator;
   import tests.utils.classes.NestedModel;
   import tests.utils.classes.RequiredSelf;
   
   import utils.Objects;

   
   public class TC_Objects
   {
      /* ####################### */
      /* ### extractProps*() ### */
      /* ####################### */
      
      [Test]
      public function extractProps() : void {
         var result:Object = Objects.extractProps(["one", "two", "nonExisting"], {
            "one": 1,
            "two": 2,
            "three": 3,
            "four": 4
         });
         assertThat( "[prop three] not extracted", result["three"] === undefined, isTrue() );
         assertThat( "[prop four] not extracted", result["four"] === undefined, isTrue() );
         assertThat( "[prop nonExisting] not created", result["nonExisting"] === undefined, isTrue() );
         assertThat( "[prop one] extracted", result["one"], equals (1) );
         assertThat( "[prop two] extracted", result["two"], equals (2) );
      }
      
      [Test]
      public function extractPropsWithPrefix() : void {
         var result:Object = Objects.extractPropsWithPrefix("prefix", {
            "one": 1,
            "two": 2,
            "prefixOneOne": 11,
            "prefixTwoTwo": 22
         });
         assertThat( "[prop one] not extracted", result["one"] === undefined, isTrue() );
         assertThat( "[prop two] not extracted", result["two"] === undefined, isTrue() );
         assertThat( "[prop prefixOneOne] extracted", result["oneOne"], equals (11) );
         assertThat( "[prop prefixTwoTwo] extracted", result["twoTwo"], equals (22) );
      }
      
      [Test]
      public function extractPropsWithPrefixLeavesOutPropsWithTheSameNameAsPrefix () : void {
         var result:Object = Objects.extractPropsWithPrefix("prefix", {"prefix": 0});
         assertThat( "[prop prefix] not extracted", result["prefix"] === undefined, isTrue() );
         assertThat( "prop with no name not created", result[""] === undefined, isTrue() );
      }
      
      
      /* ################ */
      /* ### create() ### */
      /* ################ */
      
      [Test]
      public function create_errors() : void {
         assertThat(
            "same property - both tags",
            $_creating (InvalidMetadata, {"invalid": "invalid"}), throws (Error)
         );
         assertThat(
            "no elementType attribute",
            $_creating (MissingCollectionMetadata, {"collection": [1]}), throws (Error)
         );
         assertThat(
            "no required property",
            $_creating (RequiredProps, {"name": "MikisM"}), throws (Error)
         );
         assertThat(
            "wrong property type",
            $_creating (RequiredProps, {"name": new Date(), "age": 5}), throws (Error)
         );
         assertThat(
            "wrong date format",
            $_creating (DateProp, {"date": "not a date"}), throws (Error)
         );
         assertThat(
            "required property of same type",
            $_creating (RequiredSelf, {"id": 2, "self": {"id": 3}}), throws (Error)
         );
         assertThat(
            "no required alias properties",
            $_creating (AliasProperties, {}), throws (Error)
         );
      }
      
      [Test]
      public function create_simpleProperties() : void {
         var data:Object = null;
         var object:* = null;
         
         function checkIfChanged(prop:String) : void {
            assertThat( prop + " should have been copied", object[prop], equals (data[prop]) );
         };
         function checkIfNotChanged(prop:String, oldValue:*) : void {
            assertThat( prop + " should not have been changed", object[prop], equals (oldValue) );
         };
         
         data = {notTagged: "won't be copied"};
         object = Objects.create(NoTaggedProps, data);
         checkIfNotChanged("notTagged", "");
         
         data = {variable: 5, accessor: 10};
         object = Objects.create(AccessorAndVariable, data);
         checkIfChanged("variable");
         checkIfChanged("accessor");
         
         data = {name: "MikisM", age: 22};
         object = Objects.create(RequiredProps, data);
         checkIfChanged("name");
         checkIfChanged("age");
         
         object = Objects.create(OptionalProps, data);
         checkIfChanged("name");
         checkIfChanged("age");
         
         data = {name: "MikisM"};
         object = Objects.create(OptionalProps, data);
         checkIfChanged("name");
         checkIfNotChanged("age", 0);
         
         data = {"date": "2009-09-25T18:45:26+03:00"};
         object = Objects.create(DateProp, data);
         var date:Date = object.date;
         assertThat( "year", date.fullYearUTC, equals (2009) );
         assertThat( "moth", date.monthUTC, equals (8) );
         assertThat( "day", date.dateUTC, equals (25) );
         assertThat( "hours", date.hoursUTC, equals (15) );
         assertThat( "minutes", date.minutesUTC, equals (45) );
         assertThat( "seconds", date.secondsUTC, equals (26) );
         assertThat( "milliseconds", date.millisecondsUTC, equals (0) );
      }
      
      [Test]
      public function create_listProps() : void
      {
         var data:Object = null;
         var object:* = null;
         
         function checkIfElementsCopied(propName:String) : void {
            var index:int = 0;
            for each (var item:Object in object[propName]) {
               assertThat(
                  "element " + index + " should have been copied",
                  item, equals (data[propName][index])
               );
               index++;
            }
         };
         
         // Array
         data = {"numbersInstance": [1, 2], "numbersNull": [1, 2]};
         object = Objects.create(ArrayProp, data);
         assertThat( "should have initialized the array", object.numbersNull, notNullValue() );
         assertThat( "source and destination arrays should be of the same length", object.numbersInstance, arrayWithSize(2) );
         assertThat( "source and destination arrays should be of the same length", object.numbersNull, arrayWithSize(2) );
         checkIfElementsCopied("numbersInstance");
         checkIfElementsCopied("numbersNull");
         
         // A list
         data = {"numbersInstance": [2, 1], "numbersNull": [2, 1]};
         object = Objects.create(ListProp, data);
         assertThat( "should have initialized the list", object.numbersNull, notNullValue() );
         assertThat( "source and destination lists should be of the same length", object.numbersInstance, arrayWithSize(2) );
         assertThat( "source and destination lists should be of the same length", object.numbersNull, arrayWithSize(2) );
         checkIfElementsCopied("numbersInstance");
         checkIfElementsCopied("numbersNull");
         
         // Vector
         data = {"numbersInstance": [3, 4], "numbersNull": [3, 4]};
         object = Objects.create(VectorProp, data);
         assertThat( "should have initialized vector [prop numbersNull]", object.numbersNull, notNullValue() );
         assertThat( "source and destination lists should be of the same length", object.numbersInstance, arrayWithSize(2) );
         assertThat( "source and destination lists should be of the same length", object.numbersNull, arrayWithSize(2) );
         checkIfElementsCopied("numbersInstance");
         checkIfElementsCopied("numbersNull");
         
         // List of models
         data = {"models": [{"id": 1}, {"id": 2}]};
         object = Objects.create(ListPropModels, data);
         assertThat( "source and destination lists should be of the same length", object.models, arrayWithSize (2) );
         for (var i:int = 0; i < data.models.length; i++) {
            assertThat("id should have been copied", object.models[i].id, equals (data.models[i].id) );
         }
      }
      
      [Test]
      public function create_objectProp() : void {
         var object:Object = {"foo": "Foo", "bar": "Bar"};
         var model:ObjectProp = Objects.create(ObjectProp, {"object": object});
         
         assertThat( "[prop object] should have been set", model.object, notNullValue() );
         assertThat( "[prop object] should now hold reference to [var object]", model.object, equals (object) );
      }
      
      [Test]
      public function create_nestedObjects() : void {
         var model:NestedModel = create(NestedModel, {"id": 1, "nested": {"id": 2}});
         assertThat( "id property of root model set", model.id, equals (1) );
         assertThat( "nested model created", model.nested, notNullValue() );
         assertThat( "id property of nested model set", model.nested.id, equals (2) );
      }
      
      [Test]
      public function create_optional_undefinedAndNull() : void {
         var object:OptionalMetadata = null;
         object = create(OptionalMetadata, {"optional": null});
         assertThat( "null not copied", object.optional, equals ("default") );
         object = create(OptionalMetadata, {});
         assertThat( "undefined not copied", object.optional, equals ("default") );
      }
      
      [Test]
      /**
       * When "alias" attribute of [Optional] or [Required] metadata tag is specified property of
       * source object named as specified by that attribute should be used instead of staticly
       * typed property name of object beeing created.
       */
      public function create_propertyAlias() : void
      {
         var model:AliasProperties = create(AliasProperties, {
            "requiredAlias": "required",
            "optionalAlias": "optional",
            "requiredModelAlias": {"id": 2}
         });
         assertThat( "prop required", model.required, equals ("required") );
         assertThat( "prop optional", model.optional, equals ("optional") );
         assertThat( "prop requiredModel", model.requiredModel, notNullValue() );
      }
      
      [Test]
      public function create_aggregatesPropsErrors() : void {
         assertThat(
            "no properties provided for required aggregator",
            $_creating (PropsAggregatorRequired, {}), throws (Error)
         );
         assertThat(
            "no properties provided for optional aggregator",
            $_creating (PropsAggregatorOptional, {}), not (throws (Error))
         );
         assertThat(
            "not provided required property for aggregator",
            $_creating (PropsAggregatorRequired, {"optional": 0}), throws (Error)
         );
         assertThat(
            "not provided optional but providing required property for aggregator",
            $_creating (PropsAggregatorRequired, {"required": 0}), not (throws (Error))
         );
         assertThat(
            "alias attribute not allowed on aggregators",
            $_creating (PropsAggregatorAlias, {"required": 0}), throws (Error)
         );
         assertThat(
            "aggregatesPrefix attribute not allowed together",
            $_creating (PropsAndPrefixAggregator, {"required": 0, "optional": 0}), throws (Error)
         );
         assertThat(
            "it is illegal to define aggregatesProps for primitives",
            $_creating (AggregatesPropsPrimitive, {}), throws (Error)
         );
      }
      
      [Test]
      public function create_aggregatesPrefixErrors() : void {
         assertThat(
            "no properties provided for required aggregator",
            $_creating (ModelPrefixAggregatorRequired, {}), throws (Error)
         );
         assertThat(
            "no properties provided for optional aggregator",
            $_creating (ModelPrefixAggregatorOptional, {}), not (throws (Error))
         );
         assertThat(
            "not provided required property for aggregator",
            $_creating (ModelPrefixAggregatorRequired, {"prefixOptional": 0}), throws (Error)
         );
         assertThat(
            "not provided optional but providing required property for aggregator",
            $_creating (ModelPrefixAggregatorRequired, {"prefixRequired": 0}), not (throws (Error))
         );
         assertThat(
            "it is illegal to define aggregatesPrefix for primitives",
            $_creating (ModelAggregatesPrefixPrimitive, {}), throws (Error)
         );
      }
      
      [Test]
      public function create_aggregatesProps() : void {
         var aggregatorUser:IAggregatorUser;
         var aggregator:Aggregator;
         
         aggregatorUser = create(PropsAggregatorRequired, {"required": 0});
         aggregator = aggregatorUser.getAggregator();
         assertThat( "aggregator without optional prop created", aggregator, notNullValue() );
         assertThat( "aggregator.required", aggregator.required, equals (0) );
         assertThat( "aggregator.optional", aggregator.optional, isNotANumber() );
         
         aggregatorUser = create(PropsAggregatorRequired, {"required": 0, "optional" :1});
         aggregator = aggregatorUser.getAggregator();
         assertThat( "aggregator with optional prop created", aggregator, notNullValue() );
         assertThat( "aggregator.required", aggregator.required, equals (0) );
         assertThat( "aggregator.optional", aggregator.optional, equals (1) );
      }
      
      [Test]
      public function create_aggregatesPrefix() : void {
         var aggregatorUser:IAggregatorUser;
         var aggregator:Aggregator;
         
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
      public function createUsesTypeProcessorsForObjects() : void {
         addPointProcessor();
         
         var point:Point = create(Point, {"x": 1, "y": 2});
         assertThat( "point created", point, notNullValue() );
         assertThat( "point.x", point.x, equals (1) );
         assertThat( "point.y", point.y, equals (2) ); 
         
         removePointProcessor();
      }
      
      [Test]
      public function createUsesTypeProcessorsForProperties() : void {
         addRectangleProcessor();
         
         var data:Object = {"rect": {"x": 1, "y": 2, "width": 3, "height": 4}};
         
         var modelNull:RectangleNull = create(RectangleNull, data);
         assertThat( "rect", modelNull.rect, notNullValue() );
         assertThat( "rect.x", modelNull.rect.x, equals (1) );
         assertThat( "rect.y", modelNull.rect.y, equals (2) );
         assertThat( "rect.width", modelNull.rect.width, equals (3) );
         assertThat( "rect.height", modelNull.rect.height, equals (4) );
         
         var modelDefault:RectangleDefault = create(RectangleDefault, data);
         assertThat( "rect", modelDefault.rect, notNullValue() );
         assertThat( "rect.x", modelDefault.rect.x, equals (1) );
         assertThat( "rect.y", modelDefault.rect.y, equals (2) );
         assertThat( "rect.width", modelDefault.rect.width, equals (3) );
         assertThat( "rect.height", modelDefault.rect.height, equals (4) );
         
         removeRectangleProcessor();
      }
      
      [Test]
      public function createAllowsAnyTypeInCollections() : void {
         addPointProcessor();
         
         var model:CollectionsAnyType = create(CollectionsAnyType, {
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
      public function createSupportsInstanceConstants() : void {
         addPointProcessor();
         
         var model:PublicConstants = create(PublicConstants, {
            "point": {"x": 1, "y": 2},
            "model": {"id": 10}
         });
         assertThat( "point.x", model.point.x, equals (1) );
         assertThat( "point.y", model.point.y, equals (2) );
         assertThat( "model.id", model.model.id, equals (10) );
         
         var modelCollection:ConstantCollection = create(ConstantCollection, {"numbers": [1, 2, 3]});
         assertThat( "constant collection of numbers", modelCollection.numbers, array (1, 2, 3) );
         
         removePointProcessor();
      }
      
      
      /* ######################## */
      /* ### fillCollection() ### */
      /* ######################## */
      
      [Test]
      public function fillCollection_errors() : void {
         function $_filling(collectionInstance:*, itemType:Class, data:Object) : Function {
            return function() : void {
               Objects.fillCollection(collectionInstance, itemType, data);
            }
         }
         
         assertThat(
            "[param collectionInstance] may not be null",
            $_filling (null, Point, []), throws (ArgumentError)
         );
         assertThat(
            "[param collectionInstance] can be Array",
            $_filling (new Array(), Point, []), not (throws (Error))
         );
         assertThat(
            "[param collectionInstance] can be Vector",
            $_filling (new Vector.<Point>(), Point, []), not (throws (Error))
         );
         assertThat(
            "[param collectionInstance] can be IList",
            $_filling (new ArrayCollection(), Point, []),  not (throws (Error))
         );
         assertThat(
            "[param collectionInstance] may not be other type than Array, Vector or IList",
            $_filling (new Object(), Point, []), throws (TypeError)
         );
         assertThat(
            "[param itemTime] may not be null",
            $_filling (new ArrayCollection(), null, []), throws (ArgumentError)
         );
         assertThat(
            "[param data] may not be null",
            $_filling (new ArrayCollection(), Point, null), throws (ArgumentError)
         );
         assertThat(
            "[param data] can be Array",
            $_filling ([], Point, new Array()), not (throws (Error))
         );
         assertThat(
            "[param data] can be Vector",
            $_filling ([], Point, new Vector.<Object>()), not (throws (Error))
         );
         assertThat(
            "[param data] can be IList",
            $_filling ([], Point, new ArrayCollection()),  not (throws (Error))
         );
         assertThat(
            "[param data] may not be other type than Array, Vector or IList",
            $_filling ([], Point, new Object()), throws (TypeError)
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
         function fill(collectionInstance:*, itemType:Class, data:Object) : void {
            Objects.fillCollection(collectionInstance, itemType, data);
         }
         
         var list:IList = new ArrayCollection();
         fill(list, String, new ArrayCollection(["one", "two"]));
         assertThat( "fills IList from IList", list, array ("one", "two") );
         
         var arr:Array = new Array();
         fill(arr, BaseModel, [{"id": 1}, {"id": 2}]);
         assertThat( "fills Array form Array", arr, array (
            allOf (isA(BaseModel), hasProperty("id", 1)),
            allOf (isA(BaseModel), hasProperty("id", 2))
         ));
         
         var vector:Vector.<Point> = new Vector.<Point>();
         fill(vector, Point, Vector.<Object>([{"x": 1, "y": 1}, {"x": 2, "y": 2}]));
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
      
      private function $_creating(type:Class, data:Object) : Function {
         return function() : void {
            create(type, data);
         }
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

import tests.utils.classes.Aggregator;

class InvalidMetadata
{
   [Required] [Optional] public var invalid:String = null;
}

class MissingCollectionMetadata
{
   [Required] public var collection:Array = null;
}

class AccessorAndVariable
{
   [Required]
   public var variable:int = 0;
   
   private var _accessor:int = 0;
   [Required]
   public function set accessor(value:int) : void { _accessor = value; }
   public function get accessor() : int { return _accessor; }
}

class ArrayProp
{
   [Required(elementType="Number")] public var numbersInstance:Array = [];
   [Required(elementType="Number")] public var numbersNull:Array = null;
}

class DateProp
{
   [Required]
   public var date:Date = null;
}

class ListProp
{
   [Required(elementType="Number")] public var numbersInstance:ArrayCollection = new ArrayCollection();
   [Required(elementType="Number")] public var numbersNull:ArrayCollection = null;
}

class VectorProp
{
   [Required] public var numbersInstance:Vector.<Number> = new Vector.<Number>();
   [Required] public var numbersNull:Vector.<Number> = null;
}

class ListPropModels
{
   [Required(elementType="models.BaseModel")] public var models:Array = null;
}

class NoTaggedProps
{
   public var notTagged:String = "";
}

class ObjectProp
{
   [Required] public var object:Object = null;
}

class OptionalProps
{
   [Optional] public var name:String = "";
   [Optional] public var age:int = 0;
}

class OptionalMetadata
{
   [Optional] public var optional:String = "default";
}

class RequiredProps
{
   [Required] public var name:String = "";
   [Required] public var age:int = 0;
}

class AliasProperties
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
   function getAggregator() : Aggregator;
}

class PropsAggregatorAlias implements IAggregatorUser {
   [Required(alias="aggregatorAlias", aggregatesProps="optional, required")]
   public var aggregator:Aggregator;
   public function getAggregator() : Aggregator {
      return aggregator;
   }
}

class PropsAggregatorRequired implements IAggregatorUser
{
   [Required(aggregatesProps="optional, required")]
   public var aggregator:Aggregator;
   public function getAggregator() : Aggregator {
      return aggregator;
   }
}

class PropsAggregatorOptional implements IAggregatorUser
{
   [Optional(aggregatesProps="optional, required")]
   public var aggregator:Aggregator;
   public function getAggregator() : Aggregator {
      return aggregator;
   }
}

class ModelPrefixAggregatorRequired implements IAggregatorUser
{
   [Required(aggregatesPrefix="prefix")] 
   public var aggregator:Aggregator;
   public function getAggregator() : Aggregator {
      return aggregator;
   }
}

class ModelPrefixAggregatorOptional implements IAggregatorUser
{
   [Optional(aggregatesPrefix="prefix")]
   public var aggregator:Aggregator;
   public function getAggregator() : Aggregator {
      return aggregator;
   }
}

class PropsAndPrefixAggregator implements IAggregatorUser
{
   [Required(aggregatesProps="required", aggregatesPrefix="prefix")]
   public var aggregator:Aggregator;
   public function getAggregator() : Aggregator {
      return aggregator;
   }
}

class ModelAggregatesPrefixPrimitive
{
   [Required(aggregatesPrefix="prefix")] public var primitive:Number;
}

class AggregatesPropsPrimitive
{
   [Required(aggregatesProps="value")] public var primitive:String;
}

class RectangleNull
{
   [Required] public var rect:Rectangle = null;
}

class RectangleDefault
{
   [Required] public var rect:Rectangle = new Rectangle();
}

class CollectionsAnyType
{
   [Required(elementType="Number")] public var numbers:Array;
   [Required(elementType="flash.geom.Point")] public var points:Array;
}

class PublicConstants
{
   [Required] public const point:Point = new Point();
   [Required] public const model:BaseModel = new BaseModel();
}

class ConstantCollection
{
   [Required(elementType="Number")] public const numbers:ArrayCollection = new ArrayCollection();
}