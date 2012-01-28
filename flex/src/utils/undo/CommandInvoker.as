package utils.undo
{
   import utils.Objects;


   public class CommandInvoker
   {
      private const NULL_COMMAND: ICommand = new NullCommand();

      private var _commands: Array;

      private function get minIndex(): int {
         return 0;
      }

      private function get maxIndex(): int {
         return _commands.length - 1;
      }

      private function indexValid(index: int): Boolean {
         return minIndex <= index && index <= maxIndex;
      }

      private var _undoIndex: int;
      private var _redoIndex: int;

      public function CommandInvoker() {
         clear();
      }

      public function clear(): void {
         _commands = new Array();
         _undoIndex = minIndex - 1;
         _redoIndex = maxIndex + 1;
      }

      public function addCommand(command: ICommand): void {
         Objects.paramNotNull("command", command);
         if (indexValid(_undoIndex + 1)) {
            _commands.splice(_undoIndex + 1);
         }
         _commands.push(command);
         _undoIndex++;
         _redoIndex = _undoIndex + 1;
      }

      private function getCommand(index: int): ICommand {
         return _commands[index];
      }

      public function undo(): void {
         if (indexValid(_undoIndex)) {
            getCommand(_undoIndex).undo();
            _redoIndex = _undoIndex;
            _undoIndex--;
         }
      }

      public function redo(): void {
         if (indexValid(_redoIndex)) {
            getCommand(_redoIndex).execute();
            _undoIndex = _redoIndex;
            _redoIndex++;
         }
      }
   }
}


import utils.undo.ICommand;


class NullCommand implements ICommand
{
   public function execute(): void {}
   public function undo(): void {}
}