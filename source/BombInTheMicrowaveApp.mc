import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class BombInTheMicrowaveApp extends Application.AppBase {
    
    private var _model as GameModel;

    function initialize() {
        AppBase.initialize();
        _model = new GameModel();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new SplashView() ] as Array<Views or InputDelegates>; // note, no delegate
    }

    function getModel() as GameModel {
        return _model;
    }
}

function getApp() as BombInTheMicrowaveApp {
    return Application.getApp() as BombInTheMicrowaveApp;
}

