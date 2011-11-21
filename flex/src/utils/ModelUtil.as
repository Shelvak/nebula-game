package utils
{
   /**
    * Defines static methods for working with models and their properties.
    */
   public class ModelUtil
   {
      /**
       * A token used to separate model subclass from base class (::).
       */
      public static const MODEL_SUBCLASS_SEPARATOR:String = "::";
      
      
      /**
       * Extracts and returns model class name (a.k.a. object class, base model
       * class) from the given full (Class::Subclass) or partial (Class) model
       * type name. The string returned starts with a lowercase letter unless
       * <code>firstUppercase</code> is <code>true</code>.
       * 
       * @param type full or partial model type name.
       *        | <b>Not null. Not empty string.</b>
       */
      public static function getModelClass(type: String,
                                           firstUppercase: Boolean = false): String {
         Objects.paramNotEquals("type", type, [null, ""]);
         var separatorIdx: int = type.indexOf(MODEL_SUBCLASS_SEPARATOR);
         if (separatorIdx < 0) {
            if (firstUppercase) {
               return StringUtil.firstToUpperCase(type);
            }
            return StringUtil.firstToLowerCase(type);
         }
         else {
            if (firstUppercase) {
               return StringUtil.firstToUpperCase(
                  type.substring(0, separatorIdx)
               );
            }
            return StringUtil.firstToLowerCase(type.substring(0, separatorIdx));
         }
      }
      
      
      /**
       * Extracts and returns model subclass name (a.k.a. object subclass) from
       * the given full (Class::Subclass) model type name. Throws error if a
       * subclass can't be extracted unless <code>failIfMissing</code> is
       * <code>false</code>. In that case this method returns <code>null</code>.
       * 
       * @param type full or partial model type name
       *        | <b>Not null. Not empty string.</b>
       */
      public static function getModelSubclass(type: String,
                                              failIfMissing: Boolean = true): String {
         Objects.paramNotEquals("type", type, [null, ""]);
         var separatorIdx: int = type.indexOf(MODEL_SUBCLASS_SEPARATOR);
         if (separatorIdx < 0) {
            if (failIfMissing) {
               throw new ArgumentError(
                  "Type name must have subclass (i.e. Class::Subclass) for "
                     + "this method to work but was " + type
               );
            }
            return null;
         }
         return type.substr(separatorIdx + MODEL_SUBCLASS_SEPARATOR.length);
      }

      /**
       * Combines given model base class with model subclass to model type name. Both parts are separated
       * using <code>MODEL_SUBCLASS_SEPARATOR</code> and the value returned starts with a lowercase letter
       * unless <code>firstUppercase</code> is <code>true</code>.
       *
       * @see MODEL_SUBCLASS_SEPARATOR
       */
      public static function getModelType(modelClass: String,
                                          modelSubclass: String,
                                          firstUppercase: Boolean = false): String {
         Objects.paramNotEquals("modelClass", modelClass, [null, ""]);
         Objects.paramNotEquals("modelSubclass", modelSubclass, [null, ""]);
         return (firstUppercase
                    ? StringUtil.firstToUpperCase(modelClass)
                    : StringUtil.firstToLowerCase(modelClass))
                   + MODEL_SUBCLASS_SEPARATOR
                   + StringUtil.firstToUpperCase(modelSubclass);
      }
   }
}