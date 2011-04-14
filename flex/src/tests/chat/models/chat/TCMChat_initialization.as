package tests.chat.models.chat
{
   import ext.hamcrest.collection.hasItems;
   import ext.hamcrest.object.equals;
   
   import models.chat.MChat;
   import models.chat.MChatChannel;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.collection.hasItem;
   import org.hamcrest.core.allOf;
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.hasProperty;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;
   import org.hamcrest.object.notNullValue;
   import org.hamcrest.text.startsWith;
   
   
   public class TCMChat_initialization extends TCBaseMChat
   {
      public function TCMChat_initialization()
      {
         super();
      };
      
      
      [Test]
      public function should_initialize_all_members() : void
      {
         chat.initialize(
            {
               "1": "mikism",
               "2": "jho",
               "3": "arturaz"
            },
            {
               "galaxy": [1, 2, 3]
            }
         );
         
         assertThat( chat.members, arrayWithSize (3) );
         assertThat( chat.members, hasItems (
            hasProperties ({"id": 1, "name": "mikism"}),
            hasProperties ({"id": 2, "name": "jho"}),
            hasProperties ({"id": 3, "name": "arturaz"})
         ));
      };
      
      
      [Test]
      public function should_initialize_all_public_channels() : void
      {
         chat.initialize({}, {"galaxy": [], "alliance": []});
         
         assertThat( chat.channels, arrayWithSize (2) );
         assertThat( chat.channels, hasItems (
            hasProperties ({"name": "galaxy"}),
            hasProperties ({"name": "alliance"})
         ));
      };
      
      
      [Test]
      public function main_public_channel_should_be_first_in_channels_list() : void
      {
         chat.initialize(
            {},
            {
               "alliance-1": [],
               "wtf": [],
               "galaxy": []
            }
         );
         
         assertThat( chat.channels, arrayWithSize (3) );
         assertThat(
            chat.channels.getItemAt(MChat.MAIN_CHANNEL_INDEX),
            equals (chat.channels.getChannel(MChat.MAIN_CHANNEL_NAME))
         );
      };
      
      
      [Test]
      public function should_add_members_to_corresponding_channels() : void
      {
         chat.initialize(
            {
               "1": "mikism",
               "2": "jho",
               "3": "arturaz"
            },
            {
               "galaxy": [1, 2, 3],
               "alliance-1": [2, 3]
            }
         );
         
         assertThat( chat.members, arrayWithSize (3) );
         
         assertThat( chat.channels, arrayWithSize (2) );
         assertThat( chat.channels, hasItem (hasProperties ({
               "name": "galaxy",
               "members": allOf (
                  arrayWithSize (3),
                  hasItems (
                     hasProperty ("id", 1),
                     hasProperty ("id", 2),
                     hasProperty ("id", 3)
                  )
               )
         })));
         assertThat( chat.channels, hasItem ( hasProperties({
            "name": "alliance-1",
            "members": allOf (
               arrayWithSize (2),
               hasItems (
                  hasProperty ("id", 2),
                  hasProperty ("id", 3)
               )
            )
         })));
      };
      
      
      [Test]
      public function should_select_first_channel_in_the_list() : void
      {
         chat.initialize(
            {
               "1": "mikism",
               "2": "jho",
               "3": "arturaz"
            },
            {
               "galaxy": [1, 2, 3],
               "alliance-1": [2, 3]
            }
         );
         
         assertThat( chat.selectedChannel, equals (chat.channels.getItemAt(0)) );
      };
      
      
      [Test]
      public function should_not_have_private_channel() : void
      {
         chat.initialize({}, {"galaxy": []});
         
         assertThat( chat.privateChannelOpen, isFalse() );
      };
      
      
      [Test]
      public function should_not_have_alliance_channel_when_initialized_without_it() : void
      {
         chat.initialize({}, {"galaxy": []});
         
         assertThat( chat.allianceChannelOpen, isFalse() );
      };
      
      
      [Test]
      public function should_have_alliance_channel_when_initialized_with_it() : void
      {
         chat.initialize({}, {"galaxy": [], "alliance-1": []});
         
         assertThat( chat.allianceChannelOpen, isTrue() );
      };
      
      
      [Test]
      public function if_present_alliance_channel_should_be_second_in_the_list() : void
      {
         chat.initialize({}, {"alliance-1": [], "a-team":[], "galaxy": []});
         
         assertThat(
            MChatChannel(chat.channels.getItemAt(MChat.ALLIANCE_CHANNEL_INDEX)).name,
            startsWith (MChat.ALLIANCE_CHANNEL_PREFIX)
         );
      };
   }
}