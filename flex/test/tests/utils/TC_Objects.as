package tests.utils
{
   import ext.hamcrest.object.equals;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.object.isTrue;
   import org.hamcrest.object.notNullValue;
   
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
   }
}


import mx.collections.ArrayCollection;


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

class RequiredProps
{
   [Required] public var name:String = "";
   [Required] public var age:int = 0;
}