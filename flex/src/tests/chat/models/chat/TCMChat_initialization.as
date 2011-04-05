package tests.chat.models.chat
{
   import ext.hamcrest.collection.hasItems;
   import ext.hamcrest.object.equals;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.collection.hasItem;
   import org.hamcrest.core.allOf;
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.hasProperty;
   
   
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
            {"1": "mikism",
             "2": "jho",
             "3": "arturaz"},
            {"galaxy": [1, 2, 3]}
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
      public function should_add_members_to_corresponding_channels() : void
      {
         chat.initialize(
            {"1": "mikism",
             "2": "jho",
             "3": "arturaz"},
            {"galaxy": [1, 2, 3],
             "alliance": [2, 3]}
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
            "name": "alliance",
            "members": allOf (
               arrayWithSize (2),
               hasItems (
                  hasProperty ("id", 2),
                  hasProperty ("id", 3)
               )
            )
         })));
      };
   }
}