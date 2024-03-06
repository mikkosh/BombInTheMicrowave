import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Timer;

class SplashView extends WatchUi.View {

    private var _t as Timer.Timer?; // ? accepts null values

    function initialize() {
        View.initialize();
    }

    // Here we load the appropriate layout (and other resources if needed)
    function onLayout(dc as Dc) as Void {
        //setLayout(Rez.Layouts.SplashLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        _t = new Timer.Timer();
        _t.start(method(:goForward), 5000, false); // set a timer to call goForward
    }

    function onUpdate(dc) as Void {
        View.onUpdate(dc);
        dc.drawScaledBitmap(0, 0, dc.getWidth(), dc.getHeight(), WatchUi.loadResource(Rez.Drawables.splashComic));
        //dc.drawScaledBitmap(0, 0, dc.getWidth(), dc.getHeight(), WatchUi.loadResource(Rez.Drawables.splashText));
    }

    // Take the app to another screen, remove splash from the view stack
    public function goForward() as Void {
        _t.stop();
        _t = null;
        WatchUi.switchToView(new MainView(), new MainDelegate(), SLIDE_BLINK);
    }
}
