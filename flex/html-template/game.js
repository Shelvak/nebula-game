var developmentAuthToken = "0000000000000000000000000000000000000000000000000000000000000000";
var developmentServers = ["", "localhost", "spacegame.busiu.lt"];

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

// Call me to know what to do.
function getGameOptions() {
  var server = queryString('server');
  var combatLogId = queryString('combat_log_id');
  var playerId = queryString('player_id');
  var galaxyId = readCookie('galaxy_id');
  var authToken = readCookie('auth_token');

  // dev mode
  if (! galaxyId) galaxyId = queryString('galaxy_id');
  if (! authToken) authToken = queryString('auth_token');

  // Let's show us some combat!
  if (combatLogId) {
    document.title = "Combat Replay (Nebula 44)";
    return {mode: 'combatLog', server: server, logId: combatLogId, playerId: playerId};
  }
  // Let's play the game!
  else if (authToken) {
    document.title = readCookie('title') + " (Nebula 44)";
    return {mode: 'game', galaxyId: galaxyId, server: server, 
      authToken: authToken};
  }
  // Allow for quick launch in dev mode
  else if (isDevelopmentMode()) {
    document.title = "Dev Mode (Nebula 44)";
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

