package tests.utils
{
   import controllers.startup.StartupInfo;
   
   import ext.hamcrest.object.equals;
   
   import mx.resources.ResourceBundle;
   import mx.resources.ResourceManager;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.core.throws;
   import org.hamcrest.object.equalTo;
   
   import utils.locale.Locale;
   import utils.locale.Localizer;
   
   public class TC_Localizer
   {
      
      [Before]
      public function setUp() : void
      {
         var bundle: ResourceBundle = new ResourceBundle(Locale.EN, 'Test');
         bundle.content['simple'] = 'simpleString';
         bundle.content['params'] = 'simple {0} string';
         bundle.content['referenced'] = 'simple [reference:ref.notString] string';
         bundle.content['ref.notString'] = 'not';
         bundle.content['ref.real'] = 'real';
         bundle.content['chained'] = 'simple [reference:Test2/ref.notString] string';
         bundle.content['failed'] = 'simple [reference:Test2:ref.notString] string';
         bundle.content['emptyRef'] = 'simple [reference:Test2/ref.notStrukkk] string';
         bundle.content['chainedParams'] = 'simple [reference:Test2/ref.notString] {0} string';
         Localizer.addBundle(bundle);
         
         var bundle2: ResourceBundle = new ResourceBundle(Locale.EN, 'Test2');
         bundle2.content['ref.notString'] = 'not [reference:Test/ref.real]';
         Localizer.addBundle(bundle2);
         
         setCurrentLocale(Locale.EN);
      }
      
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
         assertThat(Localizer.string('Test', 'chained'), equalTo("simple not real string"));
      }
      
      [Test]
      public function findChainedStringWithReferenceAndParams() : void
      {
         assertThat(Localizer.string('Test', 'chainedParams', [12]), equalTo("simple not real 12 string"));
      }
      
      
      /* ##################### */
      /* ### PLURALIZATION ### */
      /* ##################### */
      
      
      private function pluralize(str:String, params:Array, locale:String = "en") : String
      {
         return Localizer.pluralize(str, params, locale);
      }
      
      
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
      }
      
      
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
      }
      
      
      [Test]
      public function pluralize_should_respect_english_rules() : void
      {
         var str:String = "{0 zero[no dogs] one[dog] many[? dogs]}";
         assertThat( "0",               pluralize(str, [0], Locale.EN), equals ("no dogs")  );
         assertThat( "1",               pluralize(str, [1], Locale.EN), equals ("dog")  );
         assertThat( "everything else", pluralize(str, [5], Locale.EN), equals ("5 dogs") );
      }
      
      
      [Test]
      public function pluralize_should_respect_english_rules_negativeValues() : void
      {
         var str:String = "{0 zero[? dogs] one[? dog] many[? dogs]}";
         assertThat( "0",                pluralize(str, [ 0], Locale.EN), equals ("0 dogs")  );
         assertThat( "-1",               pluralize(str, [-1], Locale.EN), equals ("-1 dog")  );
         assertThat( "-everything else", pluralize(str, [-5], Locale.EN), equals ("-5 dogs") );
      }
      
      
      [Test]
      public function pluralize_should_respect_lithuanian_rules() : void
      {
         function _pluralize(number:int) : String {
            return pluralize(
               "{0 zero[nėra šunų] one[šuo] 1sts[? šuo] tens[? šunų] many[? šunys]}",
               [number], Locale.LT
            );
         }
         
         assertThat( "is 0:  0", _pluralize( 0), equals ("nėra šunų") );
         assertThat( "is 1:  1", _pluralize( 1), equals ("šuo") );
         assertThat( "1st form: ends in 1, not 11: 21", _pluralize(21), equals ("21 šuo") );
         
         assertThat( "2nd form: ends in 0 or 10-20: 110", _pluralize(110), equals ("110 šunų") );
         assertThat( "2nd form: ends in 0 or 10-20:  11", _pluralize( 11), equals ( "11 šunų") );
         assertThat( "2nd form: ends in 0 or 10-20: 515", _pluralize(515), equals ("515 šunų") );
         assertThat( "2nd form: ends in 0 or 10-20: 220", _pluralize(220), equals ("220 šunų") );
         assertThat( "2nd form: ends in 0 or 10-20:  30", _pluralize( 30), equals ( "30 šunų") );
         
         assertThat( "3rd form: everything else:  8", _pluralize( 8), equals ( "8 šunys") );
         assertThat( "3rd form: everything else: 25", _pluralize(25), equals ("25 šunys") );
      }
      
      
      [Test]
      public function pluralize_should_respect_lithuanian_rules_negativeValues() : void
      {
         function _pluralize(number:int) : String {
            return pluralize(
               "{0 zero[? šunų] one[? šuo] 1sts[? šuo] tens[? šunų] many[? šunys]}",
               [number], Locale.LT
            );
         }
         
         assertThat( "is 0:   0", _pluralize( 0), equals ("0 šunų") );
         assertThat( "is 1:  -1", _pluralize(-1), equals ("-1 šuo") );
         assertThat( "1st form: ends in 1, not 11: -21", _pluralize(-21), equals ("-21 šuo") );
         
         assertThat( "2nd form: ends in 0 or 10-20: -110", _pluralize(-110), equals ("-110 šunų") );
         assertThat( "2nd form: ends in 0 or 10-20:  -11", _pluralize( -11), equals ( "-11 šunų") );
         assertThat( "2nd form: ends in 0 or 10-20: -515", _pluralize(-515), equals ("-515 šunų") );
         assertThat( "2nd form: ends in 0 or 10-20: -220", _pluralize(-220), equals ("-220 šunų") );
         assertThat( "2nd form: ends in 0 or 10-20:  -30", _pluralize( -30), equals ( "-30 šunų") );
         
         assertThat( "3rd form: everything else:  -8", _pluralize( -8), equals ( "-8 šunys") );
         assertThat( "3rd form: everything else: -25", _pluralize(-25), equals ("-25 šunys") );
      }
      
      
      [Test]
      public function pluralize_should_follow_lithuanian_fallbacks() : void {
         function _pluralize(number:int) : String {
            return pluralize("{0 one[? šuo] tens[? šunų] many[? šunys]}", [number], Locale.LT);
         }
         
         assertThat( "is 1: 1", _pluralize( 1), equals ("1 šuo") );
         assertThat( "ends in 1, not 11: 21", _pluralize(21), equals ("21 šuo") );
      }
      
      [Test]
      public function pluralize_should_respect_latvian_rules() : void {
         function _pluralize(number:int) : String {
            return pluralize(
               "{0 zero[? tanku] one[tanks] 1sts[? tanks] many[? tanki]}",
               [number], Locale.LV
            );
         }
         
         assertThat( "is 0: 0", _pluralize(0), equals ("0 tanku") );
         assertThat( "is 1: 1", _pluralize(1), equals ("tanks") );
         
         assertThat( "1st form: ends in 1, not 11:  21", _pluralize( 21), equals ( "21 tanks") );
         assertThat( "1st form: ends in 1, not 11: 101", _pluralize(101), equals ("101 tanks") );
         
         assertThat( "2nd form: everything else:  2", _pluralize( 2), equals ( "2 tanki") );
         assertThat( "2nd form: everything else: 11", _pluralize(11), equals ("11 tanki") );
         assertThat( "2nd form: everything else: 30", _pluralize(30), equals ("30 tanki") );
      }
      
      
      [Test]
      public function pluralize_should_follow_latvian_fallbacks() : void {
         function _pluralize(number:int) : String {
            return pluralize("{0 1sts[? tanks] many[? tanki]}", [number], Locale.LV);
         }
         
         assertThat( "is 1", _pluralize(1), equals ("1 tanks") );
         assertThat( "is 0", _pluralize(0), equals ("0 tanki") );
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
      }
      
      
      [Test]
      public function string_should_make_dereference_pass_before_pluralization_pass() : void
      {
         addPluralizationBundle();
         
         assertThat(
            "should dereference, then replace all parameters",
            string("reference", ["Bob", 2, "Yahoo!"]),
            equals ("Hi! My name is Bob and I have 2 cars. Yahoo!")
         );
      }
      
      [Test]
      public function resolveObjectNames() : void {
         function none(amount:int) : String {
            return Localizer.resolveObjectNames("[obj:" + amount + ":Shocker]");
         }
         function what(amount:int) : String {
            return Localizer.resolveObjectNames("[obj:" + amount + ":Shocker:what]");
         }
         function whos(amount:int) : String {
            return Localizer.resolveObjectNames("[obj:" + amount + ":Shocker:whos]");
         }
         setCurrentLocale(Locale.LT);
         addBundle(Locale.LT, "Objects", {
            "Shocker":      "{0 one[mechas] 1sts[? mechas] tens[? mechų] many[? mechai]}",
            "Shocker-what": "{0 one[mechą] 1sts[? mechą] tens[? mechų] many[? mechus]}",
            "Shocker-whos": "{0 one[mecho] 1sts[? mecho] tens[? mechų] many[? mechų]}"
         });
         
         assertThat( "none:  1", none( 1), equals(   "mechas") );
         assertThat( "none: 21", none(21), equals("21 mechas") );
         assertThat( "none: 12", none(12), equals( "12 mechų") );
         assertThat( "none: 37", none(37), equals("37 mechai") );
         
         assertThat( "what:   1", what(  1), equals (    "mechą") );
         assertThat( "what:  21", what( 21), equals ( "21 mechą") );
         assertThat( "what: 101", what(101), equals ("101 mechą") );
         assertThat( "what:  10", what( 10), equals ( "10 mechų") );
         assertThat( "what:  11", what( 11), equals ( "11 mechų") );
         assertThat( "what:  19", what( 19), equals ( "19 mechų") );
         assertThat( "what:  29", what( 29), equals ("29 mechus") );
         
         assertThat( "whos:   1", whos(  1), equals (    "mecho") );
         assertThat( "whos:  21", whos( 21), equals ( "21 mecho") );
         assertThat( "whos: 101", whos(101), equals ("101 mecho") );
         assertThat( "whos:  10", whos( 10), equals ( "10 mechų") );
         assertThat( "whos:  11", whos( 11), equals ( "11 mechų") );
         assertThat( "whos:  19", whos( 19), equals ( "19 mechų") );
         assertThat( "whos:  29", whos( 29), equals ( "29 mechų") );
      }
      
      [Test]
      public function resolveObjectNamesSupportsDowncasing() : void {
         setCurrentLocale(Locale.LT);
         function what(amount:int, downcase:Boolean) : String {
            var resolvableSequence:String = "[obj:" + amount + ":Shocker:what" + (downcase ? ":dc]" : "]");
            return Localizer.resolveObjectNames(resolvableSequence);
         }
         function none(amount:int, downcase:Boolean) : String {
            var resolvableSequence:String = "[obj:" + amount + ":Shocker" + (downcase ? "::dc]" : "]");
            return Localizer.resolveObjectNames(resolvableSequence);
         }
         function nonePlain(downcase:Boolean) : String {
            return Localizer.resolveObjectNames("[obj:0:Jumper" + (downcase ? "::dc]" : "]"));
         }
         addBundle(Locale.LT, "Objects", {
            "Jumper":       "DIDELIS Šoklys",
            "Shocker":      "{0 one[Mechas] 1sts[? Mechas] tens[? Mechų] many[? Mechai]}",
            "Shocker-what": "{0 one[Mechą] 1sts[? Mechą] tens[? Mechų] many[? Mechus]}"
         });
         
         assertThat( "U_case, none, plain:", nonePlain(false), equals ("DIDELIS Šoklys") );
         assertThat( "d_case, none, plain:", nonePlain( true), equals ("didelis šoklys") );
         
         assertThat( "U_case, none:  1", none( 1, false), equals (   "Mechas") );
         assertThat( "d_case, none:  1", none( 1,  true), equals (   "mechas") );
         assertThat( "U_case, none: 10", none(10, false), equals ( "10 Mechų") );
         assertThat( "d_case, none: 38", none(38,  true), equals ("38 mechai") );
         
         assertThat( "U_case, what:  1", what( 1, false), equals (    "Mechą") );
         assertThat( "d_case, what:  1", what( 1,  true), equals (    "mechą") );
         assertThat( "U_case, what: 22", what(22, false), equals ("22 Mechus") );
         assertThat( "d_case, what: 22", what(22,  true), equals ("22 mechus") );
      }
      
      [Test]
      public function objectNamesResolvingPassDoesNotRequireParameters() : void {
         setCurrentLocale(Locale.EN);
         addBundle(Locale.EN, "Test", {
            "test": "Increases [obj:0:Building_MetalStorage::dc]."
         });
         addBundle(Locale.EN, "Objects", {
            "Building_MetalStorage": "Metal Storage"
         });
         assertThat(
            Localizer.string("Test", "test"),
            equals ("Increases metal storage.")
         );
      }
      
      [Test]
      public function stringShouldAlsoResolveObjectNames() : void {
         function string(property:String, params:Array = null) : String {
            return Localizer.string("Test", property, params);
         }
         setCurrentLocale(Locale.LT);
         addBundle(Locale.LT, "Objects", {
            "Shocker": "Mechas",
            "Shocker-what": "{0 one[Mechą] 1sts[Mechą] tens[Mechų] many[Mechus]}",
            "Shocker-whos": "{0 one[Mecho] 1sts[Mecho] tens[Mechų] many[Mechų]}",
            "Azure-what": "{0 one[Azurą] 1sts[Azurą] tens[Azurų] many[Azurus]}",
            "Azure-whos": "{0 one[Azuro] 1sts[Azuro] tens[Azurų] many[Azurų]}"
         });
         addBundle(Locale.LT, "Test", {
            "amountAndObjNameWhat": "Pastatyk {0} [obj:{0}:{1}:what]",
            "amountAndObjNameWhatDC": "Pastatyk {0} [obj:{0}:{1}:what:dc]",
            "amountAndObjNameWhos": "Reikia {0} [obj:{0}:{1}:whos]",
            "amountAndObjNameDC": "{0} [obj:{0}:{1}::dc]"
         });
         
         assertThat( "amount: 11, name: Shocker, what",
            string("amountAndObjNameWhat", [11, "Shocker"]), equals ("Pastatyk 11 Mechų")
         );
         assertThat( "amount: 50, name: Shocker, what, DC",
            string("amountAndObjNameWhatDC", [11, "Shocker"]), equals ("Pastatyk 11 mechų")
         );
         assertThat( "amount: 50, name: Azure, what",
            string("amountAndObjNameWhat", [50, "Azure"]), equals ("Pastatyk 50 Azurų")
         );
         assertThat( "amount: 58, name: Shocker, what",
            string("amountAndObjNameWhat", [58, "Shocker"]), equals ("Pastatyk 58 Mechus")
         );
         assertThat( "amount: 1, name: Azure, what",
            string("amountAndObjNameWhat", [1, "Azure"]), equals ("Pastatyk 1 Azurą")
         );
         
         assertThat( "amount: 11, name: Shocker, whos",
            string("amountAndObjNameWhos", [11, "Shocker"]), equals ("Reikia 11 Mechų")
         );
         assertThat( "amount: 51, name: Azure, whos",
            string("amountAndObjNameWhos", [51, "Azure"]), equals ("Reikia 51 Azuro")
         );
         assertThat( "amount: 10, name: Shocker, DC",
            string("amountAndObjNameDC", [10, "Shocker"]), equals ("10 mechas")
         );
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
         
      private function addPluralizationBundle() : void {
         ResourceManager.getInstance().removeResourceBundlesForLocale(Locale.EN);
         addBundle(Locale.EN, "PluralizationTest", {
            "simple": "My name is {0}",
            "plural": "I have {0 one[? car] many[? cars]}",
            "both": "My name is {0} and I have {1 one[? car] many[? cars]}",
            "reference": "Hi! [reference:PluralizationTest/both]. {2}"
         });
      }
      
      private function string(property:String, params:Array = null) : String {
         return Localizer.string("PluralizationTest", property, params);
      }
      
      private function addBundle(locale:String, name:String, content:Object) : void {
         var bundle:ResourceBundle = new ResourceBundle(locale, name);
         for (var property:String in content) {
            bundle.content[property] = content[property];
         }
         Localizer.addBundle(bundle);
      }
      
      private function setCurrentLocale(locale:String) : void {
         StartupInfo.getInstance().locale = locale;
      }
   }
}
