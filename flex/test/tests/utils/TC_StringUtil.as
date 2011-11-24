package tests.utils
{
   import org.flexunit.asserts.assertEquals;
   
   import utils.StringUtil;

   public class TC_StringUtil
   {
      [Test]
      public function firstToUpperCase() : void
      {
         assertEquals(
            "Should return null if null is passed.",
            null, StringUtil.firstToUpperCase(null)
         );
         
         assertEquals(
            "Should return empty string if empty string is passed.",
            "", StringUtil.firstToUpperCase("")
         );
         
         assertEquals(
            "Should not change non-letter symbol",
            "_", StringUtil.firstToUpperCase("_")
         );
         
         assertEquals(
            "Should not change non-letter symbol",
            "$", StringUtil.firstToUpperCase("$")
         );
         
         assertEquals(
            "Should not change non-letter symbol",
            "[", StringUtil.firstToUpperCase("[")
         );
         
         assertEquals(
            "Should return string with first UPPERCASE letter.",
            "A", StringUtil.firstToUpperCase("a")
         );
         
         assertEquals(
            "Should return string with first UPPERCASE letter.",
            "Dog", StringUtil.firstToUpperCase("dog")
         );
         
         assertEquals(
            "Should return string with first UPPERCASE letter.",
            "MyDog", StringUtil.firstToUpperCase("myDog")
         );
      };
      
      [Test]
      public function evalFormulaTest() : void
      {
         assertEquals(
            "Should replace vars", 15, StringUtil.evalFormula("10 + a", {a: 5}));
         
         assertEquals(
            "Should accept float vars", 8.7, StringUtil.evalFormula("10 + a", {a: -1.3}));
         
         assertEquals(
         "Should allow ** operator",
         64,
         StringUtil.evalFormula("2 ** 6")
         );
         
         assertEquals(
         "Should allow complex ** operator",
         4120,
         StringUtil.evalFormula("-96 + (2 ** 6) ** 2 + 120")
         );
         
         assertEquals(
         "Should solve complex equations",
         12.6,
         StringUtil.evalFormula("10 + (a - b + 10) / 5 + (2 ** c / 5)", {a: 2, b: 7, c: 3})
         );
         
         assertEquals(
            "Should solve complex equations",
            12.2,
            StringUtil.evalFormula("10 + (a - b + 10) / 5 + (2 * c / 5)", {a: 2, b: 7, c: 3})
         );
      }
      
      
      [Test]
      public function firstToLowerCase() : void
      {
         assertEquals(
            "Should return null if null is passed.",
            null, StringUtil.firstToLowerCase(null)
         );
         
         assertEquals(
            "Should return empty string if empty string is passed.",
            "", StringUtil.firstToLowerCase("")
         );
         
         assertEquals(
            "Should not change non-letter symbol",
            "_", StringUtil.firstToLowerCase("_")
         );
         
         assertEquals(
            "Should not change non-letter symbol",
            "$", StringUtil.firstToLowerCase("$")
         );
         
         assertEquals(
            "Should not change non-letter symbol",
            "[", StringUtil.firstToLowerCase("[")
         );
         
         assertEquals(
            "Should return string with first lowercase letter.",
            "a", StringUtil.firstToLowerCase("A")
         );
         
         assertEquals(
            "Should return string with first lowercase letter.",
            "dog", StringUtil.firstToLowerCase("Dog")
         );
         
         assertEquals(
            "Should return string with first lowercase letter.",
            "myDog", StringUtil.firstToLowerCase("MyDog")
         );
      };
      
      
      [Test]
      public function underscoreToCamelCase() : void
      {
         assertEquals(
            "Should return null if null is passed.",
            null, StringUtil.underscoreToCamelCase(null)
         );
         
         assertEquals(
            "Should return empty string if empty string is passed.",
            "", StringUtil.underscoreToCamelCase("")
         );
         
         assertEquals(
            "Should return string with first uppercase if no underscores are present.",
            "MyDog", StringUtil.underscoreToCamelCase("MyDog")
         );
         
         assertEquals(
            "Should return string tranformed to CamelCase notation.",
            "MyDog", StringUtil.underscoreToCamelCase("my_dog")
         );
         
         assertEquals(
            "Should return string tranformed to CamelCase notation.",
            "MyBigDog", StringUtil.underscoreToCamelCase("my_big_dog")
         );
      };
      
      
      [Test]
      public function underscoreToCamelCaseFirstLower() : void
      {
         assertEquals(
            "Should return null if null is passed.",
            null, StringUtil.underscoreToCamelCaseFirstLower(null)
         );
         
         assertEquals(
            "Should return empty string if empty string is passed.",
            "", StringUtil.underscoreToCamelCaseFirstLower("")
         );
         
         assertEquals(
            "Should return original string with first lowercase letter if no underscores are present.",
            "myDog", StringUtil.underscoreToCamelCaseFirstLower("MyDog")
         );
         
         assertEquals(
            "Should return string tranformed to camelCase (first lower letter) notation.",
            "myDog", StringUtil.underscoreToCamelCaseFirstLower("my_dog")
         );
         
         assertEquals(
            "Should return string tranformed to camelCase (first lower letter) notation.",
            "myBigDog", StringUtil.underscoreToCamelCaseFirstLower("my_big_dog")
         );
      };
      
      
      [Test]
      public function camelCaseToUnderscore () : void
      {
         assertEquals(
            "Should return null if null is passed.",
            null, StringUtil.camelCaseToUnderscore(null)
         );
         
         assertEquals(
            "Should return empty string if empty string is passed.",
            "", StringUtil.camelCaseToUnderscore("")
         );
         
         assertEquals(
            "Should return original string if no upper-case letters are present.",
            "string$without^upper_case",
            StringUtil.camelCaseToUnderscore("string$without^upper_case")
         );
         
         assertEquals(
            "First upper-case letter should not start string with underscore.",
            "a", StringUtil.camelCaseToUnderscore("A")
         );
         
         assertEquals(
            "First upper-case letter should not start string with underscore.",
            "my_dog", StringUtil.camelCaseToUnderscore("MyDog")
         );
         
         assertEquals(
            "Should return string transformed to under_score notation.",
            "my_big_dog", StringUtil.camelCaseToUnderscore("myBigDog")
         );
      }
      
      
      [Test]
      public function parseChecksums () : void
      {
         var parsed: Object = StringUtil.parseChecksums(
         'dog.swf af0e256\ncat.swf 2ec45');
         assertEquals(
            "Should parse correct checksums.",
            'af0e256', parsed['dog.swf']
         );
         
         assertEquals(
            "Should parse not only first line checksums.",
            '2ec45', parsed['cat.swf']
         );
      }
   }
}