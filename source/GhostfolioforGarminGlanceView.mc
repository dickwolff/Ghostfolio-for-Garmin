import Toybox.Graphics;
import Toybox.WatchUi;
using Toybox.Lang;

(:glance)
class GhostfolioforGarminGlanceView extends WatchUi.GlanceView {

    private static const scLeftMargin = 5; // px
    private static const scMidSep     = 10; // Middle Separator "text:_text" in pixels
    private var mAntiAlias  as Lang.Boolean = false;

    private var mTitle      as WatchUi.Text or Null;
    private var miText      as WatchUi.Text or Null;

    function initialize() {
        GlanceView.initialize();
        
        if (Dc has :setAntiAlias) {
            mAntiAlias = true;
        }
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        
        var h  = dc.getHeight();
        //var tw = dc.getTextWidthInPixels(WatchUi.loadResource($.Rez.Strings.GlanceMenu) as Lang.String, Graphics.FONT_XTINY);

        mTitle = new WatchUi.Text({
            :text          => "Ghostfolio",
            :color         => Graphics.COLOR_WHITE,
            :font          => Graphics.FONT_TINY,
            :justification => Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER,
            :locX          => scLeftMargin,
            :locY          => 2 * h / 6
        });
        miText = new WatchUi.Text({
            :text          => "You're up 2.2% today!",
            :color         => Graphics.COLOR_DK_GREEN,
            :font          => Graphics.FONT_XTINY,
            :justification => Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER,
            :locX          => scLeftMargin,
            :locY          => 4 * h / 6
        });
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        GlanceView.onUpdate(dc);
        if (mAntiAlias) {
            dc.setAntiAlias(true);
        }
        dc.setColor(
            Graphics.COLOR_WHITE,
            Graphics.COLOR_TRANSPARENT
        );        
        dc.clear(); 
        
        mTitle.draw(dc);
        miText.draw(dc);
    }
}
