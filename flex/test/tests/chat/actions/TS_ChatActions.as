package tests.chat.actions
{
   [Suite]
   [RunWith("org.flexunit.runners.Suite")]
   public class TS_ChatActions
   {
      public var tc_IndexAction:TC_IndexAction;
      public var tc_ChannelJoinAction:TC_ChannelJoinAction;
      public var tc_ChannelLeaveAction:TC_ChannelLeaveAction;
      public var tc_MessagePublicAction:TC_MessagePublicAction;
      public var tc_MessagePrivateAction:TC_MessagePrivateAction;
   }
}