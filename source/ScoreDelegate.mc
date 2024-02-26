import Toybox.Lang;
import Toybox.WatchUi;

class ScoreDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }
    // up or down, to the main view we go!
    public function onNextPage() as Boolean{
        WatchUi.switchToView(new MainView(), new MainDelegate(), SLIDE_DOWN);
        return true;
    }
    // up or down, to the main view we go!
    public function onPreviousPage() as Boolean{
        WatchUi.switchToView(new MainView(), new MainDelegate(), SLIDE_UP);
        return true;
    }
}