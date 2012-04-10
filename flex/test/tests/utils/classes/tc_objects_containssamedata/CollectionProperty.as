package tests.utils.classes.tc_objects_containssamedata
{
   public class CollectionProperty
   {
      public function CollectionProperty(lotteryName:String) {
         this.lotteryName = lotteryName;
      }

      [Optional] public var lotteryName:String;
      [Required] public var numbers:Vector.<int> = new Vector.<int>();
   }
}
