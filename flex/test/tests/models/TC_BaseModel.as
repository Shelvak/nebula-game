package tests.models
{
   import ext.hamcrest.object.equals;
   
   import models.BaseModel;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.core.throws;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.text.emptyString;
   
   import tests.models.classes.Model;
   import tests.models.classes.ModelSkipProperty;

   public class TC_BaseModel
   {
      /* ######################## */
      /* ### copyProperties() ### */
      /* ######################## */
      
      [Test]
      public function copyProperties_nullSource() : void {
         var model:Model = new Model();
         model.copyProperties(null);
         assertThat( "id should have not changed", model.id, equals (0) );
         assertThat( "pending should have not changed", model.pending, isFalse() );
         assertThat( "age should have not changed", model.age, equals (0) );
         assertThat( "name should have not changed", model.name, emptyString() );
         assertThat( "surname should have not changed", model.surname, emptyString() );
      }
      
      [Test]
      public function copyProperties_errors() : void {
         var model:Model = new Model();
         function $_copying(source:BaseModel, ignoreSkipProperty:Boolean = false, props:Array = null) : Function {
            return function() : void {
               model.copyProperties(source, ignoreSkipProperty, props);
            }
         }
         assertThat( "[param source] of different type", $_copying(new BaseModel()), throws (TypeError) );
         assertThat( "[param props] has undefined property", $_copying(new Model(), false, ["age", "nonExisting"]) );
      }
      
      [Test]
      public function copyProperties() : void {
         var dest:* = new Model();
         var src:* = new Model();
         function checkIfChanged(prop:String) : void {
            assertThat( prop + " should have been copied", dest[prop], equals (src[prop]) );
         };
         function checkIfNotChanged(prop:String, oldValue:*) : void {
            assertThat( prop + " should not have been changed", dest[prop], equals(oldValue) );
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
      }
   }
}