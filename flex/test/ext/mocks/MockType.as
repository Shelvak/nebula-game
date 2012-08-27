package ext.mocks
{
   import utils.Enum;


   public final class MockType extends Enum
   {
      public static const STRICT: MockType = new MockType("STRICT");
      public static const DYNAMIC: MockType = new MockType("DYNAMIC");
      public static const STUB: MockType = new MockType("STUB");

      public function MockType(name: String) {
         super(name);
      }
   }
}
