package tests.chat.models
{
   import ext.hamcrest.object.equals;
   
   import models.chat.MChatMember;
   import models.chat.MChatMembersList;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.collection.hasItem;
   import org.hamcrest.core.throws;
   
   
   public class TCMChatMembersList
   {
      private var member:MChatMember;
      private var list:MChatMembersList;
      
      
      [Before]
      public function setUp() : void
      {
         member = new MChatMember();
         member.id = 1;
         member.name = "mikism";
         list = new MChatMembersList();
         list.addMember(member);
      };
      
      
      [After]
      public function tearDown() : void
      {
         member = null;
         list = null;
      }
      
      
      [Test]
      public function should_add_chat_member_to_list() : void
      {
         assertThat( list, arrayWithSize (1) );
         assertThat( list, hasItem (member) );
         assertThat( list.getMember(member.id), equals (member) );
      };
      
      
      [Test]
      public function should_throw_error_if_member_is_already_in_the_channel() : void
      {
         var clone:MChatMember = cloneMember(member);
         
         assertThat( function():void{ list.addMember(clone) }, throws (ArgumentError) );
      };
      
      
      [Test]
      public function should_remove_chat_member_from_list() : void
      {
         list.removeMember(cloneMember(member));
         
         assertThat( list, arrayWithSize (0) );
      };
      
      
      [Test]
      public function should_throw_error_if_member_to_remove_not_found() : void
      {
         var another:MChatMember = new MChatMember();
         another.id = 2;
         another.name = "jho";
         
         assertThat( function():void{ list.removeMember(another) }, throws (ArgumentError) );
      };
      
      
      private function cloneMember(member:MChatMember) : MChatMember
      {
         var clone:MChatMember = new MChatMember();
         clone.id = member.id;
         clone.name = member.name;
         return clone;
      }
   }
}