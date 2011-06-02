package tests.utils.tests
{
   import ext.hamcrest.object.equals;
   
   import mx.resources.IResourceBundle;
   import mx.resources.ResourceBundle;
   import mx.resources.ResourceManager;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.core.throws;
   import org.hamcrest.object.equalTo;
   
   import utils.locale.Locale;
   import utils.locale.Localizer;
   
   public class TCLocalizer
   {
      
      [Before]
      public function setUp() : void
      {
         var bundle: ResourceBundle = new ResourceBundle(Locale.EN, 'Test');
         bundle.content['simple'] = 'simpleString';
         bundle.content['params'] = 'simple {0} string';
         bundle.content['referenced'] = 'simple [reference:ref.notString] string';
         bundle.content['ref.notString'] = 'not';
         bundle.content['ref.real'] = 'realy';
         bundle.content['chained'] = 'simple [reference:Test2/ref.notString] string';
         bundle.content['failed'] = 'simple [reference:Test2:ref.notString] string';
         bundle.content['emptyRef'] = 'simple [reference:Test2/ref.notStrukkk] string';
         bundle.content['chainedParams'] = 'simple [reference:Test2/ref.notString] {0} string';
         Localizer.addBundle(bundle);
         
         var bundle2: ResourceBundle = new ResourceBundle(Locale.EN, 'Test2');
         bundle2.content['ref.notString'] = 'not [reference:Test/ref.real]';
         Localizer.addBundle(bundle2);
      };
      
      [Test]
      public function findSimpleString() : void
      {
         assertThat(Localizer.string('Test', 'simple'), equalTo("simpleString"));
      }
      
      [Test]
      public function findStringWithParams() : void
      {
         assertThat(Localizer.string('Test', 'params', [12]), equalTo("simple 12 string"));
      }
      
      [Test]
      public function findStringWithReference() : void
      {
         assertThat(Localizer.string('Test', 'referenced'), equalTo("simple not string"));
      }
      
      [Test]
      public function findBadReference() : void
      {
         assertThat(function():void{Localizer.string('Test', 'failed')}, throws(ArgumentError));
      }
      
      [Test]
      public function findEmptyReference() : void
      {
         assertThat(function():void{Localizer.string('Test', 'emptyRef')}, throws(ArgumentError));
      }
      
      [Test]
      public function findChainedStringWithReference() : void
      {
         assertThat(Localizer.string('Test', 'chained'), equalTo("simple not realy string"));
      }
      
      [Test]
      public function findChainedStringWithReferenceAndParams() : void
      {
         assertThat(Localizer.string('Test', 'chainedParams', [12]), equalTo("simple not realy 12 string"));
      }
      
      
      /* ##################### */
      /* ### PLURALIZATION ### */
      /* ##################### */
      
      
      private function pluralize(str:String, params:Array, locale:String = "en") : String
      {
         return Localizer.pluralize(str, params, locale);
      };
      
      
      [Test]
      public function pluralize_should_cause_errors_when_parameters_are_malformed() : void
      {
         function _pluralize(str:String, params:Array, locale:String = "en") : Function
         {
            return function() : String { return pluralize(str, params, locale) };
         }
         
         
         assertThat(
            "should throw error when unsupported locale is provided",
            _pluralize("{0 one[a dog] many[? dogs]}", [1, 2], "fr"), throws (Error)
         );
         
         assertThat(
            "should throw error when not enough parameters",
            _pluralize("{0 one[? dog] many[? dogs]} {1 one[? cat] many[? dogs]}", [1]), throws (Error)
         );
         
         assertThat(
            "should throw error when pluralized string does not have all forms specified",
            _pluralize("{0 one[? dog]}", [2]), throws (Error)
         );
      };
      
      
      [Test]
      public function pluralize_general_behaviour() : void
      {
         assertThat(
            "should leave characters outside parameter definition",
            pluralize("{0} have {0 one[? car] many[? cars]}", [1]),
            equals ("{0} have 1 car")
         );
         
         assertThat(
            "should not include parameters in result if there are no question marks to replace",
            pluralize("{0 one[a dog] many[dogs]}", [1]),
            equals ("a dog")
         );
         
         assertThat(
            "should replace question marks with parameters",
            pluralize("{0 one[? dog] many[? dogs]}", [2]), 
            equals ("2 dogs")
         );
         
         assertThat(
            "should pluralize all parameters in the string",
            pluralize("{0 one[CAT] many[CATS]} vs {1 one[DOG] many[DOGS]}", [5, 5]),
            equals ("CATS vs DOGS")
         );
         
         // Added by arturaz. 2011-05-25
         // Support for string replacement when param is not a number.
         assertThat(
            "should pluralize strings too",
            pluralize("{0 bar[CAT] foo[CATS]} vs {1 foo[DOG] bar[DOGS]}", ["foo", "bar"]),
            equals ("CATS vs DOGS")
         );
      };
      
      
      [Test]
      public function pluralize_should_respect_english_rules() : void
      {
         var str:String = "{0 zero[no dogs] one[dog] many[? dogs]}";
         assertThat( "0",               pluralize(str, [0], Locale.EN), equals ("no dogs")  );
         assertThat( "1",               pluralize(str, [1], Locale.EN), equals ("dog")  );
         assertThat( "everything else", pluralize(str, [5], Locale.EN), equals ("5 dogs") );
      };
      
      
      [Test]
      public function pluralize_should_respect_lithuanian_rules() : void
      {
         function _pluralize(number:int) : String
         {
            return pluralize(
               "{0 zero[nėra šunų] one[šuo] 1sts[? šuo] tens[? šunų] many[? šunys]}",
               [number], Locale.LT);
         }
         
         assertThat( "is 0:  0", _pluralize( 0), equals ("nėra šunų") );
         assertThat( "is 1:  1", _pluralize( 1), equals ("šuo") );
         assertThat( "1st form: ends in 1, not 11: 21", _pluralize(21), equals ("21 šuo") );
         
         assertThat( "2nd form: ends in 0 or 10-20: 110", _pluralize(110), equals ("110 šunų") );
         assertThat( "2nd form: ends in 0 or 10-20:  11", _pluralize( 11), equals ( "11 šunų") );
         assertThat( "2nd form: ends in 0 or 10-20: 515", _pluralize(515), equals ("515 šunų") );
         assertThat( "2nd form: ends in 0 or 10-20: 220", _pluralize(220), equals ("220 šunų") );
         assertThat( "2nd form: ends in 0 or 10-20:  30", _pluralize( 30), equals ( "30 šunų") );
         
         assertThat( "3rd form: everything else", _pluralize( 8), equals ( "8 šunys") );
         assertThat( "3rd form: everything else", _pluralize(25), equals ("25 šunys") );
      };
      
      [Test]
      public function pluralize_should_follow_fallbacks() : void
      {
         function _pluralize(number:int) : String
         {
            return pluralize("{0 one[? šuo] tens[? šunų] many[? šunys]}", [number], Locale.LT);
         }
         
         assertThat( "is 1:  1", _pluralize( 1), equals ("1 šuo") );
         assertThat( "ends in 1, not 11: 21", _pluralize(21), equals ("21 šuo") );
      };
      
      
      private function addPluralizationBundle() : void
      {
         ResourceManager.getInstance().removeResourceBundlesForLocale(Locale.EN);
         var bundle:ResourceBundle = new ResourceBundle(Locale.EN, "PluralizationTest");
         with (bundle)
         {
            content["simple"] = "My name is {0}";
            content["plural"] = "I have {0 one[? car] many[? cars]}";
            content["both"] = "My name is {0} and I have {1 one[? car] many[? cars]}";
            content["reference"] = "Hi! [reference:PluralizationTest/both]. {2}";
         }
         Localizer.addBundle(bundle);
      }
      
      
      private function string(property:String, params:Array = null) : String
      {
         return Localizer.string("PluralizationTest", property, params);
      }
      
      
      [Test]
      public function string_should_replace_simple_as_well_as_pluralizable_parameters() : void
      {
         addPluralizationBundle();
         
         assertThat(
            "should only replace simple parameter if pluralization is not required",
            string("simple", ["Bob"]), equals ("My name is Bob")
         );
         
         assertThat(
            "should only replace pluralizable parameters if simple ones are not required",
            string("plural", [2]), equals ("I have 2 cars")
         );
         
         assertThat(
            "should replace both parameter types",
            string("both", ["Bob", 2]), equals ("My name is Bob and I have 2 cars")
         );
      };
      
      
      [Test]
      public function string_should_make_dereference_pass_before_pluralization_pass() : void
      {
         addPluralizationBundle();
         
         assertThat(
            "should dereference, then replace all parameters",
            string("reference", ["Bob", 2, "Yahoo!"]),
            equals ("Hi! My name is Bob and I have 2 cars. Yahoo!")
         );
      };
   }
}
