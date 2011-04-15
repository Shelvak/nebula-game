package tests.chat.actions
{
   [Suite]
   [RunWith("org.flexunit.runners.Suite")]
   public class TSChatActions
   {
      public var tcIndexAction:TCIndexAction;
      public var tcChannelJoinAction:TCChannelJoinAction;
      public var tcChannelLeaveAction:TCChannelLeaveAction;
      public var tcMessagePublicAction:TCMessagePublicAction;
      public var tcMessagePrivateAction:TCMessagePrivateAction;
   }
}