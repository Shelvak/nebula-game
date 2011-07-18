package tests._old.utils
{
   import com.adobe.utils.ArrayUtil;
   
   import net.digitalprimates.fluint.tests.TestCase;
   
   import utils.Objects;
   
   
   public class ObjectsTest extends TestCase
   {
      [Test]
      public function hasMetadata() : void
      {
         assertEquals(
            "Should have no metadata 'Required'",
            false, Objects.hasMetadata(WithoutMetadata, "Required")
         );
         assertEquals(
            "Should have no metadata 'Unknown'",
            false, Objects.hasMetadata(WithoutMetadata, "Unknown")
         );
         
         
         assertEquals(
            "Should have metadata 'Required'",
            true, Objects.hasMetadata(WithOneMetadataTag, "Required")
         );
         assertEquals(
            "Should not have metadata 'Unknown'",
            false, Objects.hasMetadata(WithOneMetadataTag, "Unknown")
         );
         
         
         assertEquals(
            "Should have metadata 'Required'",
            true, Objects.hasMetadata(WithLotsOfMetadata, "Required")
         );
         assertEquals(
            "Should have metadata 'Optional'",
            true, Objects.hasMetadata(WithLotsOfMetadata, "Optional")
         );
         assertEquals(
            "Should have metadata 'ArrayElementType'",
            true, Objects.hasMetadata(WithLotsOfMetadata, "ArrayElementType")
         );
         assertEquals(
            "Should not have metadata 'Whatever'",
            false, Objects.hasMetadata(WithLotsOfMetadata, "Whatever")
         );
      };
      
      
      [Test]
      public function getPublicProperties_varsOnly() : void
      {
         var instance:ClassWithVariables = new ClassWithVariables();
         var props:Array;
         
         props = Objects.getPublicProperties(ClassWithVariables);
         assertEquals(
            "2 properties should be public and writable",
            2, props.length
         );
         assertTrue(
            "Should contain 'publicVar1'",
            ArrayUtil.arrayContainsValue(props, "publicVar1")
         );
         assertTrue(
            "Should contain 'publicVar2'",
            ArrayUtil.arrayContainsValue(props, "publicVar2")
         );
         
         props = Objects.getPublicProperties(ClassWithVariables, false);
         assertEquals(
            "Only 2 writable/readable properties should be public",
            2, props.length
         );
         assertTrue(
            "Should contain 'publicVar1'",
            ArrayUtil.arrayContainsValue(props, "publicVar1")
         );
         assertTrue(
            "Should contain 'publicVar2'",
            ArrayUtil.arrayContainsValue(props, "publicVar2")
         );
      };
      
      
      [Test]
      public function getPublicProperties_accessorsOnly() : void
      {
         var instance:ClassWithAccessors = new ClassWithAccessors();
         var props:Array;
         
         props = Objects.getPublicProperties(ClassWithAccessors);
         assertEquals(
            "There should be 4 public writable properties",
            4, props.length
         );
         assertTrue(
            "Should contain 'publicReadWriteProp1'",
            ArrayUtil.arrayContainsValue(props, "publicReadWriteProp1")
         );
         assertTrue(
            "Should contain 'publicReadWriteProp2'",
            ArrayUtil.arrayContainsValue(props, "publicReadWriteProp2")
         );
         assertTrue(
            "Should contain 'publicWriteOnlyProp1'",
            ArrayUtil.arrayContainsValue(props, "publicWriteOnlyProp1")
         );
         assertTrue(
            "Should contain 'publicWriteOnlyProp2'",
            ArrayUtil.arrayContainsValue(props, "publicWriteOnlyProp1")
         );
         
         props = Objects.getPublicProperties(ClassWithAccessors, false);
         assertEquals(
            "There should be 6 public writable or readable properties",
            6, props.length
         );
         assertTrue(
            "Should contain 'publicReadOnlyProp1'",
            ArrayUtil.arrayContainsValue(props, "publicReadOnlyProp1")
         );
         assertTrue(
            "Should contain 'publicReadOnlyProp2'",
            ArrayUtil.arrayContainsValue(props, "publicReadOnlyProp2")
         );
         assertTrue(
            "Should contain 'publicReadWriteProp1'",
            ArrayUtil.arrayContainsValue(props, "publicReadWriteProp1")
         );
         assertTrue(
            "Should contain 'publicReadWriteProp2'",
            ArrayUtil.arrayContainsValue(props, "publicReadWriteProp2")
         );
         assertTrue(
            "Should contain 'publicWriteOnlyProp1'",
            ArrayUtil.arrayContainsValue(props, "publicWriteOnlyProp1")
         );
         assertTrue(
            "Should contain 'publicWriteOnlyProp2'",
            ArrayUtil.arrayContainsValue(props, "publicWriteOnlyProp2")
         );
      };
      
      
      [Test]
      public function getPublicProperties_mixed() : void
      {
         var instance:ClassMixedProps = new ClassMixedProps();
         var props:Array;
         
         props = Objects.getPublicProperties(ClassMixedProps);
         assertEquals(
            "There should be 2 public writable properties",
            2, props.length
         );
         assertTrue(
            "Should contain 'publicVar'",
            ArrayUtil.arrayContainsValue(props, 'publicVar')
         );
         assertTrue(
            "Should contain 'publicWriteOnlyProp'",
            ArrayUtil.arrayContainsValue(props, 'publicWriteOnlyProp')
         );
         
         props = Objects.getPublicProperties(ClassMixedProps, false);
         assertEquals(
            "There should be 3 public writable properties",
            3, props.length
         );
         assertTrue(
            "Should contain 'publicVar'",
            ArrayUtil.arrayContainsValue(props, 'publicVar')
         );
         assertTrue(
            "Should contain 'publicWriteOnlyProp'",
            ArrayUtil.arrayContainsValue(props, 'publicWriteOnlyProp')
         );
         assertTrue(
            "Should contain 'publicReadOnlyProp'",
            ArrayUtil.arrayContainsValue(props, 'publicReadOnlyProp')
         );
      };
      
      
      [Test]
      public function getPublicProperties_extensionOfMixed() : void
      {
         var instance:ExtensionOfMixed = new ExtensionOfMixed();
         var props:Array;
         
         props = Objects.getPublicProperties(ExtensionOfMixed);
         assertEquals(
            "There should be 4 public writable properties",
            4, props.length
         );
         assertTrue(
            "Should contain 'publicVar'",
            ArrayUtil.arrayContainsValue(props, 'publicVar')
         );
         assertTrue(
            "Should contain 'publicWriteOnlyProp'",
            ArrayUtil.arrayContainsValue(props, 'publicWriteOnlyProp')
         );
         assertTrue(
            "Should contain 'newPublicVar'",
            ArrayUtil.arrayContainsValue(props, 'newPublicVar')
         );
         assertTrue(
            "Should contain 'newPublicWriteOnlyProp'",
            ArrayUtil.arrayContainsValue(props, 'newPublicWriteOnlyProp')
         );
         
         props = Objects.getPublicProperties(ExtensionOfMixed, false);
         assertEquals(
            "There should be 5 public writable properties",
            5, props.length
         );
         assertTrue(
            "Should contain 'publicVar'",
            ArrayUtil.arrayContainsValue(props, 'publicVar')
         );
         assertTrue(
            "Should contain 'publicWriteOnlyProp'",
            ArrayUtil.arrayContainsValue(props, 'publicWriteOnlyProp')
         );
         assertTrue(
            "Should contain 'publicReadOnlyProp'",
            ArrayUtil.arrayContainsValue(props, 'publicReadOnlyProp')
         );
         assertTrue(
            "Should contain 'newPublicVar'",
            ArrayUtil.arrayContainsValue(props, 'newPublicVar')
         );
         assertTrue(
            "Should contain 'newPublicWriteOnlyProp'",
            ArrayUtil.arrayContainsValue(props, 'newPublicWriteOnlyProp')
         );
      };
   }
}


/**
 * Only specify metadata that is kept by the compiler - default and our own 4 tags - if you want ant
 * task to run tests successfully.
 */

class WithoutMetadata {}

[Required]
class WithOneMetadataTag {}

[Required]
[Optional]
[ArrayElementType]
class WithLotsOfMetadata {}

class ClassWithVariables
{
   public var publicVar1:int;
   public var publicVar2:Number;
   
   protected var protectedVar1:int;
   protected var protectedVar2:Number;
   
   private var privateVar1:int;
   private var privateVar2:Number;
}

class ClassWithAccessors
{
   public function get publicReadOnlyProp1() : int    { return 0; }
   public function get publicReadOnlyProp2() : Number { return 0; }
   public function set publicReadWriteProp1(v:String) : void {}
   public function get publicReadWriteProp1() : String { return ""; }
   public function set publicReadWriteProp2(v:Number) : void {}
   public function get publicReadWriteProp2() : Number { return 0; }
   public function set publicWriteOnlyProp1(v:String) : void {}
   public function set publicWriteOnlyProp2(v:String) : void {}
   
   protected function get protectedReadOnlyProp() : String { return ""; }
   protected function set protectedReadWriteProp(v:Number) : void {}
   protected function get protectedReadWriteProp() : Number { return 0; }
   protected function set protectedWriteOnlyProp(v:Number) : void {}
   
   private function get privateReadOnlyProp() : String { return ""; }
   private function set privateReadWriteProp(v:Number) : void {}
   private function get privateReadWriteProp() : Number { return 0; }
   private function set privateWriteOnlyProp(v:Number) : void {}
}

class ClassMixedProps
{
   public  var publicVar: int = 0;
   private var privateVar: int = 0;
   
   protected function set protectedReadWriteProp(v:Number) : void {}
   protected function get protectedReadWriteProp() : Number { return 0; }
   
   public function get publicReadOnlyProp() : String { return ""; }
   
   public function set publicWriteOnlyProp(v:uint) : void {}
}

class ExtensionOfMixed extends ClassMixedProps
{
   public var newPublicVar: String;
   
   public function set newPublicWriteOnlyProp(v:String) : void {}
}