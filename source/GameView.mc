import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Timer;

class GameView extends WatchUi.View {

    private var _model as GameModel;
    private var _exitTimer as Timer.Timer;

    private enum State {
        STATE_NOT_STARTED,
        STATE_COUNTDOWN,
        STATE_END_STOPPED,
        STATE_END_BUSTED
    }
    private var _gameState as State = STATE_NOT_STARTED;
    private var _lastEvent as GameEvent?;

    function initialize() {
        View.initialize();
        _model = getApp().getModel();
        _exitTimer = new Timer.Timer();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        //setLayout(Rez.Layouts.MainScreenLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        _model.startRound(method(:eventCallback));
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        dc.setColor(Graphics.COLOR_WHITE,Graphics.COLOR_TRANSPARENT);

        dc.drawText(10,20,Graphics.FONT_MEDIUM,"Round "+_model.getRound(),Graphics.TEXT_JUSTIFY_LEFT);

        if(_gameState == STATE_NOT_STARTED) {

            dc.drawText(10,100,Graphics.FONT_MEDIUM,"not started",Graphics.TEXT_JUSTIFY_LEFT);

        } else if(_gameState == STATE_COUNTDOWN) {
            var cdNro = 0;
            if(null != _lastEvent) {
                cdNro = _lastEvent.getData()[:countDown];
            }
            dc.drawText(10,100,Graphics.FONT_MEDIUM,"countdown: "+cdNro,Graphics.TEXT_JUSTIFY_LEFT);
            
        } else if(_gameState == STATE_END_STOPPED) {
            var time = 99999;
            if(null != _lastEvent) {
                time = _lastEvent.getData()[:time];
            }
            dc.drawText(10,100,Graphics.FONT_MEDIUM,"Disarmed at",Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(10,150,Graphics.FONT_MEDIUM,time,Graphics.TEXT_JUSTIFY_LEFT);

            _exitTimer.start(method(:exitTo), 1000, false);
            
        } else if(_gameState == STATE_END_BUSTED) {
            
            dc.drawText(10,100,Graphics.FONT_MEDIUM,"busted!!!",Graphics.TEXT_JUSTIFY_LEFT);
            _exitTimer.start(method(:exitTo), 1000, false);
        }

    }

    public function eventCallback(e as GameEvent) as Void {
        _lastEvent = e;
        if(e.getType() == GameEvent.BUSTED) {

            _gameState = STATE_END_BUSTED;

        } else if (e.getType() == GameEvent.COUNTDOWN) {
            
            _gameState = STATE_COUNTDOWN;

        } else if (e.getType() == GameEvent.STOPPED) {
            
            _gameState = STATE_END_STOPPED;
            var time = e.getData()[:time];
            var rndScore = _model.timeToScore(time);
             _model.addScore(rndScore);
        }
        WatchUi.requestUpdate();
    }

    public function exitTo() as Void {
        _exitTimer.stop();
        var time = -1;
        if(_gameState == STATE_END_STOPPED && _lastEvent != null) {
            time = _lastEvent.getData()[:time];
        }
        WatchUi.switchToView(new ResultView(time), new ResultDelegate(), WatchUi.SLIDE_LEFT);
    } 

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
