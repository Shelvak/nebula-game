package utils.assets
{
   import components.battle.BattlefieldBackgroundPart;
   
   import controllers.objects.ObjectClass;
   
   import models.tile.FolliageTileKind;
   import models.tile.TerrainType;
   import models.tile.TileKind;
   
   import utils.ModelUtil;
   import utils.StringUtil;
   
   
   
   
   /**
    * Defines constants that hold path values to image, cursor forders (and so
    * on) as well as file extentions. Also has methods for building full
    * names of assets.
    */
   public final class AssetNames
   {
      /**
       * Folder where all images reside.
       */
      public static const IMAGE_FOLDER:String = "images/";
      
      
      /**
       * Path to the folder where battlefield images reside.
       */
      public static const BATTLEFIELD_IMAGE_FOLDER: String = IMAGE_FOLDER + "battlefield/";
      
      /**
       * Path to the folder where building images reside.
       */
      public static const BUILDING_IMAGE_FOLDER: String = IMAGE_FOLDER + "buildings/";
      
      /**
       * Path to the folder where unit images reside.
       */
      public static const UNIT_IMAGE_FOLDER: String = IMAGE_FOLDER + "units/";
      /**
       * Path to the folder where unit images suited for battle reside.
       */
      public static const UNIT_BATTLE_IMAGE_FOLDER:String = BATTLEFIELD_IMAGE_FOLDER + "units/";
      
      /**
       * Path to the folder where building images suited for battle reside.
       */
      public static const BUILDING_BATTLE_IMAGE_FOLDER:String = BATTLEFIELD_IMAGE_FOLDER + "buildings/";
      
      public static const GUNS_BATTLE_IMAGE_FOLDER:String = BATTLEFIELD_IMAGE_FOLDER + "guns/";
      
      /**
       * Path to the folder where folliage (blocking and non-blocking) images reside.
       */
      public static const FOLLIAGE_IMAGE_FOLDER: String = IMAGE_FOLDER + "folliage/";
      
      /**
       * Path to the folder where planet tile images reside.
       */
      public static const TILE_IMAGE_FOLDER: String = IMAGE_FOLDER + "tile/";
      
      /**
       * Path to the folder where planet regular tile images reside. 
       */      
      public static const REGULAR_TILE_IMAGE_FOLER: String = TILE_IMAGE_FOLDER + "regular/";
      
      /**
       * Path to the folder where planet tile mask images reside.
       */
      public static const TILE_MASK_IMAGE_FOLDER: String = TILE_IMAGE_FOLDER + "mask/";
      
      /**
       * Path to the folder where images used to immitate 3d planet of the planet reside.
       */
      public static const PLANET_3D_PLANE_FOLDER:String = TILE_IMAGE_FOLDER + "3d/";
      
      /**
       * Path to the folder where technologies images reside.
       */
      public static const TECHNOLOGIES_IMAGE_FOLDER: String = IMAGE_FOLDER + "technologies/";
      
      /**
       * Path to folder where galaxy images reside.
       */
      public static const GALAXY_IMAGE_FOLDER: String = IMAGE_FOLDER + "galaxy/";
      
      /**
       * Path to folder where solar system images reside. 
       */
      public static const SS_IMAGE_FOLDER:String = IMAGE_FOLDER + "solar_system/";
      
      /**
       * Name of a wormhole image.
       */
      public static const WORMHOLE_IMAGE_NAME:String = SS_IMAGE_FOLDER + "wormhole";
      
      /**
       * Name of a mini-battleground image.
       */
      public static const MINI_BATTLEGROUND_IMAGE_NAME:String = SS_IMAGE_FOLDER + "battleground";
      
      /**
       * Name of solar system shield image.
       */
      public static const SS_SHIELD_IMAGE_NAME:String = SS_IMAGE_FOLDER + "shield";
      
      /**
       * Path to folder where solar system status icons reside. 
       */
      public static const SS_STATUS_ICONS_FOLDER:String = SS_IMAGE_FOLDER + "status_icons/";
      
      /**
       * Path to folder where planet images reside. 
       */
      public static const SSOBJECT_IMAGE_FOLDER:String = IMAGE_FOLDER + "solar_system_object/";
      
      /**
       * Path to folder where cloud images reside.
       */
      public static const CLOUDS_IMAGE_FOLDER:String = SSOBJECT_IMAGE_FOLDER + "clouds/";
      
      /**
       * Path to folder where cloud shadow images reside.
       */
      public static const CLOUD_SHADOWS_IMAGE_FOLDER:String = CLOUDS_IMAGE_FOLDER + "shadows/";
      
      /**
       * Folder where solar system and galaxy backgrounds reside.
       */ 
      public static const SPACE_BACKGROUNDS_FOLDER: String = SS_IMAGE_FOLDER;
      
      /**
       * Folder where all UI images are located. 
       */      
      public static const UI_IMAGES_FOLDER: String = IMAGE_FOLDER + "ui/";
      
      /**
       * Folder of chat UI images.
       */
      public static const CHAT_IMAGES_FOLDER:String = UI_IMAGES_FOLDER + "chat/";
      
      /**
       * Folder of large panel images e.g. achievements (UI section).
       */
      public static const UI_LARGE_PANEL:String = UI_IMAGES_FOLDER + "large_panel/";
      
      /**
       * Folder of maps images (UI section).
       */
      public static const UI_MAPS:String = UI_IMAGES_FOLDER + "maps/";
      
      /**
       * Folder of space maps images in (UI section).
       */
      public static const UI_MAPS_SPACE:String = UI_MAPS + "space/";
      
      /**
       * Folder of static space map object images (UI section).
       */
      public static const UI_MAPS_SPACE_STATIC_OBJECT:String = UI_MAPS_SPACE + "static_object/";
      

      public static const START_MENU_FOLDER: String = UI_IMAGES_FOLDER + "start_menu/";
      
      
      public static const MOVEMENT_IMAGES_FOLDER:String = UI_IMAGES_FOLDER + "movement/";
      
      
      public static const FOW_LINE:String = UI_IMAGES_FOLDER + "fow_line";
      
      /**
       * Path to the folder where resource images reside.
       */
      public static const ICONS_IMAGE_FOLDER: String = UI_IMAGES_FOLDER + "icons/";
      
      /**
       * Path to the folder where achievement images reside.
       */
      public static const ACHIEVEMENT_IMAGE_FOLDER: String = IMAGE_FOLDER + "achievements/";
      
      /**
       * Path to the folder where notification images reside.
       */
      public static const NOTIFICATION_IMAGE_FOLDER: String = UI_IMAGES_FOLDER + "notifications/";
      
      
      public static const DEFENSIVE_PORTAL_IMAGES_FOLDER:String = UI_IMAGES_FOLDER + "defensive_portal_screen/";
      
      
      public static const SS_NAVIGATOR_FOLDER:String = UI_IMAGES_FOLDER + "ss_navigator/";
      
      
      public static const RATINGS_IMAGES_FOLDER:String = UI_IMAGES_FOLDER + "ratings/";
      
      
      /**
       * Path to the folder where notification images reside.
       */
      public static const STORAGE_SCREEN_FOLDER: String = UI_IMAGES_FOLDER + "storage_screen/";
      
      /**
       * Path to the folder where resource images reside.
       */
      public static const UNITS_SCREEN_IMAGE_FOLDER: String = UI_IMAGES_FOLDER + "units_screen/";
      
      
      public static var ALLIANCE_SCREEN_IMAGE_FOLDER:String = UI_IMAGES_FOLDER + "alliance/";
      
      
      public static var MARKET_SCREEN_IMAGE_FOLDER:String = UI_IMAGES_FOLDER + "market/";
      
      /**
       * Path to the folder where battlefield folliage (blocking and non-blocking) images reside.
       */
      public static const BATTLEFIELD_FOLLIAGE_IMAGE_FOLDER: String = BATTLEFIELD_IMAGE_FOLDER + "folliages/";
      
      /**
       * Path to the folder where buttons images reside.
       */
      public static const BUTTONS_IMAGE_FOLDER: String = UI_IMAGES_FOLDER + "buttons/";
      
      /**
       * Path to the folder where level display images reside.
       */
      public static const LEVEL_DISPLAY_IMAGE_FOLDER: String = UI_IMAGES_FOLDER + "level_parts/";
      
      /**
       * Path to the folder where panel images reside.
       */
      public static const PANEL_IMAGES_FOLDER: String = UI_IMAGES_FOLDER + "panel/";
      
      
      public static const INFO_SCREEN_IMAGES_FOLDER:String = UI_IMAGES_FOLDER + "info_screen/";
      public static const ANNOUNCEMENTS_IMAGES_FOLDER:String = UI_IMAGES_FOLDER + "announcements/";
      
      
      /**
       * Default background image name with extension.
       */
      public static const BACKGROUND_IMAGE:String = UI_IMAGES_FOLDER + "main_background";
      
      /**
       * Background behind the planet image in PlanetInfo component.
       */ 
      public static const PLANET_INFO_BACKGROUND: String =
         SSOBJECT_IMAGE_FOLDER + "info_" + BACKGROUND_IMAGE;
      
      
      /**
       * Builds and returns name of building image of a given type.
       * 
       * @param type Type of a building.
       * 
       * @return Building image name of a type.
       */
      public static function getBuildingImageName (type: String) :String
      {
         return BUILDING_IMAGE_FOLDER + type;
      }
      
      
      /**
       * Builds and returns name of blocking folliage image for a given
       * terrain type, folliage kind and variation.
       * 
       * @param terrainType type of a terrain.
       * @param kind folliage kind.
       * @param variation folliage variation.
       * 
       * @return folliage image name.
       */
      public static function getBlockingFolliageImageName(terrainType:int, kind:int) : String
      {
         return FOLLIAGE_IMAGE_FOLDER + terrainType + "/blocking/" + FolliageTileKind.getName(kind);
      }
      
      
      /**
       * Builds and returns name of non-blocking folliage frames folder of a given terrain type and
       * variation.
       * 
       * @param terrainType type of a terrain
       * @param variation folliage variation
       * 
       * @return name of folder where non-blocking folliage's frames reside
       */
      public static function getNonBlockingFolliagesFramesFolder(terrainType:int, variation:int) : String
      {
         return FOLLIAGE_IMAGE_FOLDER + terrainType + "/nonblocking/" + variation;
      }
      
      
      /**
       * Builds and returns name of background image of a given layer (applies
       * only for solar system and galaxy maps).
       * 
       * @param layer Id of a layer.
       * 
       * @return Background image name of a given layer.
       */
      public static function getSpaceBackgroundImageName(layer:int = 0) :String
      {
//         if (layer == LayeredBackground.DEFAULT_NUM_LAYERS - 1)
         if (layer == 0)
         {
            return SPACE_BACKGROUNDS_FOLDER + "background";
         }
         else
         {
            throw new Error("There is only one layer of space backgrounds!");
         }
      }
      
      
      /**
       * Builds and returns full name of a given solar system object image.
       * 
       * @param type type of solar system object; use constants in <code>SSObjectType</code> class
       * @param key image key without <code>SSOBJECT_IMAGE_FOLDER/type/</code> part
       * 
       * @return full name of a solar system object image
       */
      public static function getSSObjectImageName(type:String, key:String) : String
      {
         return SSOBJECT_IMAGE_FOLDER + type.toLowerCase() + "/" + key;
      }
      
      
      /**
       * Builds and returns full name of a galaxy image.
       * 
       * @return Name of a galaxy image.
       */
      public static function getGalaxyImageName() : String
      {
         return SS_IMAGE_FOLDER + "galaxy";
      }
      
      
      /**
       * Builds and returns full name of a solar system image.
       * 
       * @param variation variation of a solar system
       * 
       * @return name of a solar system image
       */
      public static function getSSImageName(variation:int) : String {
         return SS_IMAGE_FOLDER + variation;
      }
      
      
      /**
       * Builds and returns full name of a dead start (kind of solar system) image.
       */
      public static function getDeadStarImageName(variation:int) : String {
         return SS_IMAGE_FOLDER + "dead_star_" + variation;
      }
      
      
      /**
       * Builds and returns full name of a given solar system status icon.
       * 
       * @param type of the status icon. Use constants in <code>SSMetadataType</code>
       * for values of this parameter.
       * 
       * @return Name of a solar system status icon.
       */
      public static function getSSStatusIconName(type:String) : String
      {
         return SS_STATUS_ICONS_FOLDER + type;
      }
      
      
      /**
       * Builds and returns full name of a given tile kind image (texture actually).
       * 
       * @param kind Kind of a tile.
       * @param variation of a tile.
       * 
       * @return Name of a tile image.
       */ 
      public static function getTileImageName(kind:int) : String
      {
         if (TileKind.isResourceKind (kind))
         {
            return TILE_IMAGE_FOLDER + kind;
         }
         else
         {
            return TILE_IMAGE_FOLDER + kind;
         }
      }
      
      
      /**
       * Builds and returns full name of a regular tile type for a given terrain type.
       * 
       * @param terrainType Type of a terrain. Use constants form
       * <code>TerrainType</code> class.
       * 
       * @return Name of a regular tile image.
       */
      public static function getRegularTileImageName(terrainType:int) : String
      {
         return REGULAR_TILE_IMAGE_FOLER + terrainType;
      }
      
      
      /**
       * Builds and returns full name of a given tile mask type image.
       * 
       * @param type Type of a tile mask. Use <code>TileMaskType</code> constants for
       * correct values of this parameter.
       * 
       * @return Name of a tile mask image.
       */
      public static function getTileMaskImageName(type:String) : String
      {
         return TILE_MASK_IMAGE_FOLDER + type;
      }
      
      
      /**
       * Builds and returns full name of a 3d plane immitation image for a given terrain type and dimension.
       * 
       * @param terrainType Type of a terrain. Use constants form <code>TerrainType</code> class
       * @param dimension either <code>MapDimensionType.WIDHT</code> or <code>MapDimensionType.HEIGHT</code> 
       * 
       * @return Name of a regular tile image.
       */
      public static function get3DPlaneImageName(terrainType:int, dimension:String) : String
      {
         return PLANET_3D_PLANE_FOLDER + terrainType + "_" + dimension;
      }
      
      
      /**
       * Builds and returns full name of a given resource type image.
       * 
       * @param type Type of a resource.
       * 
       * @return Name of a resource image.
       */
      public static function getIconImageName(type:String) : String
      {
         return ICONS_IMAGE_FOLDER + StringUtil.firstToLowerCase(type);
      }
      
      
      /**
       * Builds and returns full name of a given button type image.
       * 
       * @param type Type of a button.
       * 
       * @return Name of a button image.
       */
      public static function getButtonImageName(type:String) : String
      {
         return BUTTONS_IMAGE_FOLDER + type;
      }
      
      
      /**
       * Builds and returns full name of a given technology type image.
       * 
       * @param type Type of the technology.
       * 
       * @return Name of the technology image.
       */
      public static function getTechnologyImageName(type:String) : String
      {
         return TECHNOLOGIES_IMAGE_FOLDER + StringUtil.firstToUpperCase(type);
      }
      
      
      public static function getLocationUnitImageName(type:String) : String
      {
         return NOTIFICATION_IMAGE_FOLDER + 'location'+StringUtil.firstToUpperCase(type);
      }
      
      
      public static function getUnitImageName(type:String) : String
      {
         return UNIT_IMAGE_FOLDER + StringUtil.firstToUpperCase(type);
      }
      
      
      public static function getConstructableImageName(type:String) : String
      {
         var folderName: String;
         switch (ModelUtil.getModelClass(type))
         {
            case ObjectClass.BUILDING:
               folderName = BUILDING_IMAGE_FOLDER;
               break;
            
            case ObjectClass.UNIT:
               folderName = UNIT_IMAGE_FOLDER;
               break;
         }
         return folderName + ModelUtil.getModelSubclass(type);
            
      }
      
      public static function getConceptBuildingImageName (type: String): String
      {
         return BUILDING_IMAGE_FOLDER + 'constructors/' + type;
      }
      
      
      /**
       * Builds and returns full name of a given level display part image.
       * 
       * @param part part of the level display.
       * 
       * @return Name of the level display part image.
       */
      public static function getLevelDisplayImageName(part:String) : String
      {
         return LEVEL_DISPLAY_IMAGE_FOLDER + part;
      }
      
      
      /**
       * Builds and returns full name of a given battlefield image for a given type of terrain.
       * 
       * @param terrainType one of values of constants in <code>TerrainType</code> class.
       * @param part one of values of constants in <code>BattlefieldBackgroundPart</code> class.
       * 
       * @return Name of battlefield background image.
       */
      public static function getBattlefieldBackgroundImage(part:String, terrainType:int = 0) : String
      {
         switch (part)
         {
            case BattlefieldBackgroundPart.SPACE:
               return getSpaceBackgroundImageName();
            case BattlefieldBackgroundPart.GROUND:
               return getRegularTileImageName(terrainType);
            case BattlefieldBackgroundPart.SPACE_SCENERY:
               return BATTLEFIELD_IMAGE_FOLDER + part;
            default:
               return BATTLEFIELD_IMAGE_FOLDER + terrainType + "/" + part;
         }
      }
      
      public static function getBattlefieldBorderImage(part: String): String
      {
         return BATTLEFIELD_IMAGE_FOLDER + 'border/' + part;
      }
      
      
      /**
       * Builds and returns name of a frames folder of a given unit type.
       * 
       * @param type Type of a unit.
       * 
       * @return Name of a folder were unit's frames reside.
       */
      public static function getUnitFramesFolder(type:String) : String
      {
         return UNIT_BATTLE_IMAGE_FOLDER + type;
      }
      
      
      /**
       * Builds and returns full name of a given building type image for a battle.
       * 
       * @param type Type of a building.
       * 
       * @return Name of building battle image.
       */
      public static function getBuildingFramesFolder(type:String) : String
      {
         return BUILDING_BATTLE_IMAGE_FOLDER + type;
      }
      
      
      public static function getProjectileFramesFolder(type:String) : String
      {
         return GUNS_BATTLE_IMAGE_FOLDER + type;
      }
      
      public static function getAchievementImageName(type: String, key: String): String
      {
         return ACHIEVEMENT_IMAGE_FOLDER + type + key.replace('::', '_');
      }
      
      
      /**
       * Builds and returns full name of a given cloud variation image.
       * 
       * @param variation variation of a cloud.
       * 
       * @return Name of cloud image.
       */
      public static function getCloudImageName(variation:int) : String
      {
         return CLOUDS_IMAGE_FOLDER + variation;
      }
      
      
      /**
       * Builds and returns full name of a given cloud variation shadow image.
       * 
       * @param variation variation of a cloud.
       * 
       * @return Name of cloud shadow image.
       */
      public static function getCloudShadowImageName(variation:int) : String
      {
         return CLOUD_SHADOWS_IMAGE_FOLDER + variation;
      }
      
      
      /**
       * Builds and returns name of blocking battlefield folliage frames folder of a given terrain 
       * type and variation.
       * 
       * @param terrainType type of a terrain
       * @param variation folliage variation
       * 
       * @return name of folder where blocking folliage's frames reside
       */
      public static function getBlockingBattlefieldFolliagesFramesFolder(terrainType:int, variation:int) : String
      {
         return BATTLEFIELD_FOLLIAGE_IMAGE_FOLDER + "blocking/" + terrainType + "/" + variation;
      }
   }
}