package utils
{
   import utils.random.Rndm;

	public class ArrayUtil
	{
		public static function fromObject(obj: Object, sort: Boolean = false, returnObjectsWithKeys: Boolean = false): Array
		{
			var tempArray: Array = new Array();
			if (sort)
			{
				for (var key: String in obj)
					tempArray.push({'key': key, 'prop': obj[key]});
				tempArray.sortOn('key');
				if (returnObjectsWithKeys)
					return tempArray
				else
				{
					var newArray: Array = new Array();
					for each (var sElement: Object in tempArray)
					newArray.push(sElement.prop);
					return newArray;
				}
			}
			else
			{
				for each (var element: * in obj)
				tempArray.push(element);
				return tempArray;
			}
		}
		
      /**
       * 
       * @param array - array which will be shuffled
       * @param rand - Rndm class reference, which should be used (new is created if null is given)
       * @param startIndex
       * @param endIndex
       * @return 
       * 
       */      
		public static function shuffle(array: Array, rand: Rndm, startIndex:int = 0, endIndex:int = 0):Array{
         if (rand == null)
            rand = new Rndm();
			if(endIndex == 0) endIndex = array.length-1;
			for (var i:int = endIndex; i>startIndex; i--) {
				var randomNumber:int = rand.integer(startIndex, endIndex);
				var tmp:* = array[i];
				array[i] = array[randomNumber];
				array[randomNumber] = tmp;
			}
			return array;
		}
	}
}