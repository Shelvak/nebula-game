package utils
{
   import flash.events.IEventDispatcher;

   import interfaces.ICleanable;


   /**
    * A class that lets you simplify simple events (events without data) dispatching.
    * In particular objects of this class may be used to listen to any events on a
    * <b>source</b> object and dispatch another simple events from <b>target</b>
    * object. To create one or more such "bridges" between <b>source</b> and
    * <b>target</b> you should do the following:
    * <pre>
    *    var bridge: EventBridge = new EventBridge(source, target);
    *    bridge.onEvents(["sourceEvent1", "sourceEvent2", ...])
    *          .dispatchSimple(EventClass, ["targetEvent1", "targetEvent2", ...]);
    *    bridge.onEvents(["sourceEventX, "sourceEventY", ...).dispatchSimple(...);
    *    ...</pre>
    * As soon as you don't need the bridge (i.e. you don't need to listen to events on
    * <b>source</b> and dispatch other events form <b>target</b>) you must call
    * <code>bridge.cleanup()</code> method.
    */
   public final class EventBridge implements ICleanable
   {
      private const _bridges: Array = new Array();
      private var _source: IEventDispatcher;
      private var _target: IEventDispatcher;

      public function EventBridge(source: IEventDispatcher, target: IEventDispatcher) {
         this._source = source;
         this._target = target;
      }

      /**
       * @param sourceEvents list of events to listen to | <b>Not null. Not empty.</b>
       */
      public function onEvents(sourceEvents: Array): SingleBridge {
         Objects.paramNotNull("sourceEvents", sourceEvents);
         if (sourceEvents.length == 0) {
            throw new ArgumentError("[param sourceEvents] must have at least one event");
         }
         return new SingleBridge(this, _source, _target, sourceEvents);
      }

      /**
       * You must call this when you don't need the instance anymore to unregister all
       * event listeners from <b>source</b>.
       */
      public function cleanup(): void {
         for each (var bridge: SingleBridge in _bridges) {
            bridge.cleanup();
         }
         _bridges.splice();
      }
   }
}

import flash.events.Event;
import flash.events.IEventDispatcher;

import interfaces.ICleanable;

import utils.EventBridge;
import utils.Events;
import utils.Objects;


final class SingleBridge implements ICleanable
{
   private const _dispatchers: Array = new Array();
   private var _bridge: EventBridge;
   private var _source: IEventDispatcher;
   private var _target: IEventDispatcher;
   private var _sourceEvents: Array;

   public function SingleBridge(
      bridge: EventBridge, source: IEventDispatcher, target: IEventDispatcher, sourceEvents: Array)
   {
      this._bridge = bridge;
      this._source = source;
      this._target = target;
      this._sourceEvents = sourceEvents;
   }

   /**
    * @param targetEventClass Class of event objects to be dispatched
    *    | <b>Not null. Simple event class.</b>
    * @param targetEvents A list of events to be dispatched
    *    | <b>Not null. Not empty.</b>
    */
   public function dispatchSimple(targetEventClass: Class, targetEvents: Array): EventBridge {
      Objects.paramNotNull("targetEventClass", targetEventClass);
      Objects.paramNotNull("targetEvents", targetEvents);
      if (targetEvents.length == 0) {
         throw new ArgumentError("[param targetEvents] must have at least one event");
      }
      for each (var sourceEvent: String in _sourceEvents) {
         createDispatcher(sourceEvent, targetEventClass, targetEvents);
      }
      return _bridge;
   }

   private function createDispatcher(
      sourceEvent: String, targetEventClass: Class, targetEvents: Array): void
   {
      function dispatcher(sourceEvent: Event): void {
         for each (var targetEvent: String in targetEvents) {
            Events.dispatchSimpleEvent(_target, targetEventClass, targetEvent);
         }
      }
      _source.addEventListener(sourceEvent, dispatcher, false, 0, true);
      _dispatchers.push(new Dispatcher(sourceEvent, dispatcher));
   }

   public function cleanup(): void {
      for each (var dispatcher: Dispatcher in _dispatchers) {
         _source.removeEventListener(dispatcher.sourceEvent, dispatcher.dispatcherFunction, false);
      }
      _dispatchers.splice();
   }
}


final class Dispatcher
{
   public var sourceEvent: String;
   public var dispatcherFunction: Function;

   public function Dispatcher(sourceEvent: String, dispatcherFunction: Function) {
      this.sourceEvent = sourceEvent;
      this.dispatcherFunction = dispatcherFunction;
   }
}