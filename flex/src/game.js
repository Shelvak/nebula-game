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
  },
  clientError: {
    title: function(locale) {
      if (locale == "lt") return "Nebula 44 įvyko kritinė klaida!";
      return "Nebula 44 has encountered a fatal error!";
    },
    info: function(locale) {
      if (locale == "lt") return [
        "Informacija apie klaidą bus automatiškai nusiųsta mums. Ją " +
          "peržiūrėję pasistengsime klaidą ištaisyti.",
        "Jeigu gali, parašyk papildomą informaciją - kokius veiksmus darei, " +
          "kokiame ekrane buvai ir t.t. Kartais tokia informacija labai " +
          "padeda išspręsti klaidas :)"
      ];
      return [
        "Details of this error will automatically be sent to our developers. " +
          "It will help them to fix this error and ensure it will never " +
          "bother you again.",
        "It would also help us a lot if you would provide additional " +
          "information: what you were doing in the game, at what screen you " +
          "were looking and so on. Sometimes this info is crucial to solving " +
          "problems. Thanks!"
      ];
    },
    sending: function(locale) {
      if (locale == "lt") return "Siunčiama... Prašome palaukti ;)";
      return "Sending... Please wait a minute ;)";
    },
    sent: function(locale) {
      if (locale == "lt") return "Išsiųsta! Ačiū!";
      return "Sent! Thanks!";
    },
    failed: function(locale) {
      if (locale == "lt")
        return "Išsiųsti nepavyko. Na, gal kitą kartą pavyks...";
      return "Failed. Well, perhaps we'll have better luck next time...";
    },
    label: function(locale) {
      if (locale == "lt") return "Tavo pastabos";
      return "Your note";
    },
    pleaseWait: function(locale) {
      if (locale == "lt") return "Prieš rašant pastabas prašome palaukti, " +
        "kol klaida bus išsiųsta";
      return "Please wait until bug report is sent before writing your notes.";
    },
    noteSent: function(locale) {
      if (locale == "lt") return "Tavo pastaba sėkmingai išsiųsta. Ačiū!";
      return "Your note has been successfully sent. Thanks!";
    },
    submit: function(locale) {
      if (locale == "lt") return "Siųsti";
      return "Send";
    }
  },
  clientNotResponding: {
    title: function(locale) {
       if (locale == "lt") return "Tavo kompiuteris nesusitvarkė su apkrova!";
       return "Your computer couldn't handle the load!";
    },
    reload: function(locale) {
       if (locale == "lt") return "Perkrauti puslapį";
       return "Reload now";
    },
    message: function(locale) {
       if (locale == "lt") return [
          "Labai gaila, tačiau tavo kompiuteris buvo per lėtas ir nespėjo " +
             "atlikti užduoties laiku.",
          "Norint išvengti tolimesnių nesklandumų, žaidimas turi būti perkrautas."
       ];
       return [
          "Unfortunately your computer was too slow and couldn't process " +
            "those numbers in time",
          "To prevent further issues Nebula 44 has to be reloaded."
       ];
    }
  }
} // }}}

// http://code.google.com/p/jshashtable/
var Hashtable=(function(){var p="function";var n=(typeof Array.prototype.splice==p)?function(s,r){s.splice(r,1)}:function(u,t){var s,v,r;if(t===u.length-1){u.length=t}else{s=u.slice(t+1);u.length=t;for(v=0,r=s.length;v<r;++v){u[t+v]=s[v]}}};function a(t){var r;if(typeof t=="string"){return t}else{if(typeof t.hashCode==p){r=t.hashCode();return(typeof r=="string")?r:a(r)}else{if(typeof t.toString==p){return t.toString()}else{try{return String(t)}catch(s){return Object.prototype.toString.call(t)}}}}}function g(r,s){return r.equals(s)}function e(r,s){return(typeof s.equals==p)?s.equals(r):(r===s)}function c(r){return function(s){if(s===null){throw new Error("null is not a valid "+r)}else{if(typeof s=="undefined"){throw new Error(r+" must not be undefined")}}}}var q=c("key"),l=c("value");function d(u,s,t,r){this[0]=u;this.entries=[];this.addEntry(s,t);if(r!==null){this.getEqualityFunction=function(){return r}}}var h=0,j=1,f=2;function o(r){return function(t){var s=this.entries.length,v,u=this.getEqualityFunction(t);while(s--){v=this.entries[s];if(u(t,v[0])){switch(r){case h:return true;case j:return v;case f:return[s,v[1]]}}}return false}}function k(r){return function(u){var v=u.length;for(var t=0,s=this.entries.length;t<s;++t){u[v+t]=this.entries[t][r]}}}d.prototype={getEqualityFunction:function(r){return(typeof r.equals==p)?g:e},getEntryForKey:o(j),getEntryAndIndexForKey:o(f),removeEntryForKey:function(s){var r=this.getEntryAndIndexForKey(s);if(r){n(this.entries,r[0]);return r[1]}return null},addEntry:function(r,s){this.entries[this.entries.length]=[r,s]},keys:k(0),values:k(1),getEntries:function(s){var u=s.length;for(var t=0,r=this.entries.length;t<r;++t){s[u+t]=this.entries[t].slice(0)}},containsKey:o(h),containsValue:function(s){var r=this.entries.length;while(r--){if(s===this.entries[r][1]){return true}}return false}};function m(s,t){var r=s.length,u;while(r--){u=s[r];if(t===u[0]){return r}}return null}function i(r,s){var t=r[s];return(t&&(t instanceof d))?t:null}function b(t,r){var w=this;var v=[];var u={};var x=(typeof t==p)?t:a;var s=(typeof r==p)?r:null;this.put=function(B,C){q(B);l(C);var D=x(B),E,A,z=null;E=i(u,D);if(E){A=E.getEntryForKey(B);if(A){z=A[1];A[1]=C}else{E.addEntry(B,C)}}else{E=new d(D,B,C,s);v[v.length]=E;u[D]=E}return z};this.get=function(A){q(A);var B=x(A);var C=i(u,B);if(C){var z=C.getEntryForKey(A);if(z){return z[1]}}return null};this.containsKey=function(A){q(A);var z=x(A);var B=i(u,z);return B?B.containsKey(A):false};this.containsValue=function(A){l(A);var z=v.length;while(z--){if(v[z].containsValue(A)){return true}}return false};this.clear=function(){v.length=0;u={}};this.isEmpty=function(){return !v.length};var y=function(z){return function(){var A=[],B=v.length;while(B--){v[B][z](A)}return A}};this.keys=y("keys");this.values=y("values");this.entries=y("getEntries");this.remove=function(B){q(B);var C=x(B),z,A=null;var D=i(u,C);if(D){A=D.removeEntryForKey(B);if(A!==null){if(!D.entries.length){z=m(v,C);n(v,z);delete u[C]}}}return A};this.size=function(){var A=0,z=v.length;while(z--){A+=v[z].entries.length}return A};this.each=function(C){var z=w.entries(),A=z.length,B;while(A--){B=z[A];C(B[0],B[1])}};this.putAll=function(H,C){var B=H.entries();var E,F,D,z,A=B.length;var G=(typeof C==p);while(A--){E=B[A];F=E[0];D=E[1];if(G&&(z=w.get(F))){D=C(F,z,D)}w.put(F,D)}};this.clone=function(){var z=new b(t,r);z.putAll(w);return z}}return b})();

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

document.title = locales.loadingTitle(locale);

var windowTitles = new Hashtable();
windowTitles.currentTitleIndex = -1;
windowTitles.KeyMain = "000main";
windowTitles.KeyNotifications = "001notifications";
windowTitles.KeyAllianceMsgs = "002allianceMsgs";
windowTitles.KeyPrivateMsgs = "003privateMsgs";

// Run a timer that changes window titles.
windowTitles.changerId = setInterval(function() {
  if (windowTitles.size() != 0) {
    var keys = windowTitles.keys().sort();
    windowTitles.currentTitleIndex += 1;
    if (windowTitles.currentTitleIndex >= keys.length)
      windowTitles.currentTitleIndex = 0;

    var key = keys[windowTitles.currentTitleIndex];
    document.title = windowTitles.get(key);
  }
}, 1000);

// Call me when notifications window is opened.
function notificationsOpened() { // {{{
  windowTitles.remove(windowTitles.KeyNotifications);
} // }}}

// Call me when we have unread notifications.
function setUnreadNotifications(title) { // {{{
  windowTitles.put(windowTitles.KeyNotifications, title);
} // }}}

// Call me when alliance channel has unread messages.
function allianceChannelHasMessages(title) {
  windowTitles.put(windowTitles.KeyAllianceMsgs, title);
}

// Call me when alliance channel is opened.
function allianceChannelRead() {
  windowTitles.remove(windowTitles.KeyAllianceMsgs);
}

// Call me when player has unread private messages.
function unreadPrivateMessages(title) {
  windowTitles.put(windowTitles.KeyPrivateMsgs, title);
}

// Call me when player has read all his private messages.
function privateMessagesRead() {
  windowTitles.remove(windowTitles.KeyPrivateMsgs);
}

function missingParam(name) {
  window.alert("Missing query parameter: " + name);
}

// Is google analytics enabled?
function gaEnabled() {
  return ! inLocalComputer() && ! inDeveloperMode() && ! defined(combatLogId) &&
    ! defined(planetMapEditor);
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

      windowTitles.put(
        windowTitles.KeyMain,
        "Local Planet Map Editor Dev Mode" + titleSuffix
      );
    }
    else {
      if (defined(server) && defined(locale) && defined(webHost) &&
          defined(assetsUrl)) {
        windowTitles.put(
          windowTitles.KeyMain,
          locales.planetEditorTitle(locale) + titleSuffix
        );
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
      windowTitles.put(
        windowTitles.KeyMain,
        locales.combatReplayTitle(locale) + titleSuffix
      );
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


      windowTitles.put(
        windowTitles.KeyMain,
        "Local Dev Mode" + titleSuffix
      );
    }
    else {
      if (defined(server) && defined(webPlayerId) && defined(serverPlayerId) &&
          defined(locale) && defined(webHost) && defined(assetsUrl) &&
          defined(title)) {
        windowTitles.put(windowTitles.KeyMain, title + titleSuffix);
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
  setLeaveHandler(false);
  window.alert(locales.failedAuth(locale));
  window.location = "http://" + webHost;
}

// Called when client version is too old.
function versionTooOld(requiredVersion, currentVersion) {
  // Remove leave confirmation.
  setLeaveHandler(false);
  window.alert(locales.versionTooOld(locale, requiredVersion, currentVersion));
  window.location.reload();
}

// Yield name and id to given f for each google analytics account.
function eachGaAccount(f) {
  $.each(gaAccountIds, function(index, account) {
    var name = account[0];
    var id = account[1];
    f(name, id);
  });
}

// Called when player successfully logs in into server.
function loginSuccessful() {
  if (gaEnabled())
    eachGaAccount(function(name, id) {
      _gaq.push(
        [name + '._trackPageview', '/play/' + playerType + '/game/login']
      );
    });
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
if (gaEnabled()) {
  eachGaAccount(function(name, id) {
    _gaq.push(
      [name + '._setAccount', id],
      [name + '._trackPageview', '/play/' + playerType + '/game/opened']
    );
  });
  include("http://www.google-analytics.com/ga.js", 'async="true"');
}
// }}}

// Called from flash when page refresh is needed.
function refresh() {
  setLeaveHandler(false);
  window.location.reload();
}

// Called from flash when it crashes.
function clientError(summary, description, body) {
  // Remove flash client to stop it.
  $('#' + appName).remove();

  if (inLocalComputer() || inDeveloperMode()) {
    crashLocal(summary, description, body);
  }
  else {
    crashRemote(summary, description, body)
  }
}

// Called from flash when it crashes without stacktrace and with error
// 1502 or 1503.
function clientNotResponding() {
  // Remove flash client to stop it.
  $('#' + appName).remove();
  setLeaveHandler(false);

  var strings = locales.clientNotResponding;
  $("#client-not-responding h2").html(strings.title(locale));
  $("#client-not-responding-message").html(strings.message(locale).join("<br/>"));
   $("#client-not-responding a").html(strings.reload(locale));
  $("#client-not-responding").show();

  var secondsToWait = 10;
  var timerId = setInterval(
    function() {
      if (secondsToWait == 0) {
        clearInterval(timerId);
        refresh();
      }
      else {
        $("#time-until-reload").html(secondsToWait);
        secondsToWait--;
      }
    }, 1000
  );
}

function crashLocal(summary, description, body) {
  setLeaveHandler(false);
  $("#client-error").remove();
  var error = $('<div/>', {style: "margin: 10px"});

  $('<h1/>', {text: summary}).appendTo(error);
  $('<h2/>', {text: "Description"}).appendTo(error);
  $('<pre/>', {text: description}).appendTo(error);
  $('<h2/>', {text: "Body"}).appendTo(error);
  $('<pre/>', {text: body}).appendTo(error);

  error.appendTo($("body"));
}

function crashRemote(summary, description, body) {
  // Ensure player does not turn off window while request is being sent.
  setLeaveHandler(true);

  var ce = locales.clientError;

  // Set up error message labels.
  $("#client-error h1").html(ce.title(locale));
  window.noteHolder = $('#client-error #submit-note-holder');
  window.noteLabel = $('#client-error label');
  noteLabel.html(ce.pleaseWait(locale));
  $('#client-error input[type="submit"]').attr('value', ce.submit(locale));;

  var explanation = $("#client-error .content");
  $.each(ce.info(locale), function(index, text) {
    var p = $('<p/>', {text: text});
    p.appendTo(explanation);
  });

  window.ajaxStatus = $("#client-error #ajax-status");
  ajaxStatus.html(ce.sending(locale));

  // Register handler for custom note form.
  $('#client-error form').submit(onNoteSubmit);
  window.errorSummary = summary;
  window.errorDescription = description;

  // Show error message.
  $("#client-error").show();

  // Append window URL to know which game version player is running.
  description = "Assets URL: " + assetsUrl + "\n" +
    "Server URL: " + server + "\n\n" + description;
  body = "Window URL: " + window.location.href + "\n\n" + body;
  $.ajax({
    url: 'http://' + webHost + '/client/add_issue',
    type: 'POST',
    dataType: 'script',
    data: {
      summary: summary,
      error_description: description,
      error_body: body,
      tag: server
    }
  }).done(function() {
    ajaxStatus.html(ce.sent(locale));
  }).fail(function() {
    ajaxStatus.html(ce.failed(locale));
  }).always(function() {
    setLeaveHandler(false);
    noteLabel.html(ce.label(locale));
    noteHolder.show();
  });
}

// Called when player submits custom note.
function onNoteSubmit() {
  setLeaveHandler(true);
  var ce = locales.clientError;

  var textarea = $('#client-error textarea');
  var note = $.trim(textarea.val());
  if (note == "") return false;

  ajaxStatus.html(ce.sending(locale));

  $.ajax({
    url: 'http://' + webHost + '/client/add_note',
    type: 'POST',
    dataType: "script",
    data: {
      summary: errorSummary,
      error_description: errorDescription,
      note: note
    }
  }).done(function() {
    ajaxStatus.html(ce.sent(locale));
    noteLabel.html(ce.noteSent(locale));
    noteHolder.hide();
    // Prevent value from persisting across refreshs. Yeah, it does that if you
    // don't clean it manually.
    textarea.val("");
  }).fail(function() {
    ajaxStatus.html(ce.failed(locale));
  }).always(function() {
    setLeaveHandler(false);
  });

  return false;
}

// Setup one.lt top bar shown
function setupOneLtBar() {
  $("body").prepend("<div id='eads_menu_1' style='height: 40px'></div>");
  var eads = document.createElement('script');
  eads.type = 'text/javascript';
  eads.async = true;
  eads.src = 'http://ib.eads.lt/public/menu/get/?id=1';
  $("body").append(eads);
  $("#flashContent").wrap(
    "<div style='position: absolute; top: 40px; bottom: 0px; left: 0px; " +
    "right: 0px;' />"
  );
}

function openTrialRegistration() {
  $("#trial_register").load("http://n44.lh", function() {
      var container = $(this);
      container.dialog({
          modal: true
      })
      .find("form").submit(function() {
          container.dialog("close");
          return false;
      });
  });
}


// Load our swf {{{
$(document).ready(function() {
  // One.lt top banner.
  if (urlParams["one_lt"] == "true") setupOneLtBar();

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
