import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Application.Properties;

(:glance, :background)
class GhostfolioforGarminApp extends Application.AppBase {

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
    function getInitialView() as [Views] or [Views, InputDelegates] {

        Settings.update();        

        if (Settings.getEndpoint().length() == 0) {
            return ErrorView.create("Please set the Ghostfolio endpoint URL in the settings.");
        }
        else if (Settings.getSecret().length() == 0) {
            return ErrorView.create("Please set the Ghostfolio secret in the settings.");
        }
        else {

            // Fetch the bearer token.
            fetchBearerToken();        
        
            return [ new GhostfolioforGarminView() ];
        }
    }

    function getGlanceView() {
        return [ new GhostfolioforGarminGlanceView() ];
    }

    (:glance)
    function fetchBearerToken() {
                
        if (! System.getDeviceSettings().phoneConnected) {

            // if (mIsGlance) {
            //     WatchUi.requestUpdate();
            // } else {
                ErrorView.show("No phone connection.");
            // }
        } else if (! System.getDeviceSettings().connectionAvailable) {
            // if (mIsGlance) {
                // WatchUi.requestUpdate();
            // } else {
                ErrorView.show("No internet connection.");
            // }
        } else {

            Communications.makeWebRequest(
                Settings.getEndpoint() + "/api/v1/auth/anonymous/" + Settings.getSecret(),
                null,
                {
                    :method       => Communications.HTTP_REQUEST_METHOD_GET,
                    :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
                },
                method(:onReturnFetchBearerToken)
            );
        }
    }

    // Callback function after completing the GET request to fetch the API status.
    //
    (:glance)
    function onReturnFetchBearerToken(responseCode as Lang.Number, data as Null or Lang.Dictionary or Lang.String) as Void {
        System.println("onReturnFetchBearerToken: " + responseCode);
        switch (responseCode) {           
            case 200:
                var bearerToken = data.get("authToken") as Lang.String;
                Settings.setBearerToken(bearerToken);
                break;

            default:
                System.println("An error occurred: " + responseCode);
                ErrorView.show("An error occurred: " + responseCode);                
        }

        WatchUi.requestUpdate();
    }
}

(:glance, :background)
function getApp() as GhostfolioforGarminApp {
    return Application.getApp() as GhostfolioforGarminApp;
}
