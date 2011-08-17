package ext.mocks
{
   import asmock.framework.MockRepository;
   
   import namespaces.client_internal;
   
   import utils.Objects;
   import utils.SingletonFactory;

   
   public final class Mock
   {
      public static const TYPE_STRICT:int = 0;
      public static const TYPE_DYNAMIC:int = 1;
      public static const TYPE_STUB:int = 2;
      
      public static function object(repository:MockRepository,
                                    CLASS:Class,
                                    mockType:int = TYPE_STRICT,
                                    constructorArgs:Array = null) : * {
         Objects.paramNotNull("mockRepository", repository);
         Objects.paramNotNull("CLASS", CLASS);
         if (mockType != TYPE_STUB && mockType != TYPE_STRICT && mockType != TYPE_DYNAMIC)
            throw new ArgumentError(
               "[param mockType] must be equal to one of Mock.TYPE_* constants. Was: " + mockType
            );
         var mock:Object;
         switch (mockType) {
            case TYPE_STUB: mock = repository.createStub(CLASS, null, constructorArgs); break;
            case TYPE_STRICT: mock = repository.createStrict(CLASS, constructorArgs); break;
            case TYPE_DYNAMIC: mock = repository.createDynamic(CLASS, constructorArgs); break;
         }
         return mock;
      }
      
      public static function singleton(repository:MockRepository,
                                       CLASS:Class,
                                       mockType:int = TYPE_STRICT,
                                       constructorArgs:Array = null) : void {
         SingletonFactory.client_internal
            ::registerSingletonInstance(CLASS, object(repository, CLASS, mockType, constructorArgs));
      }
   }
}