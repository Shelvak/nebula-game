package utils
{
   import flash.events.IEventDispatcher;

   import interfaces.ICleanable;


   public final class EventBridge implements ICleanable
   {
      private const _bridges: Array = new Array();
      private var _source: IEventDispatcher;
      private var _target: IEventDispatcher;

      public function EventBridge(source: IEventDispatcher, target: IEventDispatcher) {
         this._source = source;
         this._target = target;
      }

      public function onEvents(sourceEvents: Array): SingleBridge {
         return new SingleBridge(this, _source, _target, sourceEvents);
      }

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

   public function dispatchSimple(targetEventClass: Class, targetEvents: Array): EventBridge {
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