import Toybox.Lang;
import Toybox.WatchUi;
class HighScorePickerDelegate extends WatchUi.TextPickerDelegate {
    private var _score as Number = 0;
    function initialize(score) {
        TextPickerDelegate.initialize();
        _score = score;
    }

    function onTextEntered(handle, changed) as Boolean {
        //screenMessage = text + "\n" + "Changed: " + changed;
        //lastText = text;
        System.println("GOT TEXT "+handle);
        var _m = getApp().getModel();
        _m.setHandle(handle);
        _m.uploadHighScore(handle, _score);
       // WatchUi.popView(SLIDE_RIGHT); // this view
        WatchUi.popView(SLIDE_RIGHT); // result view
        return true;
    }

}