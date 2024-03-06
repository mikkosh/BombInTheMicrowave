import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Lang;

class SplashView extends WatchUi.View {

    private var _t as Timer.Timer?; // ? accepts null values
    private var showText as Boolean = false;

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
        _t.start(method(:goForward), 2000, true); // set a timer to call goForward
    }

    function onUpdate(dc) as Void {
        View.onUpdate(dc);
        dc.drawScaledBitmap(0, 0, dc.getWidth(), dc.getHeight(), WatchUi.loadResource(Rez.Drawables.splashComic));
        if(showText) {
           _drawText(dc);
        }
    }

    // On first run, show the texts, on next take the app to another screen, remove splash from the view stack
    public function goForward() as Void {
        if(showText == false) {
            showText = true;
            WatchUi.requestUpdate();
            return;
        }
        _t.stop();
        _t = null;
        WatchUi.switchToView(new MainView(), new MainDelegate(), SLIDE_BLINK);
    }

    private function _drawText(dc) {
        dc.setColor(Graphics.COLOR_WHITE,Graphics.COLOR_BLACK);
        dc.drawText(dc.getWidth()/2,dc.getHeight()*.4,
                    Graphics.FONT_TINY,
                    " BOMB ",
                    Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER
                    );
        dc.drawText(dc.getWidth()/2,dc.getHeight()/2,
                    Graphics.FONT_XTINY,
                    " in the ",
                    Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER
                    );

        dc.drawText(dc.getWidth()/2,dc.getHeight()*.6,
                    Graphics.FONT_TINY,
                    " MICROWAVE ",
                    Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER
                    );
    }
}
