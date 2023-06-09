using Toybox.System as Sys;
using Toybox.Background as Bg;
using Toybox.Application as App;
using Toybox.Communications as Comms;
import Toybox.Lang;

(:background)
class GhostfolioBackgroundService extends Sys.ServiceDelegate {

    hidden var ghostfolioUrl;
    hidden var ghostFolioSecret;
    
    hidden var ghostfolioBearer;

    (:background_method)
    function initialize() {
		Sys.ServiceDelegate.initialize();
        
        ghostfolioUrl = App.Storage.getValue("GhostfolioEndpointUrl");
        ghostFolioSecret = App.Storage.getValue("GhostfolioSecret");

        getAuthToken();
    }

    (:background_method)
    function onTemporalEvent() { 
        var pendingWebRequests = App.getApp().getProperty("PendingWebRequests") as Dictionary<String, Object or Null>;
        if (pendingWebRequests != null) {

            // Get Performance .
            if (pendingWebRequests["PerformanceGlance"] != null) {
                makeWebRequest(
                    ghostfolioUrl + "api/v2/portfolio/performance?range=1d",
                    {
                        "Authorization" => "Bearer " + ghostfolioBearer
                    },
                    method(:onReceivePerformance)
                );
            }
        }
    }

    (:background_method)
    function onReceivePerformance(responseCode, data) {
        Bg.exit({
            "Performance" => data
        });
    }

    (:background_method)
    function getAuthToken() {
        makeWebRequest(
            ghostfolioUrl + "api/v1/auth/anonymous/" + ghostFolioSecret,
            { },
            method(:onReceiveAuthToken)
        );
    }

    (:background_method)
    function onReceiveAuthToken(responseCode, data) {
        ghostfolioBearer = data["authToken"];

        Bg.exit({
            "AuthToken" => ghostfolioBearer
        });
    }
    
    (:background_method)
    function makeWebRequest(url, params, callback) {
        var options = {
			:method => Comms.HTTP_REQUEST_METHOD_GET,
			:headers => {
					"Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED},
			:responseType => Comms.HTTP_RESPONSE_CONTENT_TYPE_JSON
		};

		Comms.makeWebRequest(url, params, options, callback);
    }
}