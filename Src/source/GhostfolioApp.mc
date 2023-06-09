import Toybox.Lang;
import Toybox.System;
using Toybox.WatchUi as Ui;
using Toybox.Application as App;

(:background)
class GhostfolioApp extends App.AppBase {

    hidden var view;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {


    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() {
        view = new GhostfolioView();
        onSettingsChanged();
        return [ view ];
    }

    function getGlanceView() {
        return [ new GhostfolioGlanceView() ];
    }

    (:background_method)
    function getServiceDelegate() {
        return [ new GhostfolioBackgroundService() ];
    }

    (:background_method)
    function onBackgroundData(data) {

		var pendingWebRequests = App.Properties.getValue("PendingWebRequests");
		if (pendingWebRequests == null) {
			pendingWebRequests = {};
		}

        var type = data.keys()[0];
        var receivedData = data[type];

        App.Properties.setValue("PendingWebRequests", null);
        App.Properties.setValue(type, receivedData);

        Ui.requestUpdate();
    }
}

function getApp() as GhostfolioApp {
    return App.getApp() as GhostfolioApp;
}