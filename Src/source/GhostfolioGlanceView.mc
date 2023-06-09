import Toybox.Graphics;
import Toybox.WatchUi;

(:glance)
class GhostfolioGlanceView extends WatchUi.GlanceView {

    hidden var mainview;

    function initialize(view) {
        GlanceView.initialize();
        mainview = view;
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
