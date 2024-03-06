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
        setLayout(Rez.Layouts.ResultLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        
        var rndScore = _model.timeToScore(_resultTime);
        var rating = "";
        if(_resultTime < 0) {
            rating = "Bomb exploded!!";
        } else if(rndScore >= 500){
            rating = "Excellent job!";
        }else if(rndScore >= 100){
            rating = "Good job!";
        }else if(rndScore >= 50){
            rating = "Bit too fast!";
        } else {
            rating = "Could do better!";
        }

        (findDrawableById("rating") as WatchUi.Text).setText(rating);
        
        var ptsTxt = WatchUi.loadResource(Rez.Strings.Points) as String;
        (findDrawableById("pointText") as WatchUi.Text).setText(rndScore.toString()+" "+ptsTxt);;
        
        
        var totalScore = _model.getScore();
        (findDrawableById("totalPointLabel") as WatchUi.Text).setText(totalScore.toString());

        if(_model.isGameOver())  {
            (findDrawableById("gameOverLabel") as WatchUi.Text).setText("Game Over");

            if(_model.isHighScore(totalScore)) {
                (findDrawableById("highScoreLabel") as WatchUi.Text).setText("Highscore!!");
            }
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
