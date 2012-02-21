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
  planetEditorTitle: function(locale) {
    if (locale == "lt") return "Planetos žemėlapių redaktorius";
    if (locale == "lv") return "LOCALE: Planet map editor";
    return "Planet map editor";
  },
  failedAuth: function(locale) {
    if (locale == "lt") return "Serveriui nepavyko tavęs prijungti. " +
      "Gali būti, jog esi atsijungęs nuo puslapio.\n\n" +
      "Pabandyk prisijungti prie puslapio iš naujo.";
    if (locale == "lv") return "LOCALE: fixme";
    return "Server was unable to authorize you. " +
      "Perhaps your web page session has expired?\n\n" +
      "Please try to relogin to our main web page.";
  },
  versionTooOld: function(locale, requiredVersion, currentVersion) {
    if (locale == "lt") return "Per sena žaidimo versija!\n\n" +
       "Serveris reikalauja bent jau \"" + requiredVersion + "\" versijos, " +
       "tačiau pas tave yra versija \"" + currentVersion + "\".\n\n" +
       "Žaidimas bus perkrautas tam kad jį atnaujinti."
    if (locale == "lv") return "LOCALE: fixme";
    return "Game version too old!\n\n" +
       "Server requires at least version \"" + requiredVersion + "\" but you " +
       "only have version \"" + currentVersion + "\".\n\n" +
       "Game will be reloaded to upgrade its version."
  },
  navigateAwayMessage: function(locale) {
    if (locale == "lt") return "Ar tikrai nori uždaryti Nebula 44?";
    if (locale == "lv") return "LOCALE: fixme";
    return "Are you sure you want to close Nebula 44?";
  }
} // }}}

var developmentServerPlayerId = 1;
var developmentWebPlayerId = 0;

// Authentication data
var server = urlParams['server'];
var webPlayerId = urlParams['web_player_id'];
var serverPlayerId = urlParams['server_player_id'];

// Combat replay data.
var combatLogId = urlParams['combat_log_id'];
var playerId = urlParams['player_id'];

// Planet map editor data.
var planetMapEditor = urlParams['planet_map_editor']

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
//noinspection JSUnusedGlobalSymbols
function getGameOptions() { // {{{
  if (planetMapEditor) {
    if (inLocalComputer() || inDeveloperMode()) {
      if (! defined(server)) server = developmentServer();
      if (! defined(locale)) locale = "lt";
      if (! defined(webHost)) webHost = "localhost";

      document.title = "Local Planet Map Editor Dev Mode" + titleSuffix;
    }
    else {
      if (defined(server) && defined(locale) && defined(webHost) &&
          defined(assetsUrl)) {
        document.title = locales.planetEditorTitle(locale) + titleSuffix;
      }
      else {
        if (! defined(server)) missingParam('server');
        if (! defined(locale)) missingParam('locale');
        if (! defined(webHost)) missingParam('web_host');
        if (! defined(assetsUrl)) missingParam('assets_url');
        return null;
      }
    }

    return {mode: 'planetMapEditor', server: server, locale: locale,
      assetsUrl: assetsUrl};
  }
  // Let's show us some combat!
  //
  // Example:
  //   ?mode=combatLog&server=game.nebula44.com&combat_log_id=a1s2d3f4&
  //     player_id=3&locale=lt&web_host=nebula44.com&
  //     assets_url=http://static.nebula44.com/
  else if (combatLogId) {
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
  // You can append &dev=1 to skip requesting for web authentication.
  else {
    if (inLocalComputer() || inDeveloperMode()) {
      if (! defined(server)) server = developmentServer();
      if (! defined(webPlayerId)) webPlayerId = developmentWebPlayerId;
      if (! defined(serverPlayerId)) serverPlayerId = developmentServerPlayerId;
      if (! defined(locale)) locale = "lt";
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
  // Remove leave confirmation.
  window.onbeforeunload = null;
  window.alert(locales.failedAuth(locale));
  window.location = "http://" + webHost;
}

// Called when client version is too old.
function versionTooOld(requiredVersion, currentVersion) {
  window.alert(locales.versionTooOld(locale, requiredVersion, currentVersion));
  window.location.reload();
}

// Called when player successfully logs in into server.
function loginSuccessful() {
  _gaq.push(['_trackPageview', '/play/game/success']);
}

// Ensure player does not close the game accidentally.
function setLeaveHandler(enabled) {
  window.onbeforeunload = enabled
    ? function() { return locales.navigateAwayMessage(locale); }
    : null;
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
if (! inLocalComputer() && ! inDeveloperMode() && ! defined(combatLogId)) {
  _gaq.push(['_setAccount', gaAccountId], ['_trackPageview']);
  include("http://www.google-analytics.com/ga.js", 'async="true"');
}
// }}}

// Called from flash when it crashes.
function clientError(head, body, slowClient) {
  // No leave confirmation upon crash.
  setLeaveHandler(false);

  var container = $('<div/>');

  $('<h1/>', {
    text: "Client error"
  }).appendTo(container);

  if (slowClient) {
    $('<pre/>', {
      text: "Slow client: true"
    }).appendTo(container);
  } else {
    $('<pre/>', {
      text: "Slow client: false"
    }).appendTo(container);
  }

  $('<h1/>', {
    text: "Head"
  }).appendTo(container);


  $('<pre/>', {
    text:head
  }).appendTo(container);

  $('<br/>').appendTo(container);

  $('<h1/>', {
    text: "Body"
  }).appendTo(container);


  $('<pre/>', {
    text:body
  }).appendTo(container);

  $('body').attr('id', 'client-error');
  $('body').html(container.html());
}

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
