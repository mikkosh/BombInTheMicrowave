import Toybox.Lang;
import Toybox.WatchUi;

class MainDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    // up or down, to the scores we go!
    public function onNextPage() as Boolean{
        WatchUi.switchToView(new ScoreView(), new ScoreDelegate(), SLIDE_DOWN);
        return true;
    }
    // up or down, to the scores we go!
    public function onPreviousPage() as Boolean{
        WatchUi.switchToView(new ScoreView(), new ScoreDelegate(), SLIDE_UP);
        return true;
    }
    public function onSelect() as Boolean{
        
        // WatchUi.switchToView(new GameView(), new GameDelegate(), SLIDE_LEFT);
        return true;
    }
}