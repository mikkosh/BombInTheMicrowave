import Toybox.Lang;

class GameEvent {
    static enum EventType {
        COUNTDOWN,
        STOPPED,
        BUSTED
    }
    private var _eventType as EventType;
    private var _data as Dictionary;
    public function initialize(eventType as EventType, data as Dictionary){
        _eventType = eventType;
        _data = data;
    }
    public function getType() as EventType {
        return _eventType;
    }
    public function getData() as Dictionary {
        return _data;
    }
}