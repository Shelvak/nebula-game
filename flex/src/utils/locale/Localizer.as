package utils.locale
{
   import com.adobe.utils.StringUtil;
   
   import mx.resources.IResourceBundle;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.utils.StringUtil;
   
   import utils.Objects;
   
   
   public class Localizer
   {
      private static function get RM() : IResourceManager
      {
         return ResourceManager.getInstance();
      }
      
      
      private static const REFERENCE_REGEXP: RegExp = /\[reference:((\w+)\/)?(.+?)\]/;
      
      private static var currentBundle: String;
      
      private static function refReplace(matchedString: String, unused: String, bundleName: String, 
                                         propertyName: String, matchPosition: int, 
                                         completeString: String): String
      {
         var bundle: String = bundleName ? bundleName : currentBundle;
         return string(bundle, propertyName);
      }
      
      public static function string(bundle: String, property: String, parameters: Array = null): String
      {
         var resultString: String = RM.getString(
            bundle, property, parameters, Locale.currentLocale
         );
         // resultString == "undefined" is needed due to a wrong implementation of IResourceManager
         // see http://bugs.adobe.com/jira/browse/SDK-17041
         if (resultString == null || resultString == "undefined")
         {
            throw new Error('Resource ' + property + ' for bundle ' + bundle + ' not found!');
         }
         var matches:Array = resultString.match(REFERENCE_REGEXP);
         while (matches != null)
         {
            currentBundle = bundle;
            try
            {
               resultString = resultString.replace(REFERENCE_REGEXP, refReplace);
            }
            catch (e: Error)
            {
               throw new ArgumentError('Localizer failed to replace reference' + resultString + e.toString());
            }
            matches = resultString.match(REFERENCE_REGEXP);
         }
         
         if (parameters != null)
         {
            // pluralization pass is the last one
            return mx.utils.StringUtil.substitute(pluralize(resultString, parameters), parameters);
         }
         else
         {
            return resultString;
         }
      }
      
      
      public static function get localeChain(): Array
      {
         return RM.localeChain;
      }
      
      
      public static function addBundle(bundle: IResourceBundle): void
      {
         RM.addResourceBundle(bundle);
         RM.update();
      }
      
      
      /* ##################### */
      /* ### PLURALIZATION ### */
      /* ##################### */
      
      
      private static const PARAM_PATTERN:RegExp = /\{(\d+)\s+(\w+\[.*?\])\s*\}/s;
      private static const FORM_PATTERN:RegExp  = /(\w+)\[(.*?)\]/g;
      
      
      /**
       * Pluralizes a given string according to the rules of current (or provided) locale.
       * 
       * @param str a string that needs to be pluralized.
       *            <b>Not null.</b>
       * @param parameters a list of numbers that will be used to determine the plural form to be used and
       *                   probably will be included in the resulting string as well.
       *                   <b>Not null.</b>
       * @param locale a locale (one of <code>Locale</code> constants) that will determine the rules of
       *        pluralization. If not provided, current locale will be used.
       * 
       * @return a modified <code>str</code> which has parameters that require pluralization replaced. 
       */
      public static function pluralize(str:String, parameters:Array, locale:String = null) : String
      {
         Objects.paramNotNull("str", str);
         Objects.paramNotNull("parameters", parameters);
         if (locale == null)
         {
            locale = Locale.currentLocale;
         }
         
         var paramPatternResult:Object = null;
         while ((paramPatternResult = PARAM_PATTERN.exec(str)) != null)
         {
            var matchedParamStr:String = paramPatternResult[0];
            var matchedParamRepl:String = null;
            var paramIndex:int = int(paramPatternResult[1]);
            if (paramIndex >= parameters.length)
            {
               throw new Error(
                  "Too few parameters: parameter with index " + paramIndex + " is required but only " +
                  parameters.length + " were provided. The string to pluralize was: " + str
               );
            }
            var useNumber:Number = parameters[paramIndex];
            var useForms:Array = getPluralForms(locale, useNumber);
            var forms:String = paramPatternResult[2];
            
            // Try to match any form that matches.
            //
            // e.g. if we have ["ones", "firsts"] first try to match "ones"
            // and if that does not exist, try "firsts". Raise error
            // if none of the forms can be applied.
            var formMatched: Boolean = false;
            for (var useForm: String in useForms) {
               // look for required form and construct parameter replacement
               var formPatternResult:Object = null;
               FORM_PATTERN.lastIndex = 0;
               while ((formPatternResult = FORM_PATTERN.exec(forms)) != null)
               {
                  var form:String = formPatternResult[1];
                  var formData:String = formPatternResult[2];
                  if (form == useForm)
                  {
                     matchedParamRepl = com.adobe.utils.StringUtil.replace(
                        formData, "?", useNumber.toString());
                     break;
                  }
               }
               
               if (matchedParamRepl != null)
               {
                  str = com.adobe.utils.StringUtil.replace(str, 
                     matchedParamStr, matchedParamRepl);
                  formMatched = true;
                  break;
               }
            }
            
            if (! formMatched) {
               // we didn't find a required plural form
               throw new Error(
                  "None of plural forms '" + useForms.join(", ") + 
                  "' found in parameter " + matchedParamStr +
                  " for number " + useNumber + 
                  ". The string to pluralize was: " + str
               );
            }
         }
         return str;
      }
      
      
      private static function getPluralForms(locale:String, number:int) : Array
      {
         Objects.paramNotNull("locale", locale);
         switch (locale)
         {
            case Locale.EN:
               return number == 0 ?
                  [PluralForm.EN_ZERO, PluralForm.EN_ELSE] :
                  (number == 1 ? 
                     [PluralForm.EN_ONE] :
                     [PluralForm.EN_ELSE]);
            
            case Locale.LT:
               if (number == 0) 
               {
                  return [PluralForm.LT_ZERO, PluralForm.LT_TENS];
               }
               else if (number == 1) 
               {
                  return [PluralForm.LT_ONE, PluralForm.LT_FIRSTS]; 
               }
               else if (number % 10 == 1 && number != 11)
               {
                  return [PluralForm.LT_FIRSTS, PluralForm.LT_ONE];
               }
               else
               {
                  return (
                     number % 10 == 0 || 
                     10 <= number % 100 && number % 100 <= 20
                  ) ?
                     [PluralForm.LT_TENS] :
                     [PluralForm.LT_ELSE];
               }
            
            default:
               throw new ArgumentError("Unsupported locale: " + locale);
         }
         
         return null;   // unreachable
      }
   }
}