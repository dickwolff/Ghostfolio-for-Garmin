

import Toybox.Lang;
import Toybox.Application.Properties;
import Toybox.WatchUi;
import Toybox.System;

(:glance, :background)
class Settings {
    private static var mEndpoint as Lang.String = "";
    private static var mSecret as Lang.String = "";

    private static var mBearerToken as Lang.String = "";

    // Called on application start and then whenever the settings are changed.
    static function update() {    
        mEndpoint = Properties.getValue("GhostfolioEndpointUrl");        
        mSecret = Properties.getValue("GhostfolioSecret");
    }

    static function getEndpoint() as Lang.String {
        return mEndpoint;
    }

    static function getSecret() as Lang.String {
        return mSecret;
    }

    static function getBearerToken() as Lang.String {
        return mBearerToken;
    }

    static function setBearerToken(bearerToken as Lang.String) {
        mBearerToken = bearerToken;
    }

    static function unsetBearerToken() {
        mBearerToken = "";
    }
}
