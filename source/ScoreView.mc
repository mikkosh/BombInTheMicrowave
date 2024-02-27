import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Timer;

class ScoreView extends WatchUi.View {

    private var refreshTimer as Timer.Timer?;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.ScoreLayout(dc));
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

        // Draw our own stuff over the layout
        var m = getApp().getModel();
        var scores = m.getHighScores();
       
        var dcH = dc.getHeight();
        var dcW = dc.getWidth();

        // determine where to start drawing our table with a known layout element
        var startY = 0; 
        var titleElement = findDrawableById("scoresTitle") as WatchUi.Text;
        if(null != titleElement) {
            startY = titleElement.locY + titleElement.height + 0;
        }
        // draw handles and scores in two columns
        var colFirstX = dcW * 0.25;
        var colSecondX = dcW * 0.75;

        var fnt = Graphics.FONT_XTINY;
        var fntHeight = dc.getFontHeight(fnt);
        var items = 10;
        var rowHeight = fntHeight+1;

        for(var i=0; i<items; i++) {
            var rHandle = "aaa";
            var rScore = 0;
            if(i+1 <= scores.size()) {
                rHandle = scores[i][0];
                rScore = scores[i][1];
            }
            dc.drawText(colFirstX, startY+i*rowHeight, fnt, rHandle, Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(colSecondX, startY+i*rowHeight, fnt, rScore, Graphics.TEXT_JUSTIFY_RIGHT);
        }
        if(m.isUpdating()) {
            refreshTimer = new Timer.Timer();
            refreshTimer.start(method(:refreshScores), 100, false);
        }
    }

    public function refreshScores() as Void {
        if(null != refreshTimer) {
            refreshTimer.stop();
            refreshTimer = null;
        }
        WatchUi.requestUpdate();
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
