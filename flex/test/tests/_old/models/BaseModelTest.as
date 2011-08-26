package tests._old.models
{
   import models.BaseModel;
   
   import org.flexunit.asserts.assertEquals;
   import org.flexunit.asserts.fail;
   
   import tests._old.models.classes.Model;
   import tests._old.models.classes.ModelSkipProperty;
   
   
   public class BaseModelTest
   {
      private var data: Object;
      private var model: *;
      
      
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
