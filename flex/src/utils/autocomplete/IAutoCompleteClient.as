package utils.autocomplete
{
   public interface IAutoCompleteClient
   {
      function setAutoCompleteList(commonPart:String, list: Array): void;

      function set input(value: String): void;
      function get input(): String;
   }
}
