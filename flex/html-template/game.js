// Store url params {{{
var urlParams = {};
(function () {
    var e,
        a = /\+/g,  // Regex for replacing addition symbol with a space
        r = /([^&=]+)=?([^&]*)/g,
        d = function (s) { return decodeURIComponent(s.replace(a, " ")); },
        q = window.location.search.substring(1);

    while (e = r.exec(q))
       urlParams[d(e[1])] = d(e[2]);
})();
// }}}

var locales = { // {{{
  loadingTitle: function(locale) {
    if (locale == "lt") return "Nebula 44 kraunasi...";
    if (locale == "lv") return "LOCALE: Nebula 44 is loading...";
    return "Nebula 44 is loading...";
  },
  combatReplayTitle: function(locale) {
    if (locale == "lt") return "Mūšio įrašas";
    if (locale == "lv") return "LOCALE: Combat Replay";
    return "Combat Replay";
  },
  failedAuth: function(locale) {
    if (locale == "lt") return "Serveriui nepavyko tavęs prijungti. " +
      "Gali būti, jog esi atsijungęs nuo puslapio.\n\n" +
      "Pabandyk prisijungti prie puslapio iš naujo.";
    if (locale == "lv") return "LOCALE: fixme";
    return "Server was unable to authorize you. " +
      "Perhaps your web page session has expired?\n\n" +
      "Please try to relogin to our main web page.";
  }
} // }}}

var developmentServerPlayerId = 1;
var developmentWebPlayerId = 0;

// Authentification data
var server = urlParams['server'];
var webPlayerId = urlParams['web_player_id'];
var serverPlayerId = urlParams['server_player_id'];

// Combat replay data.
var combatLogId = urlParams['combat_log_id'];
var playerId = urlParams['player_id'];

// Support data.
var locale = urlParams['locale'];
var webHost = urlParams['web_host'];
var assetsUrl = urlParams['assets_url'];
var title = urlParams['title'];
var titleSuffix = " :: Nebula 44";

// If running a local debug build, take assets from relative url.
if (fp.binDebug) assetsUrl = ""; 
// Local file, but built with rake.
else if (location.href.indexOf('file://') == 0) assetsUrl = ""
// Networking via local lan, dev mode
else if (location.href.indexOf('nebula44.') == -1) assetsUrl = ""
// Backwards compatibility for combat replays.
else if (! assetsUrl) assetsUrl = "http://static." + webHost + "/";

document.title = locales.loadingTitle(locale);

if (! Array.prototype.indexOf) { // {{{
  Array.prototype.indexOf = function (obj, fromIndex) {
    if (fromIndex == null) {
        fromIndex = 0;
    } else if (fromIndex < 0) {
        fromIndex = Math.max(0, this.length + fromIndex);
    }
    for (var i = fromIndex, j = this.length; i < j; i++) {
        if (this[i] === obj)
            return i;
    }
    return -1;
  };
} // }}}

function inLocalComputer() { 
  return location.href.indexOf("file://") == 0 ||
    location.href.indexOf("localhost") != -1; 
}
function inDeveloperMode() { return urlParams['dev'] == '1'; }

function developmentServer() { // {{{
  server = location.hostname;
  // Support for file://
  if (server == "") server = "localhost";

  return server;
} // }}}

var notificationTimerId = 0;
var notificationToggle = false;
var notificationOldTitle = "";

// Call me when notifications window is opened.
function notificationsOpened() { // {{{
  if (notificationTimerId != 0) {
    clearInterval(notificationTimerId);
    notificationTimerId = 0;
    notificationToggle = false;
    document.title = notificationOldTitle;
  }
} // }}}

// Call me when we have unread notifications.
//noinspection JSUnusedGlobalSymbols
function setUnreadNotifications(count) { // {{{
  notificationsOpened();  
  notificationOldTitle = document.title;
  
  notificationTimerId = setInterval(function() {
    if (notificationToggle) {
      document.title = notificationOldTitle;
    }
    else {
      document.title = "* " + count + " unread notifications *";
    }
    
    notificationToggle = ! notificationToggle;
  }, 1000);
} // }}}

function missingParam(name) {
  window.alert("Missing query parameter: " + name);
}

// Returns game options for the Flash Client.
//
// If it returns null, client should stop initialization.
function getGameOptions() { // {{{
  // Let's show us some combat!
  //
  // Example:
  //   ?mode=combatLog&server=game.nebula44.com&combat_log_id=a1s2d3f4&
  //     player_id=3&locale=lt&web_host=nebula44.com&
  //     assets_url=http://static.nebula44.com/
  if (combatLogId) {
    if (server && playerId && locale && webHost && assetsUrl) {
      document.title = locales.combatReplayTitle(locale) + titleSuffix;
      return {'mode': 'combatLog', 'server': server, 'logId': combatLogId, 
        'playerId': playerId, 'locale: locale', 'webHost': webHost,
        'assetsUrl': assetsUrl};
    }
    else {
      if (! server) missingParam('server');
      if (! playerId) missingParam('player_id');
      if (! locale) missingParam('locale');
      if (! webHost) missingParam('web_host');
      if (! assetsUrl) missingParam('assets_url');
      return null;
    }
  }
  // Normal game.
  //
  // Example:
  //   ?server=game.nebula44.com&server_player_id=10&web_player_id=3&
  //     locale=lt&web_host=nebula44.com&
  //     assets_url=http://static.nebula44.com/
  //
  // You can append &dev=1 to skip requesting for web authentification.
  else {
    if (inLocalComputer() && ! inDeveloperMode()) {
      if (! server) server = developmentServer();
      if (! webPlayerId) webPlayerId = developmentWebPlayerId;
      if (! serverPlayerId) serverPlayerId = developmentServerPlayerId;
      if (! locale) locale = "en";
      if (! webHost) webHost = "localhost";

      document.title = "Local Dev Mode" + titleSuffix;
    }
    else {
      if (server && webPlayerId && serverPlayerId && locale && webHost && 
          assetsUrl && title) {
        document.title = title + titleSuffix;
      }
      else {
        if (! server) missingParam('server');
        if (! webPlayerId) missingParam('web_player_id');
        if (! serverPlayerId) missingParam('server_player_id');
        if (! locale) missingParam('locale');
        if (! webHost) missingParam('web_host');
        if (! assetsUrl) missingParam('assets_url');
        if (! title) missingParam('title');
        return null;
      }
    }
    
    return {'mode': 'game', 'server': server, 'webPlayerId': webPlayerId,
      'serverPlayerId': serverPlayerId, 'locale': locale, 'webHost': webHost,
      'assetsUrl': assetsUrl};
  }
} // }}}

// Try to authorize with the web server
function authorize() { // {{{
  if (inLocalComputer() || inDeveloperMode()) {
    authorizationSuccessful();
  }
  else {
    $.ajax({
      'url': "http://" + webHost + "/play/client_auth/" + webPlayerId,
      'timeout': 5000, // 5 seconds.
      'success': authorizationSuccessful,
      'error': authorizationFailed
    });
  }
} // }}}

// Called when authorization succeeds.
function authorizationSuccessful() {
  swf.authorizationSuccessful();
}

// Called when authorization fails.
function authorizationFailed() {
  window.alert(locales.failedAuth(locale));
  window.location = "http://" + webHost;
}

// Get combat log URL for log with given ID.
function getCombatLogUrl(id, playerId, server, webHost, locale) {
  return location.href.replace(location.search, '') + "?server=" + server +
    "&combat_log_id=" + id + "&player_id=" + playerId + "&web_host=" + webHost +
    "&locale=" + locale;
}

// Load our swf.
// {{{
var swf = null;
$(document).ready(function() {
  var flashvars = {};
  var params = {};
  params.quality = "high";
  params.bgcolor = "#ffffff";
  params.allowscriptaccess = "sameDomain";
  params.allowfullscreen = "true";
  var attributes = {};
  attributes.id = "nebula44";
  attributes.name = "nebula44";
  attributes.align = "middle";
  var swfName = fp.binDebug
    ? "SpaceGame.swf"
    : assetsUrl + fp.swf + "-" + fp.swfChecksum + ".swf"
  swf = swfobject.embedSWF(swfName, "flashContent", 
      "100%", "100%", 
      fp.swfVersionStr, "playerProductInstall.swf", 
      flashvars, params, attributes);
  // JavaScript enabled so display the flashContent div in case it 
  // is not replaced with a swf object.
  swfobject.createCSS("#flashContent", "display:block;text-align:left;"); 
});
// }}}
