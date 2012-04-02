import interfaces.IUpdatable;


private function updateItem(updatable: IUpdatable): void {
   MasterUpdateTrigger.updateItem(updatable);
}

private function updateList(list: *): void {
   MasterUpdateTrigger.updateList(list);
}

private function resetChangeFlagsOf(updatable: IUpdatable): void {
   MasterUpdateTrigger.resetChangeFlagsOf(updatable);
}

private function resetChangeFlagsOfList(list: *): void {
   MasterUpdateTrigger.resetChangeFlagsOfList(list);
}