import Toybox.Lang;
import Toybox.System;
import Toybox.Communications;
import Toybox.Application.Storage;
import Toybox.Timer;

/**
 * Model for the game and application logic
 */
class GameModel {

    private var _highScores as Array;
    private const STORAGE_HIGH_SCORES = "cache_high_scores";
    private var _isUpdating as Boolean = false; // indicates if we're currently updating data
    private var _gameTimer as Timer.Timer;
    private var _time as Number = 0;
    private const _timeStep as Number = 50;
    private var _countDown = 5;
    private var _gameEventCallback as Method(e as GameEvent)?;

    private var _roundsLeft as Number = 3;
    private var _totalRounds as Number = 3;
    private var _roundScore as Number = 0;

    private var _handle as String = "PLR1";

    function initialize() {
        _gameTimer = new Timer.Timer();
        _highScores = _getCachedHighScores();

        _downloadHighScores();

        // for testing : 
        // uploadHighScore("ciqman2",116);
    }

    public function newGame() as Void {
        _roundsLeft = 3;
        _roundScore = 0;
    }
    public function getRound() as Number {
        return _totalRounds - _roundsLeft;
    }
    public function isGameOver() as Boolean {
        return _roundsLeft == 0;
    }

    public function timeToScore(time as Number) as Number {
        
        if(time < 0) { // no scores for the busted
            return 0;
        } else if(time == 0) { // jackpot
            return 1000;
        } else if (time <= 50) {
            return 500;
        } else if (time <= 100){
            return 100;
        } else if (time <= 150){
            return 50;
        }
        return 0;
    }

    public function addScore(score as Number) as Void{
        _roundScore += score;
    }

    public function getScore() as Number {
        return _roundScore;
    }

    public function getHandle() as String {
        return _handle;
    }

    public function setHandle(handle as String) as Void {
        _handle = handle;
    }

    public function startRound(eventCallback as Method(e as GameEvent)) as Void {
        _roundsLeft--;

        _time = 5000;
        _countDown = (_time / 1000) as Number;
        _gameEventCallback = eventCallback;
        _gameTimer.start(method(:timerCallback), _timeStep, true);
    }
    public function timerCallback() as Void {
        _time -= _timeStep;
         if(_time < 0) {
            var e = new GameEvent(GameEvent.BUSTED, {}); 
            _roundsLeft = 0; // busted means game over
            _gameEventCallback.invoke(e);
            _gameTimer.stop();
        } else if (_time%1000 < _timeStep){
            System.println(_time);
            _countDown--;
            var e = new GameEvent(GameEvent.COUNTDOWN, {:countDown => _countDown}); 
            _gameEventCallback.invoke(e);
        }
    }

    public function disarmMicroWave() {
        _gameTimer.stop();
        var e;
        if(_time < 0) {
            e = new GameEvent(GameEvent.BUSTED, {});
        } else {
            e = new GameEvent(GameEvent.STOPPED, {:time => _time});
        }
        _gameEventCallback.invoke(e);
    }

    public function getHighScores() as Array {
        return _highScores;
    }

    public function isUpdating() as Boolean {
        return _isUpdating;
    }

    private function _getCachedHighScores() as Array {
        var val = Storage.getValue(STORAGE_HIGH_SCORES);
        if(null == val) {
            val = [];
            Storage.setValue(STORAGE_HIGH_SCORES, val);
        }
        return val as Array;
    }

    private function _downloadHighScores() as Void {
        _isUpdating = true;    
        // the full url is: http://localhost:8080/jsonapi/node/highscore?sort=-field_score&page%5Blimit%5D=10
        var url = "http://localhost:8080/jsonapi/node/highscore"; 

        
        var params = { 
            "sort" => "-field_score",
            "page[limit]" => 10
        };

        var options = {                                             
            :method => Communications.HTTP_REQUEST_METHOD_GET,     
            :headers => {"Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED},
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };
        Communications.makeWebRequest(url, params, options, method(:onDataReceive));
    }

    public function onDataReceive(responseCode as Number, data as Dictionary?) as Void {
        _isUpdating = false;
        if (responseCode == 200 && data != null) {
            _highScores = _parseHighScores(data);
            Storage.setValue(STORAGE_HIGH_SCORES, _highScores);
        } else {
            System.println("Error Response: " + responseCode); // print response code
        }
    }

    (:typecheck(false)) // this is (more than) properly typechecked but still gives a warning - so to keep the messages clean
    private function _parseHighScores(data as {"data" as {
        "attributes" as {
            "title" as String, 
            "field_score" as Number
        }}}) as Array {

        var highScores = [];
        if(data.hasKey("data")) {
            var d = data["data"] as Array;
            for (var i = 0; i < d.size(); i++) {
                var r = d[i];
                if( r.hasKey("attributes") && 
                    r["attributes"].hasKey("title") &&
                    r["attributes"].hasKey("field_score")
                ) {
                    highScores.add([r["attributes"]["title"], r["attributes"]["field_score"]]); 
                }
            }
        }
        return highScores;
    }

    public function isHighScore(score) {
        var isHighScore = false;
        for(var i=0; i < _highScores.size(); i++) {
            // score is a high score if it's higher than any score on the current list
            if(score > _highScores[i][1]) {
                isHighScore = true;
            }
        }
        return isHighScore;
    }

    public function uploadHighScore(handle as String, score as Number) {
        _isUpdating = true;
        var url = "http://localhost:8080/node/?_format=json"; 
        
        var params = { 
            "title" => [{"value"=>handle}],
            "field_score" => [{"value"=>score}],
            "type" => [{"target_id"=>"highscore"}]
        };

        var options = {                                             
            :method => Communications.HTTP_REQUEST_METHOD_POST,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON,
                "Authorization" => "Basic YXBpOmFwaQ=="
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };
        Communications.makeWebRequest(url, params, options, method(:onHighScoreUploaded));
    }
    public function onHighScoreUploaded(responseCode as Number, data as Dictionary?) as Void {
        _isUpdating = false;
        System.println("onHighScoreUploaded");
        System.println("Response code "+responseCode);
        System.println(data);
        _downloadHighScores();
        return;

    }
}