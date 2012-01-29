package utils.undo
{
   public interface ICommand
   {
      function execute(): void;
      function undo(): void;
   }
}
