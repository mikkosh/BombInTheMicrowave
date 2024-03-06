import Toybox.Lang;
import Toybox.WatchUi;
class HighScorePickerDelegate extends WatchUi.TextPickerDelegate {
    private var _score as Number = 0;
    function initialize(score) {
        TextPickerDelegate.initialize();
        _score = score;
    }

    function onTextEntered(handle, changed) as Boolean {
        
        var _m = getApp().getModel();
        _m.setHandle(handle);
        _m.uploadHighScore(handle, _score);

        // WatchUi.popView(SLIDE_RIGHT); // this view is popped automatically
        WatchUi.popView(SLIDE_RIGHT); // pop the result view and get to the main screen
        return true;
    }

}