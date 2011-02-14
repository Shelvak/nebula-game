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
       * Extracts and returns model class name (a.k.a. object class, base model class) from the given full
       * (Class::Subclass) or partial (Class) model type name.
       */
      public static function getModelClass(type:String) : String
      {
         var separatorIdx:int = type.indexOf(MODEL_SUBCLASS_SEPARATOR);
         if (separatorIdx < 0)
         {
            return StringUtil.firstToLowerCase(type);
         }
         else
         {
            return StringUtil.firstToLowerCase(type.substring(0, separatorIdx));
         }
      }
      
      
      /**
       * Extracts and returns model subclass name (a.k.a. object subclass) from the given full
       * (Class::Subclass) model type name.
       */
      public static function getModelSubclass(type:String) : String
      {
         var separatorIdx:int = type.indexOf(MODEL_SUBCLASS_SEPARATOR);
         if (separatorIdx < 0)
         {
            throw new ArgumentError("Type name must have subclass (i.e. Class::Subclass) for this method " +
                                    "to work but was " + type);
         }
         return type.substr(separatorIdx + MODEL_SUBCLASS_SEPARATOR.length);
      }
      
      
      /**
       * Combines given model base class with model subclass to model type name. Both parts are separated
       * using <code>MODEL_SUBCLASS_SEPARATOR</code> and the value returned starts with a lowercase letter.
       * 
       * @see MODEL_SUBCLASS_SEPARATOR
       */
      public static function getModelType(modelClass:String, modelSubclass:String) : String
      {
         return StringUtil.firstToLowerCase(modelClass) + MODEL_SUBCLASS_SEPARATOR + modelSubclass;
      }
   }
}