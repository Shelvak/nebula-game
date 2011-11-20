package tests._old.utils
{
   import mx.collections.ArrayCollection;
   
   import org.flexunit.asserts.assertFalse;
   import org.flexunit.asserts.assertTrue;
   import org.hamcrest.assertThat;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;
   
   import spark.components.Button;
   
   import utils.TypeChecker;
   
   
   public class TypeCheckerTest
   {
      // ############################### //
      // ### Testing primitive types ### //
      // ############################### //
      
      
      [Test]
      public function isOfPrimitiveTypeUndefined () :void
      {
         assertTrue (
            "with no parameters should return true",
            TypeChecker.isOfPrimitiveType ()
         );
      };
      
      
      [Test]
      public function isOfPrimitiveTypeNull () :void
      {
         testPrimitive (null, "null");
      };
      
      
      [Test]
      public function isOfPrimitiveTypeBoolean () :void
      {
         testPrimitive (true, "Boolean (true)");
         testPrimitive (false, "Boolean (false)");
      };
      
      
      [Test]
      public function isOfPrimitiveTypeSignedInteger () :void
      {
         var signedInt: int = -5;
         testPrimitive (signedInt, "int (-5)");
      };
      
      
      [Test]
      public function isOfPrimitiveTypeUsignedInteger () :void
      {
         var unsignedInt: uint = 5;
         testPrimitive (unsignedInt, "uint (5)");
      };
      
      
      [Test]
      public function isOfPrimitiveTypeNumber () :void
      {
         testPrimitive (5.5, "Number (5.5)");
         testPrimitive (NaN, "Number (NaN)");
      };
      
      
      [Test]
      public function isOfPrimitiveTypeString () :void
      {
         testPrimitive ("five", "String ('five')");
      }
      
      
      private function testPrimitive (obj: *, typeName: String) :void
      {
         assertTrue (
            typeName + " should be a primitive type",
            TypeChecker.isOfPrimitiveType (obj)
         );
      }
      
      
      
      
      // ############################# //
      // ### Testing complex types ### //
      // ############################# //
      
      
      [Test]
      public function isOfPrimitiveTypeObject () :void
      {
         testComplex (new Object (), "Basic object");
      };
      
      
      [Test]
      public function isOfPrimitiveTypeControl () :void
      {
         testComplex (new Button (), "Control (Button)");
      };
      
      
      [Test]
      public function isOfPrimitiveTypeXML () :void
      {
         testComplex (<xml/>, "XML (<xml/>)");
      }

      
      private function testComplex (obj: *, typeName: String) :void
      {
         assertFalse (
            typeName + " should not be a primitive type",
            TypeChecker.isOfPrimitiveType (obj)
         );
      }
      
      
      // ################ //
      // ### isVector ### //
      // ################ //
      
      
      [Test]
      public function isVectorNotAVector() : void
      {
         assertFalse(
            "null should not be a Vector",
            TypeChecker.isVector(null)
         );
         assertFalse(
            "Instance of a generic object should not be a Vector",
            TypeChecker.isVector(new Object)
         );
         assertFalse(
            "A number should not be a Vector",
            TypeChecker.isVector(0)
         );
      }
      
      
      [Test]
      public function isVectorPrimitives() : void
      {
         assertTrue(
            "A Vector of integers should be a Vector",
            TypeChecker.isVector(new Vector.<int>())
         );
         assertTrue(
            "A Vector of strings should be a Vector",
            TypeChecker.isVector(new Vector.<String>())
         );
      }
      
      
      [Test]
      public function isVectorObjects() : void
      {
         assertTrue(
            "A Vector of generic objects should be a Vector",
            TypeChecker.isVector(new Vector.<Object>())
         );
         assertTrue(
            "A Vector of Buttons should be a Vector",
            TypeChecker.isVector(new Vector.<Button>())
         );
      }
      
      [Test]
      public function isCollection() : void {
         function isCollection(instance:*) : Boolean {
            return TypeChecker.isCollection(instance);
         }
         
         assertThat( "Array is a collection", isCollection(new Array()), isTrue() );
         assertThat( "Vector.<int> is a collection", isCollection(new Vector.<int>()), isTrue() );
         assertThat( "Vector.<Object> is a collection", isCollection(new Vector.<Object>()), isTrue() );
         assertThat( "IList is a collection", isCollection(new ArrayCollection()), isTrue() );
         assertThat( "null is not a collection", isCollection(null), isFalse() );
         assertThat( "Object is not a collection", isCollection(new Object()), isFalse() );
         assertThat( "String is not a collection", isCollection("String"), isFalse() );
      }
   }
}