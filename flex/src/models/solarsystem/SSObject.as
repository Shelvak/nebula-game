package models.solarsystem
{
   import config.Config;
   
   import flash.display.BitmapData;
   
   import models.BaseModel;
   import models.Player;
   import models.resource.Resource;
   import models.solarsystem.events.SSObjectEvent;
   import models.tile.TerrainType;
   
   import utils.MathUtil;
   import utils.assets.AssetNames;
   
   
   /**
    * Dispatched when owner of solar system object has changed.
    * 
    * @eventType models.solarsystem.events.SSObjectEvent.OWNER_CHANGE
    */
   [Event(name="ownerChange", type="models.solarsystem.events.SSObjectEvent")]
   
   
   public class SSObject extends BaseModel
   {
      /**
       * Original width of an object image.
       */
      public static const IMAGE_WIDTH: Number = 200;
      
      
      /**
       * Original height of an object image.
       */
      public static const IMAGE_HEIGHT: Number = IMAGE_WIDTH;
      
      
      public function SSObject()
      {
         super();
      }
      
      
      [Required]
      /**
       * Id of the solar system this object belongs to.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required]</i></p>
       * 
       * @default 0
       */
      public var solarSystemId:int = 0;
      
      
      [Required]
      [Bindable(event="willNotChange")]
      /**
       * Name of the object.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required]<br/>
       * [Bindable(event="willNotChange")]</i></p>
       * 
       * @default empty string
       */
      public var name:String = "";
      
      
      [Optional]
      [Bindable(event="willNotChange")]
      /**
       * Terrain type of the object (only relevant if object is a planet).
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Optional]<br/>
       * [Bindable(event="willNotChange")]</i></p>
       * 
       * @default <code>TerrainType.GRASS</code>
       */
      public var terrain:int = TerrainType.GRASS;
      
      
      [Required]
      /**
       * Size of the planet image in the solar system map compared with original image
       * dimentions in percents.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required]</i></p>
       * 
       * @default 100 percent
       */
      public var size:Number = 100;
      
      
      [Optional]
      /**
       * Width of the planet's map in tiles (only relevant if object is a planet).
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Optional]</i></p>
       * 
       * @default 0
       */
      public var width:int = 0;
      
      
      [Optional]
      /**
       * Height of the planet's map in tiles (only relevant if object is a planet).
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Optional]</i></p>
       * 
       * @default 0
       */
      public var height:int = 0;
      
      
      /* ############ */
      /* ### TYPE ### */
      /* ############ */
      
      
      [Bindable(event="willNotChange")]
      /**
       * Type of this object.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="willNotChange")]</i></p>
       * 
       * @default <code>SSObjectType.PLANET</code>
       */
      public var type:String = SSObjectType.PLANET;
      
      
      /**
       * @see SSObjectType#getLocalizedName()
       */
      public function get typeName() : String
      {
         return SSObjectType.getLocalizedName(type);
      }
      
      
      [Bindable(event="willNotChange")]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="willNotChange")]</i></p>
       */
      public function get isPlanet() : Boolean
      {
         return type == SSObjectType.PLANET;
      }
      
      
      [Bindable(event="willNotChange")]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="willNotChange")]</i></p>
       */
      public function get isAsteroid() : Boolean
      {
         return type == SSObjectType.ASTEROID;
      }
      
      
      [Bindable(event="willNotChange")]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="willNotChange")]</i></p>
       */
      public function get isJumpgate() : Boolean
      {
         return type == SSObjectType.JUMPGATE;
      }
      
      
      [Bindable(event="willNotChange")]
      /**
       * Variation of solar system object.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="willNotChange")]</i></p>
       */
      public function get variation() : int
      {
         var key:String = "ui.ssObject." + type.toLowerCase();
         if (isPlanet)
         {
            key += "." + terrain;
         }
         key += ".variations";
         return Config.getValue(key);
      }
      
      
      [Bindable(event="willNotChange")]
      /**
       * Image of a planet.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="willNotChange")]</i></p>
       */
      public function get imageData() : BitmapData
      {
         var key:String = "";
         if (isPlanet)
         {
            key += terrain + "/";
         }
         key += variation.toString();
         return IMG.getImage(AssetNames.getSSObjectImageName(type, key));
      }
      
      
      /* ################ */
      /* ### LOCATION ### */
      /* ################ */
      
      
      [Required]
      [Bindable]
      /**
       * Number of the orbit. An orbit is just an ellipse around a star of a solar system.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required]<br/>
       * [Bindable]</i></p>
       * 
       * @default 0
       */
      public var position:int = 0;
      
      
      [Required]
      [Bindable]
      /**
       * Measured in degrees.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required]<br/>
       * [Bindable]</i></p>
       * 
       * @default 0
       */
      public var angle:Number = 0;
      
      
      /**
       * Same as <code>angle</code> just measured in radians. 
       */	   
      public function get angleRadians() : Number
      {
         return MathUtil.degreesToRadians(angle);
      }
      
      
      /* ############# */
      /* ### OWNER ### */
      /* ############# */
      
      
      private var _playerId:int = Player.NO_PLAYER_ID;
      [Required]
      [Bindable(event="ownerChange")]
      /**
       * Id of the player this object belongs to.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required]<br/>
       * [Bindable(event="ownerChange")]</i></p>
       * 
       * @default Player.NO_PLAYER_ID
       */
      public function set playerId(value:int) : void
      {
         if (_playerId != value)
         {
            _playerId = value;
            dispatchOwnerChangeEvent();
            dispatchPropertyUpdateEvent("playerId", value);
            dispatchPropertyUpdateEvent("isOwned", isOwned);
            dispatchPropertyUpdateEvent("isOwnedByCurrent", isOwnedByCurrent);
         }
      }
      /**
       * @private
       */
      public function get playerId() : int
      {
         return _playerId;
      }
      
      
      [Optional]
      [Bindable]
      /**
       * Player that owns this object. This is only for additional information only. If you need
       * player id, use <code>playerId</code> property.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Optional]<br/>
       * [Bindable]</i></p>
       * 
       * @default null
       */
      public var player:Player = null;
      
      
      [Bindable(event="ownerChange")]
      /**
       * Indicates if a planet is owned by someone.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="ownerChange")]</i></p>
       * 
       * @default false 
       */
      public function get isOwned() : Boolean
      {
         return playerId != Player.NO_PLAYER_ID;
      }
      
      
      /**
       * True means that this object belongs to the current player.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="ownerChange")]</i></p>
       * 
       * 
       * @default false 
       */      
      [Bindable(event="ownerChange")]
      public function get isOwnedByCurrent() : Boolean
      {
         return isOwned && ML.player.id == playerId;
      }
      
      
      /* ################# */
      /* ### RESOURCES ### */
      /* ################# */
      
      
      [Bindable]
      [Optional(alias="metal")]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]<br/>
       * [Optional(alias="metal")]</i></p>
       */
      public var metalAfterLastUpdate:Number;

      
      [Bindable]
      [Optional(alias="energy")]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]<br/>
       * [Optional(alias="energy")]</i></p>
       */
      public var energyAfterLastUpdate:Number;
      
      
      [Bindable]
      [Optional(alias="zetium")]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]<br/>
       * [Optional(alias="zetium")]</i></p>
       */
      public var zetiumAfterLastUpdate:Number;
      
      
      [Optional]
      /**
       * Last time resources have been updated.
       */
      public var lastResourcesUpdate:Date;
      
      
      [Bindable]
      public var metal:Resource;
      
      
      [Bindable]
      public var energy:Resource;
      
      
      [Bindable]
      public var zetium:Resource;
      
      
      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */
      
      
      private function dispatchOwnerChangeEvent() : void
      {
         if (hasEventListener(SSObjectEvent.OWNER_CHANGE))
         {
            dispatchEvent(new SSObjectEvent(SSObjectEvent.OWNER_CHANGE));
         }
      }
   }
}