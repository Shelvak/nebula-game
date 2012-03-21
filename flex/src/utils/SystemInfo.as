package utils
{
   import flash.system.Capabilities;


   public class SystemInfo
   {
      private static var _instance: SystemInfo;
      private static function get instance(): SystemInfo {
         if (_instance == null) {
            _instance = new SystemInfo(new SingletonLock());
         }
         return _instance;
      }

      public function SystemInfo(singletonLock: SingletonLock) {
         Objects.notNull(
            singletonLock,
            "You can't access instance of this class. Use static methods instead."
         );

         const platformAndVersion: Array = Capabilities.version.split(" ");
         _platform = platformAndVersion[0];
         const version: Array = String(platformAndVersion[1]).split(",");
         _playerMajorVersion = version[0];
         _playerMinorVersion = version[1];
         _isDebugger = Capabilities.isDebugger;
      }

      private var _isDebugger: Boolean;
      public static function get isDebugger(): Boolean {
         return instance._isDebugger;
      }

      private var _platform: String;
      private static function get platform(): String {
         return instance._platform;
      }
      public static function get platformWindows(): Boolean {
         return platform == "WIN";
      }
      public static function get platformMac(): Boolean {
         return platform == "MAC";
      }
      public static function get platformAndroid(): Boolean {
         return platform == "AND";
      }
      public static function get platformLinux(): Boolean {
         return platform == "LNX";
      }

      private var _playerMajorVersion: int;
      public static function get playerMajorVersion(): int {
         return instance._playerMajorVersion;
      }

      private var _playerMinorVersion: int;
      public static function get playerMinorVersion(): int {
         return instance._playerMinorVersion;
      }
   }
}


class SingletonLock{}
