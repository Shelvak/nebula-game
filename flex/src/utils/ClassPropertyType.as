package utils
{
   public class ClassPropertyType
   {
      /**
       * Any static variable, property or constant.
       */
      public static const STATIC_ANY:int = 0;
      /**
       * Static variable defined like this: <code>static var name:type</code>. 
       */
      public static const STATIC_VAR:int = 1;
      /**
       * Static property defined as setter/getter pair.
       */
      public static const STATIC_PROP:int = 2;
      /**
       * Static constant (hopefully everyone thinks that non-static constants
       * are bad idea).
       */
      public static const STATIC_CONST:int = 3;
   }
}