using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.UserProfile as User;

class ZonesView extends Ui.DataField {

	hidden const currentSport = User.getCurrentSport();
	
	hidden var currentZoneColor = Gfx.COLOR_DK_GREEN;
	hidden var hr = 0;

	hidden var timeInZone = new [5];
	hidden var zones = User.getHeartRateZones(currentSport);
	
    function initialize() {
        DataField.initialize();
        
        timeInZone = [0, 0, 0, 0, 0];
    }

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc) {
        var obscurityFlags = DataField.getObscurityFlags();

        // Top left quadrant so we'll use the top left layout
        if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.TopLeftLayout(dc));

        // Top right quadrant so we'll use the top right layout
        } else if (obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.TopRightLayout(dc));

        // Bottom left quadrant so we'll use the bottom left layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.BottomLeftLayout(dc));

        // Bottom right quadrant so we'll use the bottom right layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.BottomRightLayout(dc));

        // Use the generic, centered layout
        } else {
            View.setLayout(Rez.Layouts.MainLayout(dc));
        }

        View.findDrawableById("label").setText(Rez.Strings.label);
        return true;
    }

    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info) {
    	if (info.currentHeartRate == null) {
    		return null;
		}
		
		hr = info.currentHeartRate;
		
		if(hr > zones[0] && hr <= zones[1]) {
       		timeInZone[0] += 1;
			currentZoneColor = Gfx.COLOR_DK_GREEN;
		}
		else if(hr > zones[1] && hr <= zones[2]) {
			timeInZone[1] += 1;
			currentZoneColor = Gfx.COLOR_GREEN;
		}
		else if(hr > zones[2] && hr <= zones[3]) {
			timeInZone[2] += 1;
			currentZoneColor = Gfx.COLOR_YELLOW;
		}
		else if(hr > zones[3] && hr <= zones[4]) {
			timeInZone[3] += 1;
			currentZoneColor = Gfx.COLOR_ORANGE;
		}
		else if(hr > zones[4]) {
			timeInZone[4] += 1;
			currentZoneColor = Gfx.COLOR_RED;
		}
		
		return info.currentHeartRate;
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc) {
        // Set the background color
        View.findDrawableById("Background").setColor(currentZoneColor);
		View.findDrawableById("ZoneBars").setTimeInZone(timeInZone);
		
		var valueField = View.findDrawableById("value");
		if (hr == 0 ) {
			valueField.setText("-");
		} else {
			valueField.setText((hr).toString());
		}

        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
    }

}