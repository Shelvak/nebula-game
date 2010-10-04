package controllers.ui
{
   public class GameCursorPriority
   {
      /**
       * Step between two neighboring priorities.
       * 
       * @default 1000
       */
      public static const PRIORITY_STEP:uint = 1000;
      
      /**
       * @default uint.MAX_VALUE
       */
      public static const LOWEST:uint = uint.MAX_VALUE;
      
      /**
       * @default LOWEST - PRIORITY_STEP
       */
      public static const LOW:uint = LOWEST - PRIORITY_STEP;
      
      /**
       * @default LOW - PRIORITY_STEP
       */
      public static const NORMAL:uint = LOW - PRIORITY_STEP;
      
      /**
       * @default NORMAL - PRIORITY_STEP
       */
      public static const HIGH:uint = NORMAL - PRIORITY_STEP;
      
      /**
       * @default HIGH - PRIORITY_STEP
       */
      public static const HIGHEST:uint = HIGH - PRIORITY_STEP;
      
      
      public static const DEFAULT:uint = LOWEST;
      public static const DEFAULT_OVER:uint = LOW;
      public static const DEFAULT_CUSTOM:uint = NORMAL;
      public static const MAP_DEFAULT:uint = NORMAL;
      public static const MAP_GRIP:uint = HIGH;
   }
}