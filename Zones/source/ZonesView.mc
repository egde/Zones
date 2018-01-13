using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.UserProfile as User;
using Toybox.Application as App;

class ZonesView extends Ui.DataField {

	hidden const currentSport = User.getCurrentSport();
	
	hidden var currentZoneColor = Gfx.COLOR_DK_GREEN;
	hidden var hr = 0;
	hidden var currentZone = 0;
	hidden var duration = 0;
	hidden var distance = 0;
	hidden var pace = 0;

	hidden var timeInZone = new [5];
	hidden var zones = User.getHeartRateZones(currentSport);
	
	hidden var isVerticalLayout = true;
	hidden var showPace = false;
	hidden var showDuration = false;
	hidden var showDistance = false;
	
    function initialize() {
        DataField.initialize();
        
        timeInZone = [0, 0, 0, 0, 0];
        isVerticalLayout = Application.getApp().getProperty("isVerticalLayout");
        showPace = Application.getApp().getProperty("showPace");
        showDuration = Application.getApp().getProperty("showDuration");
        showDistance = Application.getApp().getProperty("showDistance");
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
        	if (dc.getHeight() > 200) {
            	View.setLayout(Rez.Layouts.MainLayout(dc));
            } else {
            	View.setLayout(Rez.Layouts.SmallLayout(dc));
            }
        }

        View.findDrawableById("label").setText(Rez.Strings.label);
        
        var zoneBars = View.findDrawableById("ZoneBars");
        zoneBars.setIsVerticalLayout(isVerticalLayout);
        zoneBars.initSizes(dc);
        
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
		duration = info.elapsedTime;
		distance = info.elapsedDistance != null ? info.elapsedDistance : 0;
		
		//calculate current pace
		if (info.currentSpeed > 0) {
			pace = 1 / (info.currentSpeed) * 1000; // sec per km
		}
		
		if(hr > zones[0] && hr <= zones[1]) {
       		timeInZone[0] += 1;
			currentZoneColor = Gfx.COLOR_DK_GREEN;
			currentZone = 0;
		}
		else if(hr > zones[1] && hr <= zones[2]) {
			timeInZone[1] += 1;
			currentZoneColor = Gfx.COLOR_GREEN;
			currentZone = 1;
		}
		else if(hr > zones[2] && hr <= zones[3]) {
			timeInZone[2] += 1;
			currentZoneColor = Gfx.COLOR_YELLOW;
			currentZone = 2;
		}
		else if(hr > zones[3] && hr <= zones[4]) {
			timeInZone[3] += 1;
			currentZoneColor = Gfx.COLOR_ORANGE;
			currentZone = 3;
		}
		else if(hr > zones[4]) {
			timeInZone[4] += 1;
			currentZoneColor = Gfx.COLOR_RED;
			currentZone = 4;
		}
		
		return info.currentHeartRate;
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc) {
        // Set the background color
        View.findDrawableById("Background").setColor(currentZoneColor);
		var zoneBars = View.findDrawableById("ZoneBars");
		zoneBars.setTimeInZone(timeInZone);
		zoneBars.setCurrentZone(currentZone);
		zoneBars.setCurrentHr(hr);
		zoneBars.setZones(zones);
		
		var valueField = View.findDrawableById("value");
		if (hr == 0 ) {
			valueField.setText("-");
		} else {
			valueField.setText((hr).toString());
		}
		
		if (showDuration) {
			var durationField = View.findDrawableById("duration");
			if (durationField != null) {
				if (duration >= 3600000) {
					durationField.setText(
						Lang.format("$1$:$2$:$3$", [
							(duration / 3600000).format("%02d"), 
							((duration / 60000) % 60).format("%02d"),
							((duration / 1000) % 60).format("%02d")]
						)
					);
				} else {
					durationField.setText(
						Lang.format("$1$:$2$", [
							((duration / 60000) % 60).format("%02d"),
							((duration / 1000) % 60).format("%02d")]
						)
					);
				}
			}
		}
		
		if (showDistance) {
			var distanceField = View.findDrawableById("distance");
			var km = (distance / 1000);
			var m =  (distance.toLong() % 1000) / 10;
			distanceField.setText(
				Lang.format("$1$.$2$", [
					km.toLong().format("%d"),
					m.format("%02d")
					]
				)
			);
		}

		if (showPace) {
			var paceField = View.findDrawableById("pace");
			var min = (pace.toLong() / 60);
			var sec = (pace.toLong() % 60);
			paceField.setText( Lang.format("$1$:$2$", [min.format("%02d"), sec.format("%02d")]) );
		}

        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
    }

}