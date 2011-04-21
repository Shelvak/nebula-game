package tests._old.utils
{
   import com.adobe.utils.ArrayUtil;
   
   import net.digitalprimates.fluint.tests.TestCase;
   
   import utils.ClassUtil;
   
   
   public class ClassUtilTest extends TestCase
   {
      [Test]
      public function hasMetadata_object() : void
      {
         var o:* = new WithoutMetadata();
         assertEquals(
            "Null should have no metadata",
            false, ClassUtil.hasMetadata(null, "Custom")
         );
         assertEquals(
            "Should have no metadata 'Custom'",
            false, ClassUtil.hasMetadata(o, "Custom")
         );
         assertEquals(
            "Should have no metadata 'Unknown'",
            false, ClassUtil.hasMetadata(o, "Unknown")
         );
         
         o = new WithOneMetadataTag();
         assertEquals(
            "Should have metadata 'Custom'",
            true, ClassUtil.hasMetadata(o, "Custom")
         );
         assertEquals(
            "Should not have metadata 'Unknown'",
            false, ClassUtil.hasMetadata(o, "Unknown")
         );
         
         o = new WithLotsOfMetadata();
         assertEquals(
            "Should have metadata 'Custom'",
            true, ClassUtil.hasMetadata(o, "Custom")
         );
         assertEquals(
            "Should have metadata 'Unknown'",
            true, ClassUtil.hasMetadata(o, "Unknown")
         );
         assertEquals(
            "Should have metadata 'Ugly'",
            true, ClassUtil.hasMetadata(o, "Ugly")
         );
         assertEquals(
            "Should not have metadata 'Whatever'",
            false, ClassUtil.hasMetadata(o, "Whatever")
         );
      };
      
      
      [Test]
      public function hasMetadata_class() : void
      {
         assertEquals(
            "Should have no metadata 'Custom'",
            false, ClassUtil.hasMetadata(WithoutMetadata, "Custom")
         );
         assertEquals(
            "Should have no metadata 'Unknown'",
            false, ClassUtil.hasMetadata(WithoutMetadata, "Unknown")
         );
         
         
         assertEquals(
            "Should have metadata 'Custom'",
            true, ClassUtil.hasMetadata(WithOneMetadataTag, "Custom")
         );
         assertEquals(
            "Should not have metadata 'Unknown'",
            false, ClassUtil.hasMetadata(WithOneMetadataTag, "Unknown")
         );
         
         
         assertEquals(
            "Should have metadata 'Custom'",
            true, ClassUtil.hasMetadata(WithLotsOfMetadata, "Custom")
         );
         assertEquals(
            "Should have metadata 'Unknown'",
            true, ClassUtil.hasMetadata(WithLotsOfMetadata, "Unknown")
         );
         assertEquals(
            "Should have metadata 'Ugly'",
            true, ClassUtil.hasMetadata(WithLotsOfMetadata, "Ugly")
         );
         assertEquals(
            "Should not have metadata 'Whatever'",
            false, ClassUtil.hasMetadata(WithLotsOfMetadata, "Whatever")
         );
      };
      
      
      [Test]
      public function getPublicProperties_varsOnly() : void
      {
         var instance:ClassWithVariables = new ClassWithVariables();
         var props:Array;
         
         props = ClassUtil.getPublicProperties(instance);
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
         
         props = ClassUtil.getPublicProperties(instance, false);
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
         
         props = ClassUtil.getPublicProperties(instance);
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
         
         props = ClassUtil.getPublicProperties(instance, false);
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
         
         props = ClassUtil.getPublicProperties(instance);
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
         
         props = ClassUtil.getPublicProperties(instance, false);
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
         
         props = ClassUtil.getPublicProperties(instance);
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
         
         props = ClassUtil.getPublicProperties(instance, false);
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

class WithoutMetadata {}

[Custom]
class WithOneMetadataTag {}

[Custom]
[Unknown]
[Ugly]
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