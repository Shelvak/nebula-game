package components.map.space
{
   import models.solarsystem.MSSMetadataOfOwner;
   import models.solarsystem.SSMetadataType;

   import utils.Objects;


   public class CSingleOwnerAssetsM
   {
      private var _metadata: MSSMetadataOfOwner;

      public function CSingleOwnerAssetsM(ownerMetadata: MSSMetadataOfOwner) {
         _metadata = Objects.paramNotNull("ssMetadata", ownerMetadata);
      }

      public function get ships(): CSolarSystemAssetsM {
         return new CSolarSystemAssetsM(
            assetType("_SHIPS"), _metadata.hasShips, _metadata.ships);
      }

      public function get planets(): CSolarSystemAssetsM {
         return new CSolarSystemAssetsM(
            assetType("_PLANETS"), _metadata.hasPlanets, _metadata.planets);
      }

      private function assetType(constantPostfix: String): String {
         return SSMetadataType.getConstantNamePrefixFor(_metadata.owner) + constantPostfix;
      }
   }
}
