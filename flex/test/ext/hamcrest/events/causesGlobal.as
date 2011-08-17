package ext.hamcrest.events
{
   /**
    * Matches if global events are dispatched and optional event <code>Matcher</code>s also match.
    */
   public function causesGlobal(... events) : DispatchesGlobalEventsMatcher {
      var expectedEvents:Vector.<ExpectedEvent> = new Vector.<ExpectedEvent>();
      for each (var event:ExpectedEvent in events) {
         expectedEvents.push(event);
      }
      return new DispatchesGlobalEventsMatcher(expectedEvents);
   }
}