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
var title = urlParams['title'];
var titleSuffix = " :: Nebula 44";
// Used as element id.
var appName = "nebula44";

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
  return location.href.indexOf("file://") == 0; 
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
    if (defined(server) && defined(playerId) && defined(locale) && 
        defined(webHost) && defined(assetsUrl)) {
      document.title = locales.combatReplayTitle(locale) + titleSuffix;
      return {mode: 'combatLog', server: server, logId: combatLogId, 
        playerId: playerId, locale: locale, webHost: webHost,
        assetsUrl: assetsUrl};
    }
    else {
      if (! defined(server)) missingParam('server');
      if (! defined(playerId)) missingParam('player_id');
      if (! defined(locale)) missingParam('locale');
      if (! defined(webHost)) missingParam('web_host');
      if (! defined(assetsUrl)) missingParam('assets_url');
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
      if (! defined(server)) server = developmentServer();
      if (! defined(webPlayerId)) webPlayerId = developmentWebPlayerId;
      if (! defined(serverPlayerId)) serverPlayerId = developmentServerPlayerId;
      if (! defined(locale)) locale = "en";
      if (! defined(webHost)) webHost = "localhost";

      document.title = "Local Dev Mode" + titleSuffix;
    }
    else {
      if (defined(server) && defined(webPlayerId) && defined(serverPlayerId) && 
          defined(locale) && defined(webHost) && defined(assetsUrl) && 
          defined(title)) {
        document.title = title + titleSuffix;
      }
      else {
        if (! defined(server)) missingParam('server');
        if (! defined(webPlayerId)) missingParam('web_player_id');
        if (! defined(serverPlayerId)) missingParam('server_player_id');
        if (! defined(locale)) missingParam('locale');
        if (! defined(webHost)) missingParam('web_host');
        if (! defined(assetsUrl)) missingParam('assets_url');
        if (! defined(title)) missingParam('title');
        return null;
      }
    }
    
    return {mode: 'game', server: server, webPlayerId: webPlayerId,
      serverPlayerId: serverPlayerId, locale: locale, webHost: webHost,
      assetsUrl: assetsUrl};
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
      'success': function(data) {
        if (data == "success") {
          authorizationSuccessful();
        }
        else {
          authorizationFailed();
        }
      }, 
      'error': authorizationFailed
    });
  }
} // }}}

// Called when authorization succeeds.
function authorizationSuccessful() {
  document.getElementById(appName).authorizationSuccessful();
}

// Called when authorization fails.
function authorizationFailed() {
  window.alert(locales.failedAuth(locale));
  window.location = "http://" + webHost;
}

// Called when player successfully logs in into server.
function loginSuccessful() {
  _gaq.push(['_trackPageview', '/play/client/success']);
}

// Get combat log URL for log with given ID.
function getCombatLogUrl(combatLogId, playerId) { // {{{
  var clAssetsUrl = assetsUrl == ""
    ? location.href.replace(location.search, '')
    : assetsUrl;
  var e = encodeURIComponent;

  return encodeURI(clAssetsUrl) + "?server=" + e(server) + 
    "&web_host=" + e(webHost) + "&assets_url=" + e(assetsUrl) +
    "&combat_log_id=" + e(combatLogId) + "&player_id=" + e(playerId) +
    "&locale=" + e(locale);
} // }}}

// Setup google analytics {{{
var _gaq = _gaq || [];
_gaq.push(['_setAccount', gaAccountId], ['_trackPageview']);
if (! inLocalComputer() && ! inDeveloperMode())
  include("http://www.google-analytics.com/ga.js", 'async="true"');
// }}}

// Load our swf {{{
$(document).ready(function() {
  var flashvars = {};
  var params = {};
  params.quality = "high";
  params.bgcolor = "#ffffff";
  // When AllowScriptAccess is "always," the SWF file can communicate with 
  // the HTML page in which it is embedded. This rule applies even when the
  // SWF file is from a different domain than the HTML page.
  params.allowscriptaccess = "always";
  params.allowfullscreen = "true";
  var attributes = {};
  attributes.id = appName;
  attributes.name = appName;
  attributes.align = "middle";
  var swfName = fp.binDebug
    ? fp.swf + ".swf"
    : fp.swf + "-" + fp.swfChecksum + ".swf"
  var minVersion = fp.binDebug ? "0.0.0" : fp.swfVersionStr;
  swfobject.embedSWF(assetsUrl + swfName, "flashContent", 
      "100%", "100%", minVersion, assetsUrl + "playerProductInstall.swf", 
      flashvars, params, attributes);
  swfobject.createCSS("#flashContent", "display:block;text-align:left;"); 

});
// }}}
