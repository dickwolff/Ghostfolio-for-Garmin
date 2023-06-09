import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

(:background)
class GhostfolioApp extends Application.AppBase {

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
    function checkPortfolio() {
        System.print("checkPortfolio()");
    }
}

function getApp() as GhostfolioApp {
    return Application.getApp() as GhostfolioApp;
}