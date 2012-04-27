package utils.autocomplete
{
   public interface IAutoCompleteClient
   {
      function setAutoCompleteList(commonPart:String, list: Array): void;

      function set userInput(value: String): void;
      function get userInput(): String;
   }
}
