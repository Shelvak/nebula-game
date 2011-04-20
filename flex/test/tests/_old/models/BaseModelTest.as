package tests._old.models
{
   import flash.geom.Point;
   
   import models.BaseModel;
   
   import mx.collections.ArrayCollection;
   
   import net.digitalprimates.fluint.tests.TestCase;
   
   import tests._old.models.classes.*;
   
   
   
   public class BaseModelTest extends TestCase
   {
      private var data: Object;
      private var model: *;
      
      
      [Test]
      public function createModel_simpleProperties() : void
      {
         var data:Object = null;
         var model:* = null;
         
         var checkIfChanged:Function = function(prop:String) : void
         {
            assertEquals(prop + " should have been copied", data[prop], model[prop]);
         };
         var checkIfNotChanged:Function = function(prop:String, oldValue:*) : void
         {
            assertEquals(
               prop + " should not have been changed",
               oldValue, model[prop]
            );
         };
         
         data = {notTagged: "won't be copied"};
         model = BaseModel.createModel(ModelNoTaggedProps, data);
         checkIfNotChanged("notTagged", "");
         
         data = {variable: 5, accessor: 10};
         model = BaseModel.createModel(ModelAccessorAndVariable, data);
         checkIfChanged("variable");
         checkIfChanged("accessor");
         
         data = {name: "MikisM", age: 22};
         model = BaseModel.createModel(ModelRequiredProps, data);
         checkIfChanged("name");
         checkIfChanged("age");
         
         model = BaseModel.createModel(ModelOptionalProps, data);
         checkIfChanged("name");
         checkIfChanged("age");
         
         data = {name: "MikisM"};
         model = BaseModel.createModel(ModelOptionalProps, data);
         checkIfChanged("name");
         checkIfNotChanged("age", 0);
         
         data = {date: "2009-09-25T18:45:26+03:00"};
         model = BaseModel.createModel(ModelDateProp, data);
         var date:Date = model.date;
         assertEquals("Year shoul be 2009", 2009, date.fullYearUTC);
         assertEquals("Month should be 8", 8, date.monthUTC);
         assertEquals("Day should be 25", 25, date.dateUTC);
         assertEquals("Hours should be 15", 15, date.hoursUTC);
         assertEquals("Minutes should be 45", 45, date.minutesUTC);
         assertEquals("Seconds should be 26", 26, date.secondsUTC);
         assertEquals("Milliseconds should be 0", 0, date.millisecondsUTC);
      };
      
      
      [Test]
      public function createModel_listProps() : void
      {
         var data:Object = null;
         var model:* = null;
         
         var checkIfElementsCopied:Function = function(propName:String) : void
         {
            var index:int = 0;
            for each (var item:Object in model[propName])
            {
               assertEquals(
                  "element " + index + " should have been copied",
                  data[propName][index], item 
               );
               index++;
            }
         };
         
         // Array
         data = {numbersInstance: [1, 2], numbersNull: [1, 2]};
         model = BaseModel.createModel(ModelArrayProp, data);
         assertNotNull("Should have initialized the array", model.numbersNull);
         assertEquals(
            "source and destination arrays should be of the same length",
            2, model.numbersInstance.length
         );
         assertEquals(
            "source and destination arrays should be of the same length",
            2, model.numbersNull.length
         );
         checkIfElementsCopied("numbersInstance");
         checkIfElementsCopied("numbersNull");
         
         // A list
         data = {numbersInstance: [2, 1], numbersNull: [2, 1]};
         model = BaseModel.createModel(ModelListProp, data);
         assertNotNull("Should have initialized the list", model.numbersNull);
         assertEquals(
            "source and destination lists should be of the same length",
            2, model.numbersInstance.length
         );
         assertEquals(
            "source and destination lists should be of the same length",
            2, model.numbersNull.length
         );
         checkIfElementsCopied("numbersInstance");
         checkIfElementsCopied("numbersNull");
         
         
         // Vector
         data = {numbersInstance: [3, 4], numbersNull: [3, 4]};
         model = BaseModel.createModel(ModelVectorProp, data);
         assertNotNull("Should have initialized vector [prop numbersNull]", model.numbersNull);
         assertEquals(
            "source and destination lists should be of the same length",
            2, model.numbersInstance.length
         );
         assertEquals(
            "source and destination lists should be of the same length",
            2, model.numbersNull.length
         );
         checkIfElementsCopied("numbersInstance");
         checkIfElementsCopied("numbersNull");
         
         // List of models
         data = {models: [{id: 1}, {id: 2}]};
         model = BaseModel.createModel(ModelListPropModels, data);
         assertEquals(
            "source and destination lists should be of the same length",
            2, model.models.length
         );
         for (var i:int = 0; i < data.models.length; i++)
         {
            assertEquals(
               "id should have been copied",
               data.models[i].id, model.models[i].id
            );
         }
      };
      
      
      [Test]
      public function createModel_objectProp() : void
      {
         var object:Object = {"foo": "Foo", "bar": "Bar"};
         var model:ModelObjectProp = BaseModel.createModel(ModelObjectProp, {"object": object});
         
         assertNotNull("[prop object] should have been set", model.object);
         assertEquals(
            "[prop object] should now hold reference to [var object]",
            object, model.object
         );
      }
      
      
      [Test]
      public function copyProperties_nullSource() : void
      {
         var model:Model = new Model();
         model.copyProperties(null);
         assertEquals("id should have not changed", 0, model.id);
         assertEquals("pending should have not changed", false, model.pending);
         assertEquals("age should have not changed", 0, model.age);
         assertEquals("name should have not changed", 0, model.name);
         assertEquals("surname should have not changed", 0, model.surname);
      };
      
      
      [Test]
      public function copyProperties_error() : void
      {
         var model:Model = new Model();
         
         try
         {
            model.copyProperties(new BaseModel());
            fail("Type error should have been thrown");
         }
         catch (e:Error) {}
         
         try
         {
            model.copyProperties(new Model(), false, ["age", "nonExisting"]);
            fail("Undefined property error should have been thrown.");
         }
         catch (e:Error) {}
      };
      
      
      [Test]
      public function copyProperties() : void
      {
         var dest:* = new Model();
         var src:* = new Model();
         var checkIfChanged:Function = function(prop:String) : void
         {
            assertEquals(prop + " should have been copied", src[prop], dest[prop]);
         };
         var checkIfNotChanged:Function = function(prop:String, oldValue:*) : void
         {
            assertEquals(
               prop + " should not have been changed",
               oldValue, dest[prop]
            );
         };
            
         // Try copying all properties
         src.id = 5;
         src.pending = true;
         src.age = 8;
         src.name = "Mykolas";
         src.surname = "Mickus";
         dest.copyProperties(src);
         checkIfChanged("id");
         checkIfChanged("age");
         checkIfChanged("name");
         checkIfChanged("surname");
         
         // Now just a few of them
         src.id = 8;
         src.pending = false;
         src.name = "Jonas";
         src.surname = "Abromaitis";
         dest.copyProperties(src, false, ["id", "name"]);
         checkIfChanged("id");
         checkIfChanged("name");
         checkIfNotChanged("pending", false);
         checkIfNotChanged("age", 8);
         checkIfNotChanged("surname", "Mickus");
         
         // Check if [SkipProperty] works
         dest = new ModelSkipProperty();
         src = new ModelSkipProperty();
         src.skipVariable = 5;
         src.skipAccessor = 5;
         src.notSkipVariable = 8;
         src.notSkipAccessor = 8;
         dest.copyProperties(src);
         checkIfChanged("notSkipVariable");
         checkIfChanged("notSkipAccessor");
         checkIfNotChanged("skipVariable", 0);
         checkIfNotChanged("skipAccessor", 0);
      };
   }
}