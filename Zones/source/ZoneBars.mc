using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class ZoneBars extends Ui.Drawable {

	hidden var timeInZone = new [5];
	hidden var colorZones= [Gfx.COLOR_DK_GREEN, Gfx.COLOR_GREEN, Gfx.COLOR_YELLOW, Gfx.COLOR_ORANGE, Gfx.COLOR_RED];
	hidden var currentZone = 0;
	hidden var currentHr = 0;
	hidden var zones = [];
	
	function initialize() {
        var dictionary = {
            :identifier => "ZoneBars"
        };

        Drawable.initialize(dictionary);
    }
    
	function setTimeInZone( val ) {
		timeInZone = val;
	}
	
	function setCurrentZone( val ) {
		currentZone = val;
	}
	
	function setCurrentHr( val ) {
		currentHr = val;
	}
	
	function setZones( val ) {
		zones = val;
	}
		
    function draw(dc) {
    
    	var maxWidth = dc.getWidth()-80;
		var maxHeight = dc.getHeight();
		var zoneSize = maxHeight / 5;
		
		var sum = 0.0;
		for(var i = 0; i < timeInZone.size(); i++) {
 			sum += timeInZone[i];
		}
		
		if(sum != null && sum > 0) {
	    	for(var i = 0; i < timeInZone.size(); i++) {
				var width = (timeInZone[i]/sum * maxWidth);
				if (i == currentZone) {
					dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
					
				} else {
					dc.setColor(colorZones[i], Gfx.COLOR_TRANSPARENT);	
				}
				var y = zoneSize*i;
				dc.fillRectangle(0, y, width, zoneSize);
				dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
				dc.drawRectangle(0, y, width, zoneSize);
				if (i == currentZone) {
					drawTriangle(dc, width, zoneSize);
				}
			}
		}
    }
    
    function drawTriangle(dc, barWidth, barHeight) {
    	var maxHeight = dc.getHeight();
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
		var offsetX = barWidth;
		
		var offsetY=0;
		if (currentHr > zones[0] ) {
			offsetY = ((self.currentZone) * barHeight) + (barHeight / (self.zones[self.currentZone+1] - self.zones[self.currentZone])) * (self.currentHr - self.zones[self.currentZone]);
		}
		if (currentHr > zones[4]) {
			offsetY = maxHeight;
		}
		
		var hT = barHeight * 0.4;
		var wT = hT * 2;
		var pts = [ [wT + offsetX, offsetY - hT ], [hT + offsetX, offsetY], [wT + offsetX, offsetY + hT]];
		dc.fillPolygon(pts);
	}
}