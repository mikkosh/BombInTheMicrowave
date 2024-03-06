import Toybox.Lang;
import Toybox.WatchUi;

class GameDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    public function onSelect() as Boolean{
        var m = getApp().getModel();
        m.disarmMicroWave();
        return true;
    }

    public function onBack() {
        return true; // disable back button
    }
}