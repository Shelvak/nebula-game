package tests.ext.flex.mx.collections.tests
{
   import ext.flex.mx.collections.ArrayCollectionSlave;
   import ext.hamcrest.collection.array;
   import ext.hamcrest.object.equals;
   
   import flash.errors.IllegalOperationError;
   
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.emptyArray;
   import org.hamcrest.collection.hasItem;
   import org.hamcrest.collection.hasItems;
   import org.hamcrest.core.not;
   import org.hamcrest.core.throws;

   public class TCArrayCollectionSlave
   {
      private var _master:ArrayCollection;
      private var _slave:ArrayCollectionSlave;
      
      
      [Before]
      public function beforeTest() : void
      {
         _master = new ArrayCollection();
      }
      
      
      [After]
      public function afterTest() : void
      {
         _slave.cleanup();
      }
      
      
      [Test]
      /**
       * If slave is modifiable, modifying methods should not cause any errors.
       */
      public function modifyingMethods_modifiableSlave() : void
      {
         modifiableSlave();
         assertThat( _slave.modifiable, equals (true) );
         // All calls below should complete without any errors
         _slave.addAll(new ArrayCollection([0, 1]));
         _slave.addItem(2);
         _slave.removeItem(2);
         _slave.removeAll();
         // These methods should still cause error since slave does not maintain order of items
         assertThat( function():void{ _slave.removeItemAt(1) }, throws (IllegalOperationError) );
         assertThat( function():void{ _slave.addAllAt(new ArrayCollection([0, 1]), 0) }, throws (IllegalOperationError) );
         assertThat( function():void{ _slave.addItemAt(0, 0) }, throws (IllegalOperationError) );
         assertThat( function():void{ _slave.addItem(0); _slave.removeItemAt(0) }, throws (IllegalOperationError) ); 
      };
      
      
      [Test]
      /**
       * If slave is unmodifiable, calling modifying methods should cause IllegalOperationError.
       */
      public function modifyingMethods_unmodifiableSlave() : void
      {
         unmodifiableSlave();
         assertThat( _slave.modifiable, equals (false) );
         // All calls below should cause error
         assertThat( function():void{ _slave.addAll(new ArrayCollection([1, 2])) }, throws (IllegalOperationError) );
         assertThat( function():void{ _slave.addAllAt(new ArrayCollection([3, 4]), 2) }, throws (IllegalOperationError) );
         assertThat( function():void{ _slave.addItem(5) }, throws (IllegalOperationError) );
         assertThat( function():void{ _slave.addItemAt(6, 5) }, throws (IllegalOperationError) );
         assertThat( function():void{ _slave.removeItemAt(5) }, throws (IllegalOperationError) );
         assertThat( function():void{ _slave.removeItem(5) }, throws (IllegalOperationError) );
         assertThat( function():void{ _slave.removeAll() }, throws (IllegalOperationError) );
      };
      
      
      [Test]
      /**
       * When slave is created, it should contain all elements as the master in the same order.
       */
      public function createSlave() : void
      {
         _master.addAll(new ArrayCollection(["one", "two", "three"]));
         assertBothInOrder();
      };
      
      
      [Test]
      /**
       * Slave must respect filter applied to master: when slave is created it should only contain
       * items in master with filter applied. Slave should notice if master gets its filter changed
       * or remomoved and contain only those items in master view.
       */
      public function masterWithFilter() : void
      {
         _master.addAll(new ArrayCollection(["one", "two", "three"]));
         
         // slave, when created, should only contain elements in master
         _master.filterFunction = function(item:String) : Boolean
         {
            return item == "one" || item == "two";
         };
         _master.refresh();
         assertBothInOrder();
         
         // slave should notice changes in master when filter function is changed
         modifiableSlave();
         assertSlaveInOrder();
         _master.filterFunction = function(item:String) : Boolean
         {
            return item == "one";
         };
         _master.refresh();
         assertSlaveInOrder();
         _master.filterFunction = null;
         _master.refresh();
         assertSlaveInOrder();
      };
      
      
      [Test]
      /**
       * Slave should contain all elements as in master but order is irrelevant.
       */
      public function masterWithSort() : void
      {
         function assertSlave() : void
         {
            assertThat( _slave, hasItems ("one", "two", "three") );
         };
         _master.addAll(new ArrayCollection(["one", "two", "three"]));
         modifiableSlave();
         
         _master.sort = new Sort();
         _master.sort.compareFunction = function(a:String, b:String, fields:Array = null) : int
         {
            var result:int = a.localeCompare(b);
            if (result < 0) return -1;
            else if (result > 0) return 1;
            else return 0;
         };
         _master.refresh();
         assertSlave();
         
         _master.sort.compareFunction = function(a:String, b:String, fields:Array = null) : int
         {
            return 0;
         };
         _master.refresh();
         assertSlave();
         
         _master.sort = null
         _master.refresh();
         assertSlave();
      };
      
      
      [Test]
      /**
       * Slave should notice changes in master (element added, removed) and update itself. Slave
       * should respects its filters and sort.
       */
      public function masterModification() : void
      {
         _master.addAll(new ArrayCollection([1, 2, 3]));
         unmodifiableSlave();
         
         _master.removeItemAt(1);
         assertThat( _slave, hasItems (1, 3) );
         assertThat( _slave, not(hasItem (2)) );
         
         _slave.sort = new Sort();
         _slave.sort.compareFunction = function(a:int, b:int, fields:Array = null) : int
         {
            return a < b ? 1 : (a > b ? -1 : 0);
         };
         _slave.refresh();
         
         _master.addItem(4);
         assertThat( _slave, array (4, 3, 1) );
         
         _master.addItemAt(2, 1);
         assertThat( _slave, array (4, 3, 2, 1) );
         
         _slave.filterFunction = function(item:int) : Boolean
         {
            return item > 2;
         };
         _slave.refresh();
         
         _master.setItemAt(20, 2);
         assertThat( _slave, array (20, 4) );
         
         _master.addAll(new ArrayCollection([5, 6]));
         assertThat( _slave, array (20, 6, 5, 4) );
         
         _master.removeAll();
         assertThat( _slave.isEmpty, equals (true) );
         _slave.sort = null;
         _slave.filterFunction = null;
         assertThat( _slave.isEmpty, equals (true) );
      };
      
      
      [Test]
      /**
       * When slave is modified, it should modify master accordingly.
       */
      public function slaveModification() : void
      {
         modifiableSlave();
         
         _slave.addAll(new ArrayCollection([1, 2, 3]));
         assertThat( _master, hasItems (1, 2, 3) );
         assertThat( _slave, hasItems (1, 2, 3) );
         
         _slave.addItem(4);
         assertThat( _master, hasItems (1, 2, 3, 4) );
         assertThat( _slave, hasItems (1, 2, 3, 4) );
         
         _slave.removeItem(1);
         assertThat( _master, hasItems (2, 3, 4) );
         assertThat( _slave, hasItems (2, 3, 4) );
         
         _slave.filterFunction = function(item:int) : Boolean
         {
            return item == 4;
         };
         _slave.refresh();
         _slave.removeAll();
         assertThat( _master, hasItems (2, 3) );
         assertThat( _slave, emptyArray() );
         
         _slave.filterFunction = null;
         _slave.refresh();
         assertThat( _master, hasItems (2, 3) );
         assertThat( _slave, hasItems (2, 3) );
         
         _slave.removeAll();
         assertThat( _master, emptyArray() );
         assertThat( _slave, emptyArray() );
      };
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function modifiableSlave() : void
      {
         if (_slave)
         {
            _slave.cleanup();
         }
         _slave = new ArrayCollectionSlave(_master);
      }
      
      
      private function unmodifiableSlave() : void
      {
         if (_slave)
         {
            _slave.cleanup();
         }
         _slave = new ArrayCollectionSlave(_master, false);
      }
      
      
      /**
       * Creates modifiable slave and checks its elements against master.</br>
       * Creates unmodifiable slave and checks its elements against master.
       */
      private function assertBothInOrder() : void
      {
         modifiableSlave();
         assertSlaveInOrder();
         unmodifiableSlave();
         assertSlaveInOrder();
      }
      
      
      private function assertSlaveInOrder() : void
      {
         assertThat( _slave, array (_master) );
      }
   }
}