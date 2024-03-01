import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class ResultView extends WatchUi.View {

    private var _resultTime as Number;
    private var _model as GameModel;
    function initialize(resultTime) {
        View.initialize();
        _resultTime = resultTime;
        _model = getApp().getModel();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        //setLayout(Rez.Layouts.MainScreenLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        dc.setColor(Graphics.COLOR_PINK, Graphics.COLOR_TRANSPARENT);


        if(_resultTime < 0) {
            dc.drawText(10,100,Graphics.FONT_MEDIUM,"The bomb exploded, beep beep!",Graphics.TEXT_JUSTIFY_LEFT);
        } else {
            var rndScore = _model.timeToScore(_resultTime);
            // never update model from the view, this will be called multiple times during execution!
            dc.drawText(10,100,Graphics.FONT_MEDIUM,"Good job, you got "+rndScore+" points!",Graphics.TEXT_JUSTIFY_LEFT);
        }

        var totalScore = _model.getScore();
        dc.drawText(10,150,Graphics.FONT_MEDIUM,"Total score "+totalScore,Graphics.TEXT_JUSTIFY_LEFT);
        if(_model.isGameOver())  {
            dc.drawText(10,200,Graphics.FONT_MEDIUM,"Game over",Graphics.TEXT_JUSTIFY_LEFT);
            if(_model.isHighScore(totalScore)) {
                dc.drawText(10,230,Graphics.FONT_MEDIUM,"Highscore!!",Graphics.TEXT_JUSTIFY_LEFT);
            }
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
