package utils.locale
{
   /**
    * Defines plural forms for each supported locale that must be provided in pluralizable strings.
    * There is a good list of plural forms for most of the languages at
    * https://developer.mozilla.org/en/Localization_and_Plurals
    */
   public final class PluralForm
   {
      /* ######################## */
      /* ### ENGLISH: 2 forms ### */
      /* ######################## */
      
      
      /**
       * English: is 1
       */
      public static const EN_ONE:String = "one";
      
      /**
       * English: everything else
       */
      public static const EN_ELSE:String = "many";
      
      
      /* ########################### */
      /* ### LITHUANIAN: 3 forms ### */
      /* ########################### */
      
      
      /**
       * Lithuanian: ends in 1, not 11
       */      
      public static const LT_ONE:String = EN_ONE;
      
      
      /**
       * Lithuanian: ends in 0 or ends in 10-20
       */
      public static const LT_TENS:String = "tens";
      
      
      /**
       * Lithuanian: everything else
       */
      public static const LT_ELSE:String = EN_ELSE;
   }
}