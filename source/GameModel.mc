import Toybox.Lang;
import Toybox.System;
import Toybox.Communications;
import Toybox.Application.Storage;

/**
 * Model for the game and application logic
 */
class GameModel {

    private var _highScores as Array;
    private const STORAGE_HIGH_SCORES = "cache_high_scores";
    private var _isUpdating as Boolean = false; // indicates if we're currently updating data

    function initialize() {
        _highScores = _getCachedHighScores();

        _downloadHighScores();

        // for testing : 
        // uploadHighScore("ciqman2",116);
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