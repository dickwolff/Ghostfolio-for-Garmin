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
        
        System.println("Initializing background service.");

        ghostfolioUrl = App.Properties.getValue("GhostfolioEndpointUrl");
        ghostFolioSecret = App.Properties.getValue("GhostfolioSecret");
    }

    (:background_method)
    function onTemporalEvent() { 
        System.println("onTemporalEvent");

        if (ghostfolioBearer == null) {
            getAuthToken();
        }

        var pendingWebRequests = App.getApp().getProperty("PendingWebRequests") as Dictionary<String, Object or Null>;
        if (pendingWebRequests != null) {
System.println(pendingWebRequests);
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

    function onReceive(responseCode as Lang.Number, data as Null or Lang.Dictionary or Lang.String) as Void {
        if (responseCode == 200) {
            System.println("Request Successful"); // print success


            //****** The following println throws "Failed invoking <symbol>"


            System.println("bg exit: " + data);
            System.println("Exiting background");
            Background.exit(data);
        } else {
            System.println("Response: " + responseCode); // print response code
        }
    }

    (:background_method)
    function getAuthToken() {

        Comms.makeWebRequest(
            "http://192.168.10.25:3333/api/v1/auth/anonymous/1acd6ad84fd181e3c09aa1e261039956c36660f274816f8ad922bef1a307e39d68d1d2fd27194c51e7ea52c7b6daafb66a0ff0bd612b9210506cbdf19056b170", 
            null,
            {
				:method => Communications.HTTP_REQUEST_METHOD_GET,
                :headers => {
                    "Content-Type" => Comms.REQUEST_CONTENT_TYPE_JSON
                },
                :responseType => Comms.HTTP_RESPONSE_CONTENT_TYPE_JSON
            }, 
            method(:onReceive)
        );

        // makeWebRequest(
        //     ghostfolioUrl + "/api/v1/auth/anonymous/" + ghostFolioSecret,
        //     { },
        //     method(:onReceiveAuthToken)
        // );
    }

    (:background_method)
    function onReceiveAuthToken(responseCode, data) {
        System.println("Auth response: " + responseCode);
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
					"Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED 
            },
			:responseType => Comms.HTTP_RESPONSE_CONTENT_TYPE_JSON
		};

        System.println("Make web request.. " + url);
		Comms.makeWebRequest(url, params, options, callback);
    }
}