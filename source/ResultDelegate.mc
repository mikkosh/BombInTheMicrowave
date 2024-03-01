import Toybox.Lang;
import Toybox.WatchUi;

class ResultDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    
    public function onBack() as Boolean{
        var _m = getApp().getModel();
        if(!_m.isGameOver()) {
            WatchUi.switchToView(new GameView(), new GameDelegate(), SLIDE_LEFT);
        } else {
            // save the score here
            var totalScore = _m.getScore();
            if(_m.isHighScore(totalScore)) {
                WatchUi.pushView(new WatchUi.TextPicker(_m.getHandle()), new HighScorePickerDelegate(totalScore), WatchUi.SLIDE_LEFT);
                // 
            } else {
                WatchUi.popView(SLIDE_RIGHT); // pop to main menu
            }
            
        }
        return true;
    }
}