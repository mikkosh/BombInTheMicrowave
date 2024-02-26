import Toybox.Lang;
import Toybox.WatchUi;

class BombInTheMicrowaveDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new BombInTheMicrowaveMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}