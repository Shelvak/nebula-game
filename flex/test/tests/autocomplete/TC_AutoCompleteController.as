package tests.autocomplete
{
   import ext.hamcrest.collection.array;
   import ext.hamcrest.object.equals;

   import mx.collections.ArrayCollection;

   import org.hamcrest.assertThat;
   import org.hamcrest.collection.emptyArray;
   import org.hamcrest.object.isTrue;
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
         autoComplete = new AutoCompleteController(dictionary, client, keyboard);
      }

      [Test]
      public function inputIsEmpty(): void {
         keyboard.Tab();
         assertAutoCompleteListEmpty();

         client.reset();
         client.input = "test ";
         keyboard.Tab();
         assertAutoCompleteListEmpty();
      }

      [Test]
      public function noAvailableChoices(): void {
         addWord("aaa");
         addWord("aab");
         client.input = "c";
         keyboard.Tab();
         assertAutoCompleteListEmpty();
         assertThat( "input not changed", client.input, equals ("c") );
      }

      [Test]
      public function autoComplete_exactMatchOnly(): void {
         addWord("aaaa");
         addWord("aabb");
         client.input = "aaaa";
         keyboard.Tab();
         assertAutoCompleteListEmpty();
         assertThat( "input unchanged", client.input, equals ("aaaa") );

         client.reset();
         client.input = "aab test aab";
         keyboard.Tab();
         assertAutoCompleteListEmpty();
         assertThat(
            "should have completed the phrase",
            client.input, equals ("aab test aabb")
         );
      }

      [Test]
      public function autoComplete_partialMatchOnly(): void {
         addWord("aab");
         addWord("aaa");
         client.input = "a";
         keyboard.Tab();

         assertThat(
            "user input should contain whole partial match",
            client.input, equals ("aa")
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
         client.input = "a";
         keyboard.Tab();

         assertThat(
            "user input should contain exact match",
            client.input, equals ("aa")
         );
         assertAutoCompleteListEmpty();

         client.reset();
         client.input = "aa";
         keyboard.Tab();

         assertThat(
            "user input should not have changed",
            client.input, equals ("aa")
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
   public function set input(value: String): void {
      _input = value;
   }
   public function get input(): String {
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
