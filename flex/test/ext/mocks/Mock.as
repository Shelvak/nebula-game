package ext.mocks
{
   import asmock.framework.MockRepository;

   import namespaces.client_internal;

   import utils.Objects;
   import utils.SingletonFactory;


   public final class Mock
   {
      public static function object(
         repository: MockRepository,
         CLASS: Class,
         mockType: MockType,
         constructorArgs: Array = null)
      : * {
         Objects.paramNotNull("mockRepository", repository);
         Objects.paramNotNull("CLASS", CLASS);
         var mock:Object;
         switch (mockType) {
            case MockType.STUB:
               mock = repository.createStub(CLASS, null, constructorArgs);
               break;
            case MockType.STRICT:
               mock = repository.createStrict(CLASS, constructorArgs);
               break;
            case MockType.DYNAMIC:
               mock = repository.createDynamic(CLASS, constructorArgs);
               break;
         }
         return mock;
      }
      
      public static function singleton(
         repository: MockRepository,
         CLASS: Class,
         constructorArgs: Array = null)
      : void {
         SingletonFactory.client_internal::registerSingletonInstance(
            CLASS,
            object(repository, CLASS, MockType.STRICT, constructorArgs));
      }
   }
}
