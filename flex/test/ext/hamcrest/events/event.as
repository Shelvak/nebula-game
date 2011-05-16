package ext.hamcrest.events
{
   /**
    * Constructs an instance of <code>ExpectedEvent</code>. Should be use with
    * <code>DispatchesMatcherBuilder.toDispatch()</code> method.
    * 
    * @param eventType type of event that is expected to be dispatched.
    *                  <b>Not null. Not empty string.</b>
    * @param eventMatcher optional matcher to matche the dispached event.
    *                     <b>Class, Event or Matcher.</b>
    * 
    * <pre>
    * assertThat(
    * &nbsp;&nbsp;&nbsp; function():void{...},
    * &nbsp;&nbsp;&nbsp; causesTarget (target) .toDispatch (
    * &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; event ("eventOne"),
    * &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; event ("eventTwo", hasProperty ("property", "value")),
    * &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; ...
    * );
    * </pre>
    * 
    * @see DispatchesMatcherBuilder
    */
   public function event(eventType:String, eventMatcher:* = null) : ExpectedEvent
   {
      return new ExpectedEvent(eventType, eventMatcher);  }
}