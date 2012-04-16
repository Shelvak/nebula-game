package utils
{
   import flash.utils.Dictionary;

   import namespaces.client_internal;


   public class SingletonFactory
   {
      static public function getSingletonInstance(type: Class): * {
         return instance.getInstance(type);
      }

      static public function clearSingletonInstance(type: Class): void {
         instance.clearInstance(type);
      }

      static public function clearAllSingletonInstances(): void {
         instance.clearAllInstances();
      }

      /**
       * Registers a given <code>instance</code> as a singleton of a given
       * <code>CLASS</code>.
       *
       * @param type any class <b>| not null</b>
       * @param instance instance of a given class to register as a singleton
       *        <b>| not null</b>
       */
      client_internal static function registerSingletonInstance(type: Class,
                                                                instanceObj: *): void {
         instance.client_internal::registerSingletonInstance(type, instanceObj);
      }

      private static var _instance: SingletonFactory = null;
      static protected function get instance(): SingletonFactory {
         if (_instance == null) {
            _instance = new SingletonFactory(SingletonLock);
         }
         return _instance;
      }

      public function SingletonFactory(lock: Class) {
         if (lock !== SingletonLock) {
            throw new Error(
               "You can't instantiate this class. Use static methods instead."
            );
         }
         clearAllInstances();
      }

      private var _instanceHash: Dictionary;

      public function getInstance(type: Class): * {
         var instance: * = _instanceHash[type];
         if (instance === undefined) {
            instance = new type();
            _instanceHash[type] = instance;
         }
         return instance;
      }

      public function clearInstance(type: Class): void {
         delete _instanceHash[type];
      }

      public function clearAllInstances(): void {
         _instanceHash = new Dictionary();
      }

      /**
       * @copy SingletonFactory#registerSingletonInstance()
       */
      client_internal function registerSingletonInstance(type: Class,
                                                         instance: *): void {
         Objects.paramNotNull("CLASS", type);
         Objects.paramNotNull("instance", instance);
         if (!(instance is type)) {
            throw new ArgumentError(
               "[param instance] " + instance + " must be an instance "
                  + "of " + type
            );
         }
         _instanceHash[type] = instance;
      }
   }
}


class SingletonLock {}