import Toybox.Lang;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as G;
using Toybox.Application as App;

(:glance)
class GhostfolioGlanceView extends Ui.GlanceView {

    function initialize() {
        GlanceView.initialize();

        checkPerformance();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // Update the view
    function onUpdate(dc) as Void {
        // Call the parent onUpdate function to redraw the layout

        dc.setColor(G.COLOR_DK_GREEN, G.COLOR_TRANSPARENT);
        dc.drawText(24, 32, G.FONT_GLANCE, "+0.5%", G.TEXT_JUSTIFY_CENTER);
    }
    
    (:background_method)
    function checkPerformance() {
        App.getApp().setProperty("PendingWebRequests", ["PerformanceGlance"]);
    }  

    (:background_method)
    function onBackgroundData(data as Dictionary<String, Object>) {

		var pendingWebRequests = App.getApp().getProperty("PendingWebRequests") as Dictionary<String, Object or Null>;
		if (pendingWebRequests == null) {
			pendingWebRequests = {};
		}

        if (pendingWebRequests["PortfolioGlance"] != null) {

            // Store data locally.
            var type = data.keys()[0];
            var receivedData = data[type];

            // Clear response.
            pendingWebRequests["PortfolioGlance"] = null;

            // Save properties.
            App.getApp().setProperty("PendingWebRequests", pendingWebRequests);
            App.getApp().setProperty(type, receivedData);

            // Update UI.
            Ui.requestUpdate();
        }
    }
}
