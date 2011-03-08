package utils
{
	import utils.bkde.as3.parsers.MathParser;
	
	/**
	 * Provides static methods for string manipulation. 
	 */   
	public class StringUtil
	{
      private static const mathParser: MathParser = new MathParser([]);
		/**
		 * Transforms first letter of a given string to UPPERCASE and returns resulting string.
		 *  
		 * @param value string to be transformed
		 * 
		 * @return Transformed string value.
		 */
		public static function firstToUpperCase(value:String) : String
		{
			if (value == null)
			{
				return null;
			}
			if (value.length == 0)
			{
				return value;
			}
			
			return value.charAt().toUpperCase() + value.substring(1);
		}
		
		
		/**
		 * Transforms first letter of a given string to lowercase and returns resulting string.
		 *  
		 * @param value string to be transformed
		 * 
		 * @return Transformed string value.
		 */
		public static function firstToLowerCase(value:String) : String
		{
			if (value == null)
			{
				return null;
			}
			if (value.length == 0)
			{
				return value;
			}
			
			return value.charAt().toLowerCase() + value.substring(1);
		}
		
		private static function filterFormula(formula: String, params: Object=null): String
		{
			if (params != null)
				for (var key:String in params) {
					formula = formula.replace(key, params[key].toString());
				}
			formula = formula.replace(/[^\d\s()+-\\*\/]/g, '');
			return formula;
		}
		
		public static function evalFormula(formula: String, params: Object = null): Number 
		{
         if (formula == null)
         {
            return 0;
         }
         params['**'] = '^';
         for (var key: String in params)
         {
            var formulaParts: Array = formula.split(key);
            formula = formulaParts.join(params[key]);
         }
         return mathParser.doEval(mathParser.doCompile(formula).PolishArray, []);
			//return D.evalToNumber(filterFormula(formula, params));
		}
		
		
		/**
		 * Transforms a given string form under_score to CamelCase notation (first symbol is
		 * lowercase letter).
		 *  
		 * @param value string to be transformed.
		 *  
		 * @return Transformed string value.
		 */
		public static function underscoreToCamelCaseFirstLower(value:String) : String
		{
			var transfValue: String = underscoreToCamelCase(value);
			return firstToLowerCase(transfValue);
		}
		
		
		/**
		 * Transforms a given string form under_score to CamelCase notation (first symbol is
		 * UPPERCASE letter).
		 *  
		 * @param value string to be transformed.
		 *  
		 * @return Transformed string value.
		 */
		public static function underscoreToCamelCase(value:String) : String
		{
			if (value == null)
			{
				return null;
			}
			
			var transfValue: String = "";
			var transfWord:  String = "";
			
			var words: Array = value.split ("_");
			
			if (words.length == 1)
			{
				return firstToUpperCase(value);
			}
			
			// Each word must begin with an UPPERCASE letter
			for each (var word: String in words)
			{
				transfValue += firstToUpperCase(word.toLowerCase ());
			}
			
			return transfValue;
		}
		
		
		/**
		 * Transforms a given string form CamelCase to under_score notation.
		 *  
		 * @param prop A string that needs to be transformed.
		 * 
		 * @return Transformed property.
		 */
		public static function camelCaseToUnderscore(value:String) : String
		{
			if (value == null)
			{
				return null;
			}
			
			var pattern: RegExp = /[A-Z]/;
			
			var transfValue: String = "";
			
			// Each word must be in lowercase and separated using underscore
			while (true)
			{
				var match: Object = pattern.exec (value);
				if (match != null)
				{
					transfValue += value.substring (0, match.index) + "_";
					
					// cut the first word out and make second word start
					// with a lowercase letter
					value = value.substring (match.index);
					if (value.length != 0)
					{
						value = firstToLowerCase(value);
					}
				}
				else
				{
					transfValue += value;
					break;
				}
			}
			
			// Remove the trailing and leading underscores
			if (transfValue.charAt(transfValue.length - 1) == "_")
			{
				transfValue = transfValue.substring(0, transfValue.length - 1);
			}
			if (transfValue.charAt() == "_")
			{
				transfValue = transfValue.substring(1);
			}
			
			return transfValue; 
		}
      
      
      /**
       * Compares two strings.
       * 
       * @param s0
       * @param s1
       * @param ignoreCase specifies whether case should be ignored or not
       * 
       * @return <code>-1</code> if <code>s0 < s1</code>, <code>+1</code> if <code>s0 > s2</code> or
       * <code>0</code> if <code>s0 == s1</code>. 
       */
      public static function compare(s0:String, s1:String, ignoreCase:Boolean = true) : int
      {
         var ss0:String = ignoreCase ? s0.toLowerCase() : s0;
         var ss1:String = ignoreCase ? s1.toLowerCase() : s1;
         if (ss0 < ss1)
         {
            return -1;
         }
         if (ss0 > ss1)
         {
            return 1;
         }
         return 0;
      }
	}
}