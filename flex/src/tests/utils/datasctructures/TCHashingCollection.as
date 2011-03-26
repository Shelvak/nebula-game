package tests.utils.datasctructures
{
   import ext.hamcrest.collection.hasItems;
   import ext.hamcrest.object.equals;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.object.nullValue;
   
   import utils.datastructures.HashFunction;
   import utils.datastructures.HashingCollection;
   
   
   public class TCHashingCollection
   {
      private static const HFN_ID:String = "hfn_id";
      private static const HFN_NAME:String = "hfn_name";
      private static const HFN_ID_NAME:String = "hfn_id_name";
      
      
      private var hashFunctions:Vector.<HashFunction>;
      
      
      public function TCHashingCollection()
      {
         hashFunctions = Vector.<HashFunction>([
            new HashFunction(
               HFN_ID,
               function(item:CollectionItem) : String { return item.id.toString() }
            ),
            new HashFunction(
               HFN_NAME,
               function(item:CollectionItem) : String { return item.name }
            ),
            new HashFunction(
               HFN_ID_NAME,
               function(item:CollectionItem) : String { return item.id + "," + item.name }
            )
         ]);
      };
      
      
      private var collection:HashingCollection;
      
      
      [Before]
      public function setUp() : void
      {
         
      };
      
      
      [After]
      public function tearDown() : void
      {
         
      };
      
      
      [Test]
      public function should_hash_all_items_in_the_source_array_when_created() : void
      {
         var item:CollectionItem;
         // preconditions
         var item1:CollectionItem = new CollectionItem(1, "one");
         var item2:CollectionItem = new CollectionItem(2, "two");
         collection = new HashingCollection(hashFunctions, new CollectionItem(), [item1, item2]);
         
         // test
         
         // check that items are in the collection
         assertThat( collection, arrayWithSize (2) );
         assertThat( collection, hasItems (item1, item2) );
         
         // get a ref to sample item
         item = collection.sampleItem;
         
         // HFN_ID
         item.id = item1.id;
         assertThat( collection.getItem(HFN_ID, item), equals (item1) );
         item.id = item2.id;
         assertThat( collection.getItem(HFN_ID, item), equals (item2) );
         item.id = 100;
         assertThat( collection.getItem(HFN_ID, item), nullValue() );
         
         // HFN_NAME
         item.name = "one";
         assertThat( collection.getItem(HFN_NAME, item), equals (item1) );
         item.name = "two";
         assertThat( collection.getItem(HFN_NAME, item), equals (item2) );
         item.name = "hundred";
         assertThat( collection.getItem(HFN_NAME, item), nullValue() );
         
         // HFN_ID_NAME
         item.id = item1.id;
         item.name = item1.name;
         assertThat( collection.getItem(HFN_ID_NAME, item), equals (item1) );
         item.id = item2.id;
         item.name = item2.name;
         assertThat( collection.getItem(HFN_ID_NAME, item), equals (item2) );
         item.id = item1.id;
         item.name = "hundred";
         assertThat( collection.getItem(HFN_ID_NAME, item), nullValue() );
         item.id = 100;
         item.name = item1.name;
         assertThat( collection.getItem(HFN_ID_NAME, item), nullValue() );
         item.id = 100;
         item.name = "hundred";
         assertThat( collection.getItem(HFN_ID_NAME, item), nullValue() );
      };
   }
}


class CollectionItem
{
   public function CollectionItem(id:int = 0, name:String = "")
   {
      this.id = id;
      this.name = name;
   }
   
   
   public var id:int;
   public var name:String;
   
   
   public function toString() : String
   {
      return "[class: " + CollectionItem + ", id: " + id + ", name: \"" + name + "\"]";
   }
}