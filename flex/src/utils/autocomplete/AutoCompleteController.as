package utils.autocomplete
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;

   import mx.collections.ArrayCollection;
   import mx.collections.IList;

   import utils.Objects;
   import utils.datastructures.iterators.IIterator;
   import utils.datastructures.iterators.IIteratorFactory;


   public class AutoCompleteController extends EventDispatcher
   {
      private static const LAST_WORD_REGEXP: RegExp = /\S+$/;

      private const NULL_CLIENT: IAutoCompleteClient = new NullClient();
      private const NULL_DICTIONARY: IList = new ArrayCollection();
      private var _keyboard: IEventDispatcher;

      public function AutoCompleteController(keyboardEventsDispatcher: IEventDispatcher) {
         _keyboard = Objects.paramNotNull(
            "keyboardEventsDispatcher", keyboardEventsDispatcher
         );
         _keyboard.addEventListener(
            KeyboardEvent.KEY_UP, keyboard_keyUpHandler, false, 0, true
         );
      }

      private var _client: IAutoCompleteClient = NULL_CLIENT;
      public function set client(value: IAutoCompleteClient): void {
         _client = value == null ? NULL_CLIENT : value;
      }

      private var _dictionary: IList = NULL_DICTIONARY;
      public function set dictionary(value: IList): void {
         _dictionary = value == null ? NULL_DICTIONARY : value;
      }
      public function get dictionary(): IList {
         return _dictionary;
      }

      private function keyboard_keyUpHandler(event: KeyboardEvent): void {
         if (event.keyCode == Keyboard.TAB) {
            runAutoComplete();
         }
      }

      private function runAutoComplete(): void {
         const lastWord: String = getLastWord();
         const choices: Array = getAutoCompleteList(lastWord);
         if (choices.length == 0) {
            resetClientAutoCompleteList();
         }
         else {
            const commonPart: String = extractCommonPart(lastWord, choices);
            _client.userInput = _client.userInput.replace(LAST_WORD_REGEXP, commonPart);
            if (choices.length == 1) {
               resetClientAutoCompleteList();
            }
            else {
               // exact match *after* auto complete
               if (choices[0] == commonPart && lastWord != commonPart) {
                  resetClientAutoCompleteList();
               }
               // exact match *before* auto complete or partial match
               else {
                  _client.setAutoCompleteList(commonPart, choices);
               }
            }
         }
      }

      private function resetClientAutoCompleteList(): void {
         _client.setAutoCompleteList("", new Array());
      }

      private function extractCommonPart(commonPart: String,
                                         words: Array): String {
         var firstWord: String = words[0];
         var charsCommon: int = commonPart.length;
         const charsTotal: int = firstWord.length;
         while (true) {
            charsCommon++;
            if (charsCommon > charsTotal) {
               commonPart = firstWord;
               break;
            }
            const newCommonPart: String = firstWord.substr(0, charsCommon);
            const isCommon: Boolean = words.every(
               function (word: String, index: int, array: Array): Boolean {
                  return word.indexOf(newCommonPart) == 0;
               }
            );
            if (!isCommon) {
               break;
            }
            commonPart = newCommonPart;
         }
         return commonPart;
      }

      private function getAutoCompleteList(commonPart: String): Array {
         const choices: Array = new Array();
         if (commonPart.length == 0) {
            return choices;
         }
         const iterator: IIterator = IIteratorFactory.getIterator(dictionary);
         while (iterator.hasNext) {
            const value: String =
                     IAutoCompleteValue(iterator.next()).autoCompleteValue;
            if (value.indexOf(commonPart) == 0) {
               choices.push(value);
            }
         }
         choices.sort();
         return choices;
      }

      private function getLastWord(): String {
         const idx: int = _client.userInput.search(LAST_WORD_REGEXP);
         if (idx == -1) {
            return "";
         }
         return _client.userInput.substring(idx);
      }
   }
}


import utils.autocomplete.IAutoCompleteClient;


class NullClient implements IAutoCompleteClient
{
   public function setAutoCompleteList(commonPart: String, list: Array): void {
   }

   public function set userInput(value: String): void {
   }

   public function get userInput(): String {
      return "";
   }
}