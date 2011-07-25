package models.market
{
   import models.resource.ResourceType;
   
   public class OfferResourceKind
   {
      public static const metal: int = 0;
      public static const energy: int = 1;
      public static const zetium: int = 2;
      public static const creds: int = 3;
      
      public static const KINDS: Array = [
         ResourceType.METAL,
         ResourceType.ENERGY,
         ResourceType.ZETIUM,
         ResourceType.CREDS
      ];
   }
}