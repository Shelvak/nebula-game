package utils
{
   import com.developmentarc.core.utils.InstanceFactory;
   
   import namespaces.client_internal;
   
   
   /**
    * A Singleton Class that enables any item to be used as a Singleton reference.  This Class creates a new
    * instance of the requested Class type and then stores the reference in a static table. When an instance
    * of a previously requested Class is made, the perviously generated instance is returned.
    * 
    * <p>This class acts as a Singleton facade to the InstanceFactory Class. </p>
    * 
    * <p>This is an extension that allows registering singletons explicitly (usefull for testing - does not
    * make much sense for production).</p>
    * 
    * @author James Polanco, MikisM
    */
   public class SingletonFactory extends InstanceFactory
   {
      /* STATIC PROPERTIES */
      /**
       * @private
       * The static instance of the class.
       */
      static protected var __instance: SingletonFactory;

      /**
       * Used to get access to an instance of the Class type
       * requested.  This method first determines if the Class
       * type has been requested before.  If the Class has never
       * been requested, the method creates a new instance of the
       * Class, stores it in a table and then returns a reference
       * to the Class.
       *
       * <p>If the Class type has been requested previously, the
       * method returns the previously generated instance. </p>
       *
       * @param type The Class of the instance to return.
       * @return The generated instance of the Class.
       *
       */
      static public function getSingletonInstance(type: Class): * {
         return instance.getInstance(type);
      }
      
      /**
       * Used to remove a specific instance type from the factory.
       * This method checks to see if the requeted type has an intance
       * in the table, and if so the instance is removed.  This enables
       * getInstance() to create a new instance the next time the method
       * is called.  If the instance type does not exist, nothing occurs.
       *
       * @param type The type of instance to look for and remove.
       *
       */
      static public function clearSingletonInstance(type: Class): void {
         instance.clearInstance(type);
      }

      /**
       * Used to remove all current instances from the Factory.
       *
       */
      static public function clearAllSingletonInstances(): void {
         instance.clearAllInstances();
      }

      /**
       * Returns the current instance of the SingletonFactory.
       *
       * @return Current instance of the factory.
       *
       */
      static protected function get instance(): SingletonFactory {
         if (!__instance) {
            __instance = new SingletonFactory(SingletonLock);
         }
         return __instance;
      }

      /**
       * Constructor -- DO NOT CALL.
       * @private
       * @param lock
       *
       */
      public function SingletonFactory(lock: Class) {
         super();

         // only extended classes can call the instance directly
         if (!lock is SingletonLock) {
            throw new Error(
               "Invalid use of SingletonFactory constructor, do not "
                  + "call directly."
            );
         }
      }

      /**
       * Registers a given <code>instance</code> as a singleton of a given <code>CLASS</code>.
       *
       * @param type any class. <b>Not null.</b>
       * @param instance instance of a given class to register as a singleton. <b>Not null.</b>
       */
      client_internal static function registerSingletonInstance(type: Class,
                                                                instanceObj: *): void {
         instance.client_internal::registerSingletonInstance(type, instanceObj);
      }
      
      /**
       * @copy SingletonFactory#registerSingletonInstance()
       */
      client_internal function registerSingletonInstance(type: Class,
                                                         instanceObj: *): void {
         Objects.paramNotNull("CLASS", type);
         Objects.paramNotNull("instanceObj", instanceObj);
         if (!(instanceObj is type)) {
            throw new ArgumentError(
               "[param instanceObj] " + instanceObj + " must be an instance "
                  + "of class " + type
            );
         }
         instanceTable.addItem(type, instanceObj);
      }
   }
}
   
   
class SingletonLock
{
  public function SingletonLock() {}
}