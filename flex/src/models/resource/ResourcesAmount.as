package models.resource
{
   public class ResourcesAmount
   {
      public var metal:Number;
      public var energy:Number;
      public var zetium:Number;
      public function ResourcesAmount(metal:Number, energy:Number, zetium:Number)
      {
         this.metal  = metal;
         this.energy = energy;
         this.zetium = zetium;
      }
   }
}