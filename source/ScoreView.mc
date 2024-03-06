import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Lang;

class ScoreView extends WatchUi.View {

    private var refreshTimer as Timer.Timer?;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
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

        var headingY = dcH*0.1;
        var headingFont = Graphics.FONT_MEDIUM;
        var scoresStart = headingY+dc.getFontHeight(headingFont);

        _drawNiceBackground(dc, scoresStart);

        var title = WatchUi.loadResource(Rez.Strings.ScoresTitle) as String;
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dcW/2+5, headingY+5, headingFont, title, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dcW/2, headingY, headingFont, title, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
       
        
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
            dc.drawText(colFirstX, scoresStart+i*rowHeight, fnt, rHandle, Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(colSecondX, scoresStart+i*rowHeight, fnt, rScore, Graphics.TEXT_JUSTIFY_RIGHT);
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

    private function _drawNiceBackground(dc, firstLineY) {
       
        var rectY = firstLineY-5;
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(dc.getWidth()*0.2, rectY, dc.getWidth()*0.6, dc.getHeight()-30, 10);
        dc.setPenWidth(2);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(dc.getWidth()*0.2, rectY, dc.getWidth()*0.6, dc.getHeight()-30, 10);
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawRoundedRectangle(dc.getWidth()*0.2+3, rectY+3, dc.getWidth()*0.6-6, dc.getHeight()-30-6, 10);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
