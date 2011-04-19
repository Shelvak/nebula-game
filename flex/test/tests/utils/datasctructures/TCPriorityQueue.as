package tests.utils.datasctructures
{
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.hasItem;
   import org.hamcrest.collection.hasItems;
   import org.hamcrest.core.not;
   import org.hamcrest.object.equalTo;
   import org.hamcrest.object.nullValue;
   
   import utils.datastructures.PriorityQueue;

   public class TCPriorityQueue
   {
     private var queue:PriorityQueue;
      
      
      [Before]
      public function setUp() : void
      {
         queue = new PriorityQueue();
      };
      
      
      [After]
      public function tearDown() : void
      {
         queue = null;
      };
      
      
      [Test]
      /**
       * Should remove only one instance from the queue.
       */
      public function romoveOneItem() : void
      {
         var itemOne:Object = new Object();
         var itemTwo:Object = new Object();
         queue.addItem(itemOne, 100);
         queue.addItem(itemOne, 200);
         queue.addItem(itemTwo, 300);
         queue.addItem(itemTwo, 400);
         queue.removeOneItem(itemOne, 100);
         assertThat( queue.items, hasItems (itemOne, itemTwo) );
         queue.removeOneItem(itemOne, 200);
         assertThat( queue.items, hasItem (itemTwo) );
         assertThat( queue.items, not (hasItem (itemOne) ) );
         queue.removeOneItem(itemTwo, 400);
         assertThat( queue.items, hasItem (itemTwo) );
         assertThat( queue.items, not (hasItem (itemOne) ) );
         queue.removeOneItem(itemTwo, 300);
         assertThat( queue.items, not (hasItem (itemOne) ) );
         assertThat( queue.items, not (hasItem (itemTwo) ) );
      };
      
      
      [Test]
      /**
       * Should return false if item could not be found.
       */
      public function hasItem_nonExisting() : void
      {
         var itemOne:Object = new Object();
         var itemTwo:Object = new Object();
         queue.addItem(itemOne, 10);
         queue.addItem(itemTwo, 20);
         assertThat( queue.hasItem(new Object(), 10), equalTo (false) );
         assertThat( queue.hasItem(itemOne, 20), equalTo (false) );
         assertThat( queue.hasItem(itemTwo, 10), equalTo (false) );
      };
      
      
      [Test]
      /**
       * Should retur true for items that are in the queue.
       */
      public function hasItem_existing() : void
      {
         var itemOne:Object = new Object();
         var itemTwo:Object = new Object();
         queue.addItem(itemOne, 10);
         queue.addItem(itemTwo, 20);
         assertThat( queue.hasItem(itemOne, 10), equalTo (true) );
         assertThat( queue.hasItem(itemTwo, 20), equalTo (true) );
      };
      
      
      [Test]
      /**
       * Should return false when there would be no similar item next to the given item.
       */
      public function similarItemNextTo_noSimilarItem() : void
      {
         var itemOne:Object = new Object();
         var itemTwo:Object = new Object();
         var itemThree:Object = new Object();
         queue.addItem(itemOne, 100);
         queue.addItem(itemTwo, 200);
         queue.addItem(itemThree, 300);
         assertThat( queue.similarItemNextTo(itemOne, 250), equalTo (false) );
         assertThat( queue.similarItemNextTo(itemOne, 350), equalTo (false) );
         assertThat( queue.similarItemNextTo(itemTwo, 50), equalTo (false) );
         assertThat( queue.similarItemNextTo(itemTwo, 350), equalTo (false) );
      };
      
      
      [Test]
      /**
       * Should return true when there would be similar item next to the given item.
       */
      public function similarItemNextTo_similarItemExists() : void
      {
         var itemOne:Object = new Object();
         var itemTwo:Object = new Object();
         var itemThree:Object = new Object();
         queue.addItem(itemOne, 100);
         queue.addItem(itemTwo, 200);
         queue.addItem(itemThree, 300);
         assertThat( queue.similarItemNextTo(itemOne, 50), equalTo (true) );
         assertThat( queue.similarItemNextTo(itemOne, 100), equalTo (true) );
         assertThat( queue.similarItemNextTo(itemTwo, 150), equalTo (true) );
         assertThat( queue.similarItemNextTo(itemTwo, 250), equalTo (true) );
      }
   }
}