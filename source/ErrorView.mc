import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class ErrorView extends WatchUi.View {

    private var mText as Lang.String = "";
    private var mTextArea as WatchUi.TextArea or Null;
    
    private var mDelegate as ErrorDelegate;

    private static var instance;
    private static var mShown as Lang.Boolean = false;
     
    function initialize() {
        View.initialize();
        mDelegate = new ErrorDelegate(self);
    }
     // Load your resources here
    function onLayout(dc as Graphics.Dc) as Void {
        var w = dc.getWidth();

        mTextArea = new WatchUi.TextArea({
            :text          => mText,
            :color         => Graphics.COLOR_WHITE,
            :font          => Graphics.FONT_XTINY,
            :justification => Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER,
            :locX          => 0,
            :locY          => 0,
            :width         => w,
            :height        => dc.getHeight()
        });
    }
    
    // Update the view
    function onUpdate(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLUE);
        dc.clear();
        mTextArea.draw(dc);
    }
    
    function getDelegate() as ErrorDelegate {
        return mDelegate;
    }

    static function create(text as Lang.String) as [ WatchUi.Views ] or [ WatchUi.Views, WatchUi.InputDelegates ] {
        if (instance == null) {
            instance = new ErrorView();
        }
        if (!mShown) {
            instance.setText(text);
            mShown = true;
        }
        return [instance, instance.getDelegate()];
    }

      // Create or reuse an existing ErrorView, and pass on the text.
    static function show(text as Lang.String) as Void {
        if (!mShown) {
            create(text); // Ignore returned values
            WatchUi.pushView(instance, instance.getDelegate(), WatchUi.SLIDE_UP);
            mShown = true;
        }
    }

    static function unShow() as Void {
        if (mShown) {
            WatchUi.popView(WatchUi.SLIDE_DOWN);            
            mShown = false;
        }
    }

    
    // Internal show now we're not a static method like 'show()'.
    function setText(text as Lang.String) as Void {
        mText = text;
        if (mTextArea != null) {
            mTextArea.setText(text);
            requestUpdate();
        }
    }
}


class ErrorDelegate extends WatchUi.BehaviorDelegate {

    function initialize(view as ErrorView) {
        WatchUi.BehaviorDelegate.initialize();
    }

    function onBack() as Lang.Boolean {
        ErrorView.unShow();
        return true;
    }
}
