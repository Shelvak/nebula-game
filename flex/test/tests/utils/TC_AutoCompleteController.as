package tests.utils
{
   import ext.hamcrest.collection.array;
   import ext.hamcrest.object.equals;

   import mx.collections.ArrayCollection;

   import org.hamcrest.assertThat;
   import org.hamcrest.collection.emptyArray;
   import org.hamcrest.core.not;
   import org.hamcrest.core.throws;
   import org.hamcrest.object.isTrue;
   import org.hamcrest.object.sameInstance;
   import org.hamcrest.text.emptyString;

   import utils.autocomplete.AutoCompleteController;


   public class TC_AutoCompleteController
   {
      private var dictionary: ArrayCollection;
      private var client: AutoCompleteClientMock;
      private var autoComplete: AutoCompleteController;

      [Before]
      public function setUp(): void {
         dictionary = new ArrayCollection();
         client = new AutoCompleteClientMock();
         autoComplete = new AutoCompleteController();
         autoComplete.client = client;
         autoComplete.dictionary = dictionary;
      }

      [Test]
      public function nullClient(): void {
         autoComplete = new AutoCompleteController();
         autoComplete.dictionary = dictionary;

         assertThat(
            "null client does not cause exceptions",
            function():void{ autoComplete.run() }, not (throws (Error))
         );

         autoComplete.client = null;
         assertThat(
            "null client does not cause exceptions",
            function (): void { autoComplete.run() }, not (throws (Error))
         );
      }

      [Test]
      public function dictionaryProperty(): void {
         autoComplete = new AutoCompleteController();
         assertThat(
            "default value", autoComplete.dictionary, emptyArray()
         );

         autoComplete.dictionary = dictionary;
         assertThat(
            "dictionary changed",
            autoComplete.dictionary, sameInstance (dictionary)
         );

         autoComplete.dictionary = null;
         assertThat(
            "null converted to empty list",
            autoComplete.dictionary, emptyArray()
         );
      }

      [Test]
      public function inputIsEmpty(): void {
         autoComplete.run();
         assertAutoCompleteListEmpty();

         client.reset();
         client.userInput = "test ";
         autoComplete.run();
         assertAutoCompleteListEmpty();
      }

      [Test]
      public function noAvailableChoices(): void {
         addWord("aaa");
         addWord("aab");
         client.userInput = "c";
         autoComplete.run();
         assertAutoCompleteListEmpty();
         assertThat( "input not changed", client.userInput, equals ("c") );
      }

      [Test]
      public function exactMatchOnly(): void {
         addWord("aaaa");
         addWord("aabb");
         client.userInput = "aaaa";
         autoComplete.run();
         assertAutoCompleteListEmpty();
         assertThat( "input unchanged", client.userInput, equals ("aaaa") );

         client.reset();
         client.userInput = "aab test aab";
         autoComplete.run();
         assertAutoCompleteListEmpty();
         assertThat(
            "should have completed the phrase",
            client.userInput, equals ("aab test aabb")
         );
      }

      [Test]
      public function partialMatchOnly(): void {
         addWord("aab");
         addWord("Aaa");
         addWord("bAa");
         addWord("bab");
         client.userInput = "A";
         autoComplete.run();

         assertThat(
            "user input should contain whole partial match",
            client.userInput, equals ("aa")
         );
         assertThat(
            "[param commonPart]",
            client.setAutoCompleteList_commonPart, equals ("aa")
         );
         assertThat(
            "[param list] should hold both words",
            client.setAutoCompleteList_list, array ("Aaa", "aab")
         );
      }

      [Test]
      public function partialAndExactMatch(): void {
         addWord("aa");
         addWord("aAc");
         addWord("aab");
         client.userInput = "a";
         autoComplete.run();

         assertThat(
            "user input should contain exact match",
            client.userInput, equals ("aa")
         );
         assertAutoCompleteListEmpty();

         client.reset();
         client.userInput = "aa";
         autoComplete.run();

         assertThat(
            "user input should not have changed",
            client.userInput, equals ("aa")
         );
         assertThat(
            "[param commonPart]",
            client.setAutoCompleteList_commonPart, equals ("aa")
         );
         assertThat(
            "[param list]",
            client.setAutoCompleteList_list, array ("aa", "aab", "aAc")
         );
      }

      private function assertAutoCompleteListEmpty(): void {
         assertThat(
            "client.setAutoCompleteList() should have been called",
            client.setAutoCompleteListCalled, isTrue()
         );
         assertThat(
            "[param list]",
            client.setAutoCompleteList_list, emptyArray()
         );
         assertThat(
            "[param commonPart]",
            client.setAutoCompleteList_commonPart, emptyString()
         );
      }

      private function addWord(value: String): void {
         dictionary.addItem(new AutoCompleteValue(value));
      }
   }
}


import utils.autocomplete.IAutoCompleteClient;
import utils.autocomplete.IAutoCompleteValue;


class AutoCompleteClientMock implements IAutoCompleteClient
{
   public var setAutoCompleteListCalled: Boolean;
   public var setAutoCompleteList_commonPart: String;
   public var setAutoCompleteList_list: Array;
   public function setAutoCompleteList(commonPart: String, list: Array): void {
      setAutoCompleteListCalled = true;
      setAutoCompleteList_commonPart = commonPart;
      setAutoCompleteList_list = list;
   }

   private var _input: String = "";
   public function set userInput(value: String): void {
      _input = value;
   }
   public function get userInput(): String {
      return _input;
   }

   public function reset(): void {
      _input = "";
      setAutoCompleteListCalled = false;
      setAutoCompleteList_commonPart = null;
      setAutoCompleteList_list = null;
   }
}

class AutoCompleteValue implements IAutoCompleteValue
{
   public function AutoCompleteValue(value: String) {
      _value = value;
   }

   private var _value: String;
   public function get autoCompleteValue(): String {
      return _value;
   }
}
