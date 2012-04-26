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
      private var keyboard: KeyboardMock;
      private var dictionary: ArrayCollection;
      private var client: AutoCompleteClientMock;
      private var autoComplete: AutoCompleteController;

      [Before]
      public function setUp(): void {
         keyboard = new KeyboardMock();
         dictionary = new ArrayCollection();
         client = new AutoCompleteClientMock();
         autoComplete = new AutoCompleteController(keyboard);
         autoComplete.client = client;
         autoComplete.dictionary = dictionary;
      }

      [Test]
      public function nullClient(): void {
         autoComplete = new AutoCompleteController(keyboard);
         autoComplete.dictionary = dictionary;

         assertThat(
            "null client does not cause exceptions",
            function():void{ keyboard.Tab() }, not (throws (Error))
         );

         autoComplete.client = null;
         assertThat(
            "null client does not cause exceptions",
            function (): void { keyboard.Tab() }, not (throws (Error))
         );
      }

      [Test]
      public function dictionaryProperty(): void {
         autoComplete = new AutoCompleteController(keyboard);
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
         keyboard.Tab();
         assertAutoCompleteListEmpty();

         client.reset();
         client.userInput = "test ";
         keyboard.Tab();
         assertAutoCompleteListEmpty();
      }

      [Test]
      public function noAvailableChoices(): void {
         addWord("aaa");
         addWord("aab");
         client.userInput = "c";
         keyboard.Tab();
         assertAutoCompleteListEmpty();
         assertThat( "input not changed", client.userInput, equals ("c") );
      }

      [Test]
      public function autoComplete_exactMatchOnly(): void {
         addWord("aaaa");
         addWord("aabb");
         client.userInput = "aaaa";
         keyboard.Tab();
         assertAutoCompleteListEmpty();
         assertThat( "input unchanged", client.userInput, equals ("aaaa") );

         client.reset();
         client.userInput = "aab test aab";
         keyboard.Tab();
         assertAutoCompleteListEmpty();
         assertThat(
            "should have completed the phrase",
            client.userInput, equals ("aab test aabb")
         );
      }

      [Test]
      public function autoComplete_partialMatchOnly(): void {
         addWord("aab");
         addWord("aaa");
         addWord("baa");
         addWord("bab");
         client.userInput = "a";
         keyboard.Tab();

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
            client.setAutoCompleteList_list, array ("aaa", "aab")
         );
      }

      [Test]
      public function partialAndExactMatch(): void {
         addWord("aa");
         addWord("aac");
         addWord("aab");
         client.userInput = "a";
         keyboard.Tab();

         assertThat(
            "user input should contain exact match",
            client.userInput, equals ("aa")
         );
         assertAutoCompleteListEmpty();

         client.reset();
         client.userInput = "aa";
         keyboard.Tab();

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
            client.setAutoCompleteList_list, array ("aa", "aab", "aac")
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


import flash.events.EventDispatcher;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

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

class KeyboardMock extends EventDispatcher
{
   public function Tab(): void {
      dispatchEvent(new KeyboardEvent(
         KeyboardEvent.KEY_UP, true, false, 0, Keyboard.TAB
      ));
   }
}
