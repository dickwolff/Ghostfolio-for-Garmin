import Toybox.Graphics;
import Toybox.WatchUi;
using Toybox.Application as App;

(:glance)
class GhostfolioGlanceView extends WatchUi.GlanceView {

    function initialize() {
        GlanceView.initialize();

        if (GhostfolioApp has :checkPortfolio) {
            App.getApp().checkPortfolio();
        }
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
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
    }

}
