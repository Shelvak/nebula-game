package tests._old.utils
{
   import org.flexunit.asserts.assertEquals;
   import org.flexunit.asserts.assertFalse;
   import org.flexunit.asserts.assertNull;
   import org.flexunit.asserts.assertTrue;
   
   import utils.PropertiesTransformer;
   
   public class PropertiesTranformerTest
   {
      // ######################################################## //
      // ### Testing cenversion form under_score to CamelCase ### //
      // ######################################################## //
      
      
      [Test]
      public function propToCamelCaseNull () :void
      {
         assertNull (PropertiesTransformer.propToCamelCase (null));
      }
      
      
      [Test]
      public function propToCamelCaseOneWord () :void
      {
         testToCamelCase ("name", "name");
      }
      
      
      [Test]
      public function propToCamelCaseFewWords () :void
      {
         testToCamelCase ("first_name", "firstName");
         testToCamelCase ("list_of_articles", "listOfArticles");
      }
      
      
      [Test]
      public function propToCamelCaseLong () :void
      {
         testToCamelCase (
            "this_is_very_long_damn_fraking_property",
            "thisIsVeryLongDamnFrakingProperty"
         );
      }
      
      
      private function testToCamelCase (data: String,
                                        result: String) :void
      {
         assertEquals (result, PropertiesTransformer.propToCamelCase (data));
      }
      
      
      
      
      // ######################################################## //
      // ### Testing cenversion form CamelCase to under_score ### //
      // ######################################################## //
      
      
      [Test]
      public function propToUnderScoreNull () :void
      {
         assertNull (PropertiesTransformer.propToUnderscore (null));
      }
      
      
      [Test]
      public function propToUnderScoreOneWord () :void
      {
         testToUnderscore ("name", "name");
      }
      
      
      [Test]
      public function propToUnderScoreFewWords () :void
      {
         testToUnderscore ("firstName", "first_name");
         testToUnderscore ("listOfArticles", "list_of_articles");
         testToUnderscore ("FirstIsUpper", "first_is_upper");
      }
      
      
      [Test]
      public function propToUnderScoreLong () :void
      {
         testToUnderscore (
            "thisIsVeryLongDamnFrakingProperty",
            "this_is_very_long_damn_fraking_property"
         );
      }
      
      
      private function testToUnderscore (data: String,
                                         result: String) :void
      {
         assertEquals (result, PropertiesTransformer.propToUnderscore (data));
      }
      
      
      
      
      // ###################################### //
      // ### Testing object transformations ### //
      // ###################################### //
      
      
      [Test]
      public function simpleObjectTransformation () :void
      {
         var obj: Object = {
            "first_name": "Mykolas",
            "second_name": "Mickus",
            "year_of_birth": 1987,
            "amount_of_money_in_bank": 10568.98
         };
         var transfObj: Object = PropertiesTransformer.objectToCamelCase (obj);
         
         // Checking properties' existance
         assertTrue (
            "firstName property should exist",
            transfObj.hasOwnProperty ("firstName")
         );
         assertTrue (
            "secondName property should exist",
            transfObj.hasOwnProperty ("secondName")
         );
         assertTrue (
            "yearOfBirth property should exist",
            transfObj.hasOwnProperty ("yearOfBirth")
         );
         assertTrue (
            "amountOfMoneyInBank property should exist",
            transfObj.hasOwnProperty ("amountOfMoneyInBank")
         );
         
         // Checking properties values
         assertEquals (
            "firstName should be equal to first_name",
            obj.first_name, transfObj.firstName
         );
         assertEquals (
            "secondName should be equal to second_name",
            obj.second_name, transfObj.secondName
         );
         assertEquals (
            "yearOfBirth should be equal to year_of_birth",
            obj.first_name, transfObj.firstName
         );
         assertEquals (
            "amountOfMoneyInBank should be equal to amount_of_money_in_bank",
            obj.amount_of_money_in_bank, transfObj.amountOfMoneyInBank
         );
      }
      
      
      [Test]
      public function complexObjectWithoutRecursivePointersTransformation ()
            :void
      {
         var obj: Object = {
            "fullName": "Mykolas Mickus",
            "yearOfBirth": 1987,
            "car": {
               "model": "Nissan Sunny",
               "maxSpeed": 200,
               "cubage": 1.6
            },
            "house": {
               "area": 85.5,
               "numberOfRooms": 6,
               "garage": {
                  "area": 5,
                  "cars": 1
               }
            }
         };
         
         var transfObj: Object = PropertiesTransformer.objectToUnderscore (obj);
         
         // Checking immediate properties existance
         testPropertyExistance (transfObj, "full_name");
         testPropertyExistance (transfObj, "year_of_birth");
         testPropertyExistance (transfObj, "car");
         testPropertyExistance (transfObj, "house");
         
         // Checking inner objects properties existance
         testPropertyExistance (transfObj.car, "model");
         testPropertyExistance (transfObj.car, "max_speed");
         testPropertyExistance (transfObj.car, "cubage");
         
         testPropertyExistance (transfObj.house, "area");
         testPropertyExistance (transfObj.house, "number_of_rooms");
         testPropertyExistance (transfObj.house, "garage");
         
         testPropertyExistance (transfObj.house.garage, "area");
         testPropertyExistance (transfObj.house.garage, "cars");
         
         // Checking immediate properties values
         testPropertiesValues (obj, "fullName", transfObj, "full_name");
         testPropertiesValues (obj, "yearOfBirth", transfObj, "year_of_birth");
         assertFalse (
            "car properties should not be the same instacnes",
            obj.car == transfObj.car
         );
         assertFalse (
            "house properties should not be the same instacnes",
            obj.house == transfObj.house
         );
         
         // Checking inner objets properies
         testPropertiesValues (obj.car, "model", transfObj.car, "model");
         testPropertiesValues (obj.car, "maxSpeed", transfObj.car, "max_speed");
         testPropertiesValues (obj.car, "cubage", transfObj.car, "cubage");
         
         testPropertiesValues (obj.house, "area", transfObj.house, "area");
         testPropertiesValues (
            obj.house, "numberOfRooms",
            transfObj.house, "number_of_rooms"
         );
         assertFalse (
            "garage objects should not be the same instances",
            obj.house.garange == transfObj.house.garage
         );
         
         testPropertiesValues (
            obj.house.garage, "area",
            transfObj.house.garage, "area"
         );
         testPropertiesValues (
            obj.house.garage, "cars",
            transfObj.house.garage, "cars"
         );
      }
      
      
      [Test]
      public function complexObjectWithArrayTransformation() : void
      {
         var obj: Object = {
            "full_name": "Mykolas Mickus",
            "year_of_birth": 1987,
            "girls": ["Laura", "Monika", "Kamilė"]
         };
         
         var transfObj: Object = PropertiesTransformer.objectToCamelCase (obj);
         
         testPropertyExistance(transfObj, "fullName");
         testPropertyExistance(transfObj, "yearOfBirth");
         testPropertyExistance(transfObj, "girls");
         
         assertTrue(
            "[prop girls] should be an array",
            transfObj.girls is Array
         );
         assertEquals(
            "[prop girls] should be an array with 3 elements",
            obj.girls.length, transfObj.girls.length
         );
         assertEquals(obj.girls[0], transfObj.girls[0]);
         assertEquals(obj.girls[1], transfObj.girls[1]);
         assertEquals(obj.girls[2], transfObj.girls[2]);
      }
      
      
      [Test]
      public function simpleObjectTransformationWithRecursivePointers () :void
      {
         var computer: Object = new Object ();
         var person: Object = {
            "computer": computer
         };
         computer.owned_by = person;
         
         var transfObj: Object =
            PropertiesTransformer.objectToCamelCase (person);
         
         // If this test finishes, it means PropertiesTransformer did not enter
         // infinite loop and the test has passed. Objects with recursive
         // pointers are not supported so no need to check here anything except
         // for that infinite loop
      }
      
      private function testPropertyExistance (obj: Object, prop: String) :void
      {
         assertTrue (
            prop + " property should exist",
            obj.hasOwnProperty (prop)
         );
      }
      
      
      private function testPropertiesValues (
            origObj: Object, origProp: String,
            transfObj: Object, transfProp: String
      ): void
      {
         assertEquals (
            origProp + " should be the same as " + transfProp,
            origObj[origProp], transfObj[transfProp]
         );
      }
   }
}