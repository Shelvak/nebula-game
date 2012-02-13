package models.infoscreen
{
   public class MInfoRow
   {
      [Bindable]
      public var property: String;
      [Bindable]
      public var current: String;
      [Bindable]
      public var after: String;
      [Bindable]
      public var diff: String;
      [Bindable]
      public var tooltip: String;
      
      public function MInfoRow(_property: String, _current: String, _after: String, _diff: String, _tooltip: String = '')
      {
         property = _property;
         current = _current;
         after = _after;
         diff = _diff;
         tooltip = _tooltip;
      }
   }
}