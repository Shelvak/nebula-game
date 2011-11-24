package utils.locale
{
   import com.adobe.utils.StringUtil;

   import mx.resources.IResourceBundle;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.utils.ObjectUtil;

   import utils.Objects;


   public class Localizer
   {
      private static function get RM() : IResourceManager
      {
         return ResourceManager.getInstance();
      }
      
      
      private static const REFERENCE_REGEXP:RegExp = /\[reference:((\w+)\/)?(.+?)\]/;
      
      private static var currentBundle: String;
      
      private static function refReplace(matchedString: String,
                                         unused: String,
                                         bundleName: String,
                                         propertyName: String,
                                         matchPosition: int,
                                         completeString: String): String
      {
         var bundle: String = bundleName ? bundleName : currentBundle;
         return string(bundle, propertyName);
      }
      
      public static function string(bundle: String, property: String, parameters: Array = null): String
      {
         // using workaround for wrong implementation of IResourceManager
         // see http://bugs.adobe.com/jira/browse/SDK-17041
         var resultString: String;
         if (property in RM.getResourceBundle(Locale.currentLocale, bundle).content) 
         {
            resultString = RM.getResourceBundle(
               Locale.currentLocale, bundle).content[property];
            if (parameters)
               resultString = mx.utils.StringUtil.substitute(
                  resultString, parameters);
         }
         else
         {
            throw new Error('Resource ' + property + ' for bundle ' + bundle + 
               ' not found!');
         }
         var matches:Array = resultString.match(REFERENCE_REGEXP);
         while (matches != null) {
            currentBundle = bundle;
            try {
               resultString = resultString.replace(REFERENCE_REGEXP, refReplace);
            }
            catch (e: Error) {
               throw new ArgumentError(
                  'Localizer failed to replace reference ' + resultString + 
                  e.toString());
            }
            matches = resultString.match(REFERENCE_REGEXP);
         }
         
         // objects name resolving pass
         try {
            resultString = resolveObjectNames(resultString);
         }
         catch (err:Error) {
            throwPassFailedError(
               "Objects name resolving",
               err.message, bundle, property, resultString, parameters
            );
         }
            
         if (parameters != null) {
            // pluralization pass is the last one
            try {
               resultString = pluralize(resultString, parameters);
               resultString = mx.utils.StringUtil.substitute(resultString, parameters);
            }
            catch (err:Error) {
               throwPassFailedError(
                  "Pluralization",
                  err.message, bundle, property, resultString, parameters
               );
            }
         }
         return resultString;
      }
      
      
      public static function addBundle(bundle: IResourceBundle): void
      {
         RM.addResourceBundle(bundle);
         RM.update();
      }
      
      
      /* ############################## */
      /* ### Object names resolving ### */
      /* ############################## */
      
      private static const OBJECT_REGEXP:RegExp =
                              /\[obj:\d+:\w+(:\w+(:dc)?|::dc)?\]/;
      
      /**
       * Resolves names of objects in a string. Resolves each sequence of the form:
       * <code>[obj:{amount}:{name}(:{form})]</code> (parantheses indicate optional parts). Here:
       * <ul>
       *    <li><code>{amount}</code> - number of objects (to determine correct form)</li>
       *    <li><code>{name}</code> - name of an object (must match locale entries)</li>
       *    <li><code>{form}</code> - optional form (string) of the name like <code>what</code> or
       *        <code>whos</code> (must match locale entries)</li>
       * </ul>
       * 
       * @param str a string that may or may not contain resolvable sequences
       * 
       * @return copy of <code>str</code> with all object names resolved
       */
      public static function resolveObjectNames(str:String) : String {
         Objects.paramNotNull("str", str);
         var matchResult:Object = null;
         while ((matchResult = OBJECT_REGEXP.exec(str)) != null) {
            var match:String = matchResult[0];
            var replacement:String = resolveObjectName(match);
            str = str.replace(match, replacement);
         }
         return str;
      }
      
      private static function resolveObjectName(formKey:String) : String {
         Objects.paramNotNull("formKey", formKey);
         formKey = formKey.substring(1, formKey.length - 1);
         var parts:Array = formKey.split(":");
         var amount:int = int(parts[1]);
         var type:String = parts[2];
         var form:String = parts.length > 3 ? parts[3] : null;
         var downcase:Boolean = parts.length > 4;
         var property:String = type;
         if (form != null && form.length > 0) {
            property += "-" + form;
         }
         var resolvedName:String = string("Objects", property, [amount]);
         if (downcase) {
            resolvedName = resolvedName.toLocaleLowerCase();
         }
         return resolvedName;
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
            var parameter:* = parameters[paramIndex];
            var usableFormNames:Array = (parameter is Number) 
               ? getPluralForms(locale, parameter as Number)
               : [parameter];
            var forms:String = paramPatternResult[2];
            
            // Try to match any form that matches.
            //
            // e.g. if we have ["ones", "firsts"] first try to match "ones"
            // and if that does not exist, try "firsts". Raise error
            // if none of the forms can be applied.
            var formMatched: Boolean = false;
            for each(var usableFormName: String in usableFormNames) {
               // look for required form and construct parameter replacement
               var formPatternResult:Object = null;
               FORM_PATTERN.lastIndex = 0;
               
               // Match form regexps.
               while ((formPatternResult = FORM_PATTERN.exec(forms)) != null)
               {
                  var formName:String = formPatternResult[1];
                  var formData:String = formPatternResult[2];
                  if (formName == usableFormName)
                  {
                     matchedParamRepl = StringUtil.replace(
                        formData, "?", parameter
                     );
                     break;
                  }
               }

               if (matchedParamRepl != null)
               {
                  str = StringUtil.replace(
                     str, matchedParamStr, matchedParamRepl
                  );
                  formMatched = true;
                  break;
               }
            }
            
            if (! formMatched) {
               // we didn't find a required plural form
               throw new Error(
                  "None of plural forms [" + usableFormNames.map(
                     function(item:String): String { return "'" + item + "'" }  
                  ).join(", ") + 
                  "] found in parameter " + matchedParamStr +
                  " for parameter " + parameter + 
                  ". The string to pluralize was: " + str
               );
            }
         }
         return str;
      }
      
      
      private static function getPluralForms(locale:String, number:int) : Array
      {
         Objects.paramNotNull("locale", locale);
         // negatives are treated the same way as positives
         number = Math.abs(number);
         switch (locale)
         {
            case Locale.EN:
               if (number == 0) {
                  return [PluralForm.EN_ZERO, PluralForm.EN_ELSE];
               }
               if (number == 1) {
                  return [PluralForm.EN_ONE];
               }
               return [PluralForm.EN_ELSE];
            
            case Locale.LT:
               if (number == 0) {
                  return [PluralForm.LT_ZERO, PluralForm.LT_TENS];
               }
               if (number == 1) { 
                  return [PluralForm.LT_ONE, PluralForm.LT_FIRSTS];
               }
               if (number % 10 == 1 && number != 11) {
                  return [PluralForm.LT_FIRSTS, PluralForm.LT_ONE];
               }
               if (number % 10 == 0 || 10 <= number % 100 && number % 100 <= 20) {
                  return [PluralForm.LT_TENS];
               }
               return [PluralForm.LT_ELSE];
            
            case Locale.LV:
               if (number == 0) {
                  return [PluralForm.LV_ZERO, PluralForm.LV_ELSE];
               }
               if (number == 1) {
                  return [PluralForm.LV_ONE, PluralForm.LV_FIRSTS];
               }
               if (number % 10 == 1 && number != 11) {
                  return [PluralForm.LV_FIRSTS]
               }
               return [PluralForm.LV_ELSE];
               
            default:
               throw new ArgumentError("Unsupported locale: " + locale);
         }
         
         return null;   // unreachable
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private static function throwPassFailedError(passName:String,
                                                   errorMessage:String,
                                                   bundle:String,
                                                   property:String,
                                                   propertyValue:String,
                                                   parameters:Array) : void {
         throw new Error(
            passName + " pass has failed with message: " + errorMessage + "\n" +
            "Bundle: " + bundle + "\n" +
            "Property: " + property + "\n" +
            "Property value: " + propertyValue + "\n" +
            "Parameters: " + ObjectUtil.toString(parameters)
         );
      }
   }
}
