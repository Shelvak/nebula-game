var developmentAuthToken = "0000000000000000000000000000000000000000000000000000000000000000";
var developmentServers = ["", "localhost", "spacegame.busiu.lt"];
// Read cookies immediatly because other window might overwrite them.
var galaxyId = readCookie('galaxy_id');
var authToken = readCookie('auth_token');
var title = readCookie('title');

if (! Array.prototype.indexOf) {
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
}

function isDevelopmentMode() {
  return developmentServers.indexOf(location.hostname) != -1;
}

function developmentServer() {
  server = location.hostname;
  // Support for file://
  if (server == "") server = "localhost";

  return server;
}

var notificationTimerId = 0;
var notificationToggle = false;
var notificationOldTitle = "";

// Call me when notifications window is opened.
function notificationsOpened() {
  if (notificationTimerId != 0) {
    clearInterval(notificationTimerId);
    notificationTimerId = 0;
    notificationToggle = false;
    document.title = notificationOldTitle;
  }
}

// Call me when we have unread notifications.
function setUnreadNotifications(count) {
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
}

// Call me to know what to do.
function getGameOptions() {
  var server = queryString('server');
  var combatLogId = queryString('combat_log_id');
  var playerId = queryString('player_id');

  // dev mode
  if (! galaxyId) galaxyId = queryString('galaxy_id');
  if (! authToken) authToken = queryString('auth_token');
  if (! title) title = "Dev Login Mode";
  
  var titleSuffix = " :: Nebula 44";

  // Let's show us some combat!
  if (combatLogId) {
    document.title = "Combat Replay" + titleSuffix;
    return {mode: 'combatLog', server: server, logId: combatLogId, playerId: playerId};
  }
  // Let's play the game!
  else if (authToken) {
    document.title = URLDecode(title) + titleSuffix;
    return {mode: 'game', galaxyId: galaxyId, server: server, 
      authToken: authToken};
  }
  // Allow for quick launch in dev mode
  else if (isDevelopmentMode()) {
    document.title = "Dev Mode" + titleSuffix;
    server = developmentServer();
    
    return {'mode': 'game', 'galaxyId': 1, 'server': server, 
      'authToken': developmentAuthToken};
  }
  // This should not happen.
  else {
    window.alert("You authentification cookie has expired. You must press" +
      " play in the main page again. You will be redirected to " +
      "nebula44.com now.");
    window.location = "http://nebula44.com";
    return null;
  }
}

// Get combat log URL for log with given ID.
function getCombatLogUrl(id, playerId) {
  var server = queryString('server');
  if (! server) server = developmentServer();

  return location.href.replace(location.search, '') + "?server=" + server + "&combat_log_id=" + id +
     "&player_id=" + playerId;
}

// Helper functions
function readCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

function queryString(parameter) { 
  var loc = location.search.substring(1, location.search.length);
  var param_value = false;

  var params = loc.split("&");
  for (i=0; i<params.length;i++) {
      param_name = params[i].substring(0,params[i].indexOf('='));
      if (param_name == parameter) {
          param_value = params[i].substring(params[i].indexOf('=')+1)
      }
  }
  if (param_value) {
      return param_value;
  }
  else {
      return false; //Here determine return if no parameter is found
  }
}

function URLDecode(encodedString) {
  var output = encodedString;
  var binVal, thisString;
  var myregexp = /(%[^%]{2})/;
  while ((match = myregexp.exec(output)) != null
             && match.length > 1
             && match[1] != '') {
    binVal = parseInt(match[1].substr(1),16);
    thisString = String.fromCharCode(binVal);
    output = output.replace(match[1], thisString);
  }
  return output.replace("+", " ");
}
