using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class ZoneBars extends Ui.Drawable {

	hidden var timeInZone = new [5];
	hidden var colorZones= [Gfx.COLOR_DK_GREEN, Gfx.COLOR_GREEN, Gfx.COLOR_YELLOW, Gfx.COLOR_ORANGE, Gfx.COLOR_RED];
	hidden var currentZone = 0;
	hidden var currentHr = 0;
	hidden var zones = [];
	hidden var isVerticalLayout = true;
	
	hidden var maxWidth = 0;
	hidden var maxHeight = 0;
	hidden var zoneSize = 0;
	hidden var dT = 0;
	
	function initialize() {
        var dictionary = {
            :identifier => "ZoneBars"
        };

        Drawable.initialize(dictionary);
    }
    
    // Initialise all the sizes for drawing purposes
    function initSizes(dc) {
    	if (isVerticalLayout) {
    		self.maxWidth = dc.getWidth()-80;
			self.maxHeight = dc.getHeight();
			self.zoneSize = self.maxHeight / 5;
			self.dT = self.zoneSize * 0.4;
		} else {
			self.maxWidth = dc.getWidth();
			self.maxHeight = dc.getHeight()*0.8;
			self.zoneSize = self.maxWidth / 5;
			self.dT = self.maxHeight * 0.1;
		}
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
	
	function setIsVerticalLayout( val ) {
		isVerticalLayout = val;
	}
		
    function draw(dc) {
    	if (isVerticalLayout) {
    		drawVerticalLayout(dc);
    	} else {
    		drawHorizontalLayout(dc);
    	}
    }
    
    function drawHorizontalLayout(dc) {
		var sum = 0.0;
		for(var i = 0; i < timeInZone.size(); i++) {
 			sum += timeInZone[i];
		}
		
		if(sum != null && sum > 0) {
	    	for(var i = 0; i < timeInZone.size(); i++) {
				var height = (timeInZone[i]/sum * maxHeight);
				if (i == self.currentZone) {
					dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
				} else {
					dc.setColor(colorZones[i], Gfx.COLOR_TRANSPARENT);	
				}
				var x = zoneSize*i;
				dc.fillRectangle(x, dc.getHeight()-height, zoneSize, dc.getHeight());
				dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
				dc.drawRectangle(x, dc.getHeight()-height, zoneSize, dc.getHeight());
			}
			var progress = (timeInZone[self.currentZone]/sum * maxHeight);
			drawTriangle(dc, progress);
		}
    }
    
    function drawVerticalLayout(dc) {
		
		var sum = 0.0;
		for(var i = 0; i < timeInZone.size(); i++) {
 			sum += timeInZone[i];
		}
		
		if(sum != null && sum > 0) {
			// Draw Bars
	    	for(var i = 0; i < timeInZone.size(); i++) {
				var width = (timeInZone[i]/sum * maxWidth);
				if (i == self.currentZone) {
					dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
					
				} else {
					dc.setColor(colorZones[i], Gfx.COLOR_TRANSPARENT);	
				}
				var y = zoneSize*i;
				dc.fillRectangle(0, y, width, zoneSize);
				dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
				dc.drawRectangle(0, y, width, zoneSize);
			}
			// Draw indicator
			var progress = (timeInZone[self.currentZone]/sum * maxWidth);
			drawTriangle(dc, progress);
		}
    }
    
    function drawTriangle(dc, progress) {
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
    	var offsetX = 0;
    	var offsetY = 0;
    	
    	if (self.isVerticalLayout) {
			offsetX = progress+5;
		} else {
			offsetY = dc.getHeight() - progress -5;
		}
		
		if (currentHr > zones[0] ) {
			if (self.isVerticalLayout) {
				offsetY = ((self.currentZone) * self.zoneSize) + (self.zoneSize / (self.zones[self.currentZone+1] - self.zones[self.currentZone])) * (self.currentHr - self.zones[self.currentZone]);
			} else {
				offsetX = ((self.currentZone) * self.zoneSize) + (self.zoneSize / (self.zones[self.currentZone+1] - self.zones[self.currentZone])) * (self.currentHr - self.zones[self.currentZone]);
			}
		}
		if (currentHr > zones[4]) {
			if (self.isVerticalLayout) {
				offsetY = maxHeight;
			} else {
				offsetX = maxWidth;
			}
		}
		var pts = [];
		if (self.isVerticalLayout) {
			pts = [ [self.dT + offsetX, offsetY - self.dT ], [offsetX, offsetY], [self.dT + offsetX, offsetY + self.dT]];
		} else {
			pts = [ [ offsetX - self.dT, offsetY - self.dT], [offsetX, offsetY], [offsetX + self.dT, offsetY - self.dT] ];
		}
		
		dc.fillPolygon(pts);
	}
}