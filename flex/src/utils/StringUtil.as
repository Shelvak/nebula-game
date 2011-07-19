package utils
{
	import mx.collections.Sort;
	
	import utils.bkde.as3.parsers.CompiledObject;
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
      
      
      /* ########################## */
      /* ### EVAL FORMULA START ### */
      
      // this variant of evalFormula is approx. 25x faster than the old one
      // but more memory is required in return
      
      private static var CACHED_PARSERS:Object = new Object();
      private static const POWER_REGEXP:RegExp = /\*\*/g;
      private static const EMPTY_ARRAY:Array = [];
      public static function evalFormula(formula:String, params:Object = null) : Number {
         if (formula == null)
            return 0;
         var cachedParser:CachedMathParser = CACHED_PARSERS[formula];
         var paramNames:Array = getParamNames(params);
         var paramVals:Array  = getParamVals(params, paramNames);
         if (cachedParser == null) {
            var usableFormula:String = formula.replace(POWER_REGEXP, "^");
            var parser:MathParser = new MathParser(paramNames);
            var polishArray:Array = parser.doCompile(usableFormula).PolishArray;
            cachedParser = new CachedMathParser(parser, polishArray)
            CACHED_PARSERS[formula] = cachedParser;
         }
         return cachedParser.parser.doEval(cachedParser.polishArray, paramVals);
      }
      
      private static function getParamNames(paramsObj:Object) : Array {
         if (paramsObj == null)
            return EMPTY_ARRAY;
         var namesArray:Array = new Array();
         for (var name:String in paramsObj) {
            namesArray.push(name);
         }
         namesArray.sort();
         return namesArray;
      }
      
      private static function getParamVals(paramsObj:Object, paramNames:Array) : Array {
         if (paramsObj === null || paramNames.length == 0)
            return EMPTY_ARRAY;
         var vals:Array = new Array();
         for each (var name:String in paramNames) {
            vals.push(paramsObj[name]);
         }
         return vals;
      }
      
      /**
       * Clears all cached objects.
       */
      public static function reset() : void {
         CACHED_PARSERS = new Object();
      }
      
      /* ### EVAL FORMULA END ### */
      /* ######################## */
		
		
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
		
		
      private static const UCLETTER_REGEXP:RegExp = /[A-Z]/;
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
				return null;
			
			var pattern:RegExp = UCLETTER_REGEXP;
         pattern.lastIndex = -1;
			var transfValue:String = "";
			
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
       *Used to get checksum object from file downloaded by startup 
       */      
      public static function parseChecksums(from: String): Object
      {
         var obj: Object = {};
         try
         {
            var lines: Array = from.split('\n');
            for each (var line: String in lines)
            {
               var parts: Array = line.split(' ');
               obj[parts[0]] = parts[1];
            }
         }
         catch (err: Error)
         {
            throw new Error ('cant parse checksum file ' + err.message);
         }
         return obj;
      }
	}
}


import utils.bkde.as3.parsers.MathParser;


class CachedMathParser
{
   public function CachedMathParser(parser:MathParser, polishArray:Array) {
      this.parser      = parser;
      this.polishArray = polishArray;
   }
   
   public var parser:MathParser = null;
   public var polishArray:Array = null;
}