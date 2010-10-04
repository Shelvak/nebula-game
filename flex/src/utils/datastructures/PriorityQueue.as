/* ***** BEGIN MIT LICENSE BLOCK *****
* 
* Copyright (c) 2009 DevelopmentArc LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*
*
* ***** END MIT LICENSE BLOCK ***** */
package utils.datastructures
{
   /**
    * The PriorityQueue is a data structure utility designed to
    * store items in a stored order based upon a defined priority
    * value.  When an item is added to the queue the item is assigned
    * a priority value, 0 being the "highest" priority and unit.MAX_VALUE
    * as the "lowest" priority.
    * 
    * <p>Items that are added to the queue are sorted from highest 
    * priority to lowest and when the next() method is called the
    * highest priority item in the queue is returned.  Items with
    * the same priority are returned in the order they where added
    * to the queue (First in First out).</p>
    * 
    * @author James Polanco
    * 
    */
   public class PriorityQueue
   {
      /* PRIVATE PROPERTIES */
      private var _table:Array;
      
      public function PriorityQueue()
      {
         _table = new Array();
      }
      
      /**
       * Adds an item to a queue based on the priority value.
       * The queue always starts at the zero postion when next()
       * is called so the prioirty value determines where the item
       * should reside in the queue.  The lowest priority is 0, which
       * overrides all other priorities.  By default the priority is
       * set to 5.
       * 
       * <p>Example: An item of priority 3 is added to the queue.  The
       * addItem() method first checks to see if there are any items of
       * a higher.  If there are items of higher the new item is put behind
       * the existing items.</p>
       * 
       * @param item The item to add to the queue.
       * @param priority The prioirty to assign the item.
       * 
       */
      public function addItem(item:*, priority:uint = 5):void
      {
         var itemWrapper:PriorityWrapper = new PriorityWrapper(item, priority);
         var position:int = getPosition(priority);
         if (position == 0)
         {
            _table.unshift(itemWrapper);
         }
         else if (position == length)
         {
            _table.push(itemWrapper);
         }
         else
         {
            _table.splice(position, 0, itemWrapper);
         }
      }
      
      /**
       * Removes an item from the queue.  Items can have multiple
       * instances stored inside a queue so if if you only wish to
       * remove a specific number of instances from the queue but
       * leave the rest you can provide a value in the numberOfInstances
       * argument.  By default all instance of the requested item are
       * removed.
       *  
       * @param item The item to remove from the queue.
       * @param numberOfInstances The number of instances to look for.
       * 
       * @return Boolean True if one or more instances were found, otherwise False
       * 
       */
      public function removeItem(item:*, numberOfInstances:int = int.MAX_VALUE, priority:int = -1):Boolean
      {
         // verify that we are removing at least one item (negatives not allowed)
         if(numberOfInstances < 1) return false;
         
         // loop over and pull out the instances
         var clone:Array = new Array();
         var count:int = 0;
         var len:int = _table.length;
         var itemFound:Boolean;			
         for(var i:uint = 0; i < len; i++)
         {
            var inst:PriorityWrapper = PriorityWrapper(_table[i]);
            
            // match the priority then the item
            if(priority > -1 && inst.priority == priority && inst.item == item) {
               if(++count > numberOfInstances) {
                  // push the rest and end
                  clone = clone.concat(_table.slice(i));
                  itemFound = true;
                  break;
               }
               itemFound = true;
            } else if(priority < 0 && PriorityWrapper(_table[i]).item == item) {
               // we have no pririty requirements
               if(++count > numberOfInstances) {
                  // push the rest and end
                  clone = clone.concat(_table.slice(i));
                  itemFound = true;
                  break;
               }
               itemFound = true;
            } else {
               clone.push(_table[i]);
            }
         }
         
         // reset the table
         _table = clone;
         
         return itemFound;
      }
      
      /**
       * Removes an item at the specified position.  If the position
       * is invalid then a false value is returned stating that the item
       * was not removed at the provided position.  If the position is valid
       * the method returns a true for success.
       *  
       * @param position The position in the PriorityQueue to remove.
       * @return True for successful removal, false for an invalid position.
       * 
       */
      public function removeAt(position:uint):Boolean
      {
         // verify that it is a valid position
         if(position > _table.length || position < 0) return false;
         _table.splice(position, 1);
         return true;
      }
      
      /**
       * Clears all items from the queue. 
       * 
       */
      public function removeAllItems():void
      {
         _table = new Array();
      }
      
      /**
       * Used to access the next item in the queue base
       * on the priority.  If no items are in the queue
       * then null is returned.  It is recommened that you
       * check hasItems before calling next to prevent returning
       * a null value.
       *  
       * @return The next item in the queue based in the highest priority.
       * 
       */
      public function next():*
      {
         if(!hasItems) return null;
         return PriorityWrapper(_table.shift()).item;
      }
      
      /**
       * Peek returns the first item in the queue without removing
       * the item from the queue.  This enables you to peek at the
       * item without adjust the order in the queue.
       *  
       * @return First item in the queue, null if no items in the queue.
       * 
       */
      public function peek():*
      {
         if(!hasItems) return null;
         return PriorityWrapper(_table[0]).item;
      }
      
      /**
       * Used to determine if items are currently stored inside the
       * PriorityQueue.
       *  
       * @return True if items are in the PriorityQueue, false if the queue is empty.
       * 
       */
      public function get hasItems():Boolean
      {
         return (_table.length > 0) ? true : false;
      }
      
      /**
       * Returns a cloned copy of the items table in the queue.
       *  
       * @return An array of the items in the current order they are within the queue.
       * 
       */
      public function get items():Array
      {
         var output:Array = new Array();
         for each(var item:PriorityWrapper in _table)
         {
            output.push(item.item);
         }
         return output;
      }
      
      /**
       * The number of items currently in the PriorityQueue.
       *  
       * @return The length of the PriorityQueue.
       * 
       */
      public function get length():int
      {
         return _table.length;
      }
      
      
      /* ######################################################### */
      /* ### implemented by Mykolas Mickus (mikopas@gmail.com) ### */
      /* ######################################################### */
      
      
      /**
       * Returns element with lowest priority in the queue (last element) without removing
       * it from the queue.
       */
      public function bottom():*
      {
         if(!hasItems)
         {
            return null;
         }
         return PriorityWrapper(_table[length - 1]).item;
      }
      
      
      /**
       * Removes item from the queue if one is there. This is equivalent to:
       * <pre>removeItem(item, 1, priority)</pre>.
       * 
       * @param item item to remove
       * @param priority priority of the item
       * 
       * @return <code>true</code> if an item has been removed or <code>false</code> otherwise
       * 
       * @see #removeItem()
       */
      public function removeOneItem(item:*, priority:uint) : Boolean
      {
         return removeItem(item, 1, priority);
      }
      
      
      /**
       * Lets you find out if the given item with given priority is in this queue.
       * 
       * @param item an item to look for
       * @param priority priority of the item beeing looked up
       * 
       * @return <code>true</code> if this queue has got this item or <code>false</code> otherwise.
       */
      public function hasItem(item:*, priority:uint) : Boolean
      {
         if (length < 1)
         {
            return false;
         }
         for each (var itemWrapper:PriorityWrapper in _table)
         {
            if (itemWrapper.item === item &&
                itemWrapper.priority == priority)
            {
               return true;
            }
         }
         return false;
      }
      
      
      /**
       * Lets you find out if given item with given priority would end up beeing next to similar
       * item (same instance and priority is not important) in the queue.
       * 
       * @param item an item you want to query queue for
       * @param priority priority of this item
       * 
       * @return <code>true</code> if given item would be next to similar item or <code>false</code>
       * otherwise
       */
      public function similarItemNextTo(item:*, priority:uint) : Boolean
      {
         var position:int = getPosition(priority);
         
         // Check two items the item would be between
         if (position != 0 && PriorityWrapper(_table[position - 1]).item === item )
         {
            return true;
         }
         if (position != length && PriorityWrapper(_table[position]).item === item)
         {
            return true;
         }
         
         return false;
      }
      
      
      /**
       * Finds the position in the queue where an element with given priority should be inserted.
       * 
       * @param priority
       * @return position of an item to be added with the given priority (range: [0; length])
       */
      public function getPosition(priority:uint) : int
      {
         if(length < 1)
         {
            return 0;
         }
         else
         {
            for(var i:uint = 0; i < length; i++)
            {
               var itemWrapper:PriorityWrapper = PriorityWrapper(_table[i]);
               if(itemWrapper.priority >= priority)
               {
                  return (i - 1) < 0 ? 0 : i;
               }
            }
            return length;
         }
      }
      
      
      /**
       * Returns an item in the specified position of the queue.
       * 
       * @param position position of an item
       * 
       * @return an item in the given position of the queue
       */
      public function getItemAt(position:int) : *
      {
         return PriorityWrapper(_table[position]).item;
      }
   }
}


class PriorityWrapper
{
   public var item:*;
   public var priority:uint;
   
   public function PriorityWrapper(data:*, value:uint)
   {
      item = data;
      priority = value;
   }
}