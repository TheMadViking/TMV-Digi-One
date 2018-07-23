using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.ActivityMonitor as Act;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Greg;
using Toybox.Application as App;
using Toybox.Sensor as Sens;

class TMVDigiOneView extends Ui.WatchFace {

 var customFont = null;
 var selectedFont;
 var medcustomFont;
 var AlgerianFont;
 var ArialFont;
 var CooperFont;
 var HaettenFont;
 var ImpactFont;
 var bmpHeart = null;
 var bmpBattery = null;
 var bmpPhone = null;
 var bmpMsg = null;
 var bmpMsg2 = null;
 var bmpAlarm = null;
 var hour12;
 var bckgrnd;
 var HourColor;
 var MinColor;
 var ColonColor;
 var PadHour;
 var enBattCircle;
 var battThickness;
 var battColor;
 var battColor100;
 var battColor75;
 var battColor50;
 var battColor25;
 var battColor10;
 var timeFormat;
 var heart_rate = 199;
 var hStr;
 
//Test to see git changes
    function onLayout(dc) {
    	medcustomFont = Ui.loadResource(Rez.Fonts.POFont);
//    	AlgerianFont = Ui.loadResource(Rez.Fonts.AlgerianFont);
//    	ArialFont = Ui.loadResource(Rez.Fonts.ArialRoundedMTFont);
//    	CooperFont = Ui.loadResource(Rez.Fonts.CooperBlackFont);
//    	HaettenFont = Ui.loadResource(Rez.Fonts.HaettenschweilerFont);
//    	ImpactFont = Ui.loadResource(Rez.Fonts.ImpactFont);
 
 		bmpHeart = Ui.loadResource(Rez.Drawables.heartIcon);
// 		bmpBattery = Ui.loadResource(Rez.Drawables.battIcon);
 		bmpPhone = Ui.loadResource(Rez.Drawables.phoneIcon);
 		bmpMsg = Ui.loadResource(Rez.Drawables.msgIcon);
 		bmpMsg2 = Ui.loadResource(Rez.Drawables.msg2Icon);
 		bmpAlarm = Ui.loadResource(Rez.Drawables.alarmIcon);
    }

    function onUpdate(dc) {
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
//		bckgrnd = Gfx.COLOR_BLACK;   //App.getApp().getProperty("BackgroundColor");
		HourColor = App.getApp().getProperty("HourColor");
		MinColor = App.getApp().getProperty("MinuteColor");
		ColonColor = App.getApp().getProperty("ColonColor");
		PadHour = App.getApp().getProperty("PadHour");
		selectedFont = App.getApp().getProperty("customFont");
		battColor100 = App.getApp().getProperty("batt100");
		battColor75 = App.getApp().getProperty("batt75");
		battColor50 = App.getApp().getProperty("batt50");
		battColor25 = App.getApp().getProperty("batt25");
		battColor10 = App.getApp().getProperty("batt10");
		enBattCircle = App.getApp().getProperty("battCircle");
		battThickness = App.getApp().getProperty("bcThickness");
		var device_settings = Sys.getDeviceSettings();
//		System.println(selectedFont);		
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    	dc.clear();
//    	onSensor(sensorInfo);

//Battery
		var scrnHeight = dc.getHeight();
		var battery = Sys.getSystemStats().battery;
		var strBatt = Lang.format("$1$ $2$", [battery.format("%3d"), "%"]);
		var battWidth = dc.getTextWidthInPixels(strBatt, Gfx.FONT_SYSTEM_MEDIUM);
		dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_GREEN);

		if (battery > 75) {
			battColor = battColor100;
		} else if (battery > 50) {
			battColor = battColor75;
		} else if (battery > 25) {
			battColor = battColor50;
		} else if (battery > 10) {
			battColor = battColor25;
		} else {
			battColor = battColor10;
		}			
					
		if (enBattCircle) {
			dc.setColor(battColor, Gfx.COLOR_BLACK);
			dc.setPenWidth(battThickness);
			dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()/2, 0, 90 + ((100 - battery)*1.8), 90 - ((100 -battery)*1.8));
			dc.drawText(dc.getWidth()/2, scrnHeight - 28,Gfx.FONT_SMALL, strBatt, Gfx.TEXT_JUSTIFY_CENTER);
		} else {
			dc.fillRoundedRectangle(dc.getWidth()/2 - (battWidth/2 + 15), scrnHeight - 32, battWidth + 30, dc.getFontHeight(Gfx.FONT_SYSTEM_MEDIUM) - 7, 10);
			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT); 
			dc.drawText(dc.getWidth()/2, scrnHeight - 38, Gfx.FONT_SYSTEM_MEDIUM, strBatt , Gfx.TEXT_JUSTIFY_CENTER);
		}
// Trying to make the circle battery indicator





//	Time
        var clockTime = Sys.getClockTime();
        var hours = clockTime.hour;

		if (!Sys.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
                if (PadHour) {
					hours = hours.format("%02d");
				}
           	} else if (hours == 0) {
            // when using the 12 hour clock, midnight is displayed as 12:00 AM (not 0:00 AM)
            	hours = 12;
        	}
        } else {
            timeFormat = "$1$$2$";
            hours = hours.format("%02d");
        }
// 		switch (selectedFont) {
//    		case 1:
   			customFont = medcustomFont;
//		   	break;
//  		   	case 2:
//    			customFont = AlgerianFont;
// 		   	break;
//   		 	case 3:
//    			customFont = ArialFont;
// 		   	break;
// 		   	case 4:
//   			customFont = CooperFont;
// 		   	break;
// 		   	case 5:
//    			customFont = HaettenFont;
// 		   	break;
// 		   	case 6:
//    			customFont = ImpactFont;
// 		   	break;
//		}
		//System.println(customFont);
		var hourWidth = dc.getTextWidthInPixels(hours.toString(), customFont);
		var minWidth = dc.getTextWidthInPixels(clockTime.min.format("%02d"), customFont);
		var colWidth = dc.getTextWidthInPixels(":", customFont) - 10;
    	var timeWidth = hourWidth + minWidth + colWidth;
    	var hourX = dc.getWidth()/2 - timeWidth/2;  //hour needs to left justified at this spot
    	var minX = dc.getWidth()/2 + timeWidth/2;  //min needs to be right justified at this spot
    	var colX = hourX + hourWidth - 5; //colon needs to be left jsutified at this point.
    	
    	dc.setColor(HourColor, Gfx.COLOR_TRANSPARENT);  
    	dc.drawText(hourX, (dc.getHeight() / 2) - 75, customFont, hours.toString(), Gfx.TEXT_JUSTIFY_LEFT);
    	dc.setColor(ColonColor, Gfx.COLOR_TRANSPARENT);
    	dc.drawText(colX, (dc.getHeight() / 2) - 75, customFont, ":", Gfx.TEXT_JUSTIFY_LEFT);
		dc.setColor(MinColor, Gfx.COLOR_TRANSPARENT);
		dc.drawText(minX, (dc.getHeight() / 2) - 75, customFont, Lang.format("$1$", [clockTime.min.format("%02d")]), Gfx.TEXT_JUSTIFY_RIGHT);
    	
//	Date		
		var today = Greg.info(Time.now(), Time.FORMAT_MEDIUM);
		var dateString = Lang.format(
   			"$1$ $2$ $3$",
    		[
       			 today.day_of_week,
       			 today.month,
       			 today.day,
   			 ]
			);
		var alarms = device_settings.alarmCount;
		var dateEnd = null;
		if (alarms > 0) {
			dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);	
			dc.drawText(((dc.getWidth()/2) - 15), 26, Gfx.FONT_SYSTEM_MEDIUM, dateString, Gfx.TEXT_JUSTIFY_CENTER);
			var dateWidth = dc.getTextWidthInPixels(dateString.toString(), Gfx.FONT_SYSTEM_MEDIUM);
			dateEnd = dc.getWidth()/2 - 17 + dateWidth/2;
		}
		else {
			dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);	
			dc.drawText(dc.getWidth()/2, 26, Gfx.FONT_SYSTEM_MEDIUM, dateString, Gfx.TEXT_JUSTIFY_CENTER);
			var dateWidth = dc.getTextWidthInPixels(dateString.toString(), Gfx.FONT_SYSTEM_MEDIUM);
			dateEnd = dc.getWidth()/2 + dateWidth/2;
		}

//Alarms
//		var alarms = device_settings.alarmCount;
		if (alarms > 0) {
			dc.drawBitmap(dateEnd + 9, 32, bmpAlarm);
		}
				
//	Heart Rate		 	
	
		var sample = Act.getHeartRateHistory(null, true);
        	if(sample != null){
            	var hr = sample.next();
         		heart_rate = (hr.heartRate != Act.INVALID_HR_SAMPLE && hr.heartRate > 0) ? hr.heartRate : 0;
        }
		
		if (heart_rate == 0) {
			hStr = "---";
		}
		else {
			hStr = heart_rate.toString();
		}

		var hrWidth = dc.getTextWidthInPixels(hStr, Gfx.FONT_SYSTEM_MEDIUM);
		var hrTotWidth = hrWidth + 27;
		var xposHr = hrWidth - (hrTotWidth/2);
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		dc.drawText(dc.getWidth()/2, 1, Gfx.FONT_SYSTEM_MEDIUM, hStr, Gfx.TEXT_JUSTIFY_LEFT);
		dc.drawBitmap(dc.getWidth()/2 - (hrWidth/2 + 12), 7, bmpHeart);

//Step Count
		var info = Act.getInfo(); 
		var steps = info.steps;
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
		dc.drawText(dc.getWidth()/2, scrnHeight - 71, Gfx.FONT_SYSTEM_MEDIUM, steps, Gfx.TEXT_JUSTIFY_CENTER);
		var countWidth = dc.getTextWidthInPixels(steps.toString(), Gfx.FONT_SYSTEM_MEDIUM);
		var countStart = dc.getWidth()/2 - countWidth/2;
		var countEnd = dc.getWidth()/2 + countWidth/2;
		
//Phone Connected
		if(Sys.getDeviceSettings().phoneConnected){
            	dc.drawBitmap(countStart/2 - 10, scrnHeight - 63, bmpPhone);
        }

// Messages

		
		var msgCount = device_settings.notificationCount;
//		var strmsgCount = msgCount.toString();
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
//		dc.drawBitmap((dc.getWidth() - countEnd)/2 - 8 + countEnd, (scrnHeight - 71), bmpMsg2);
//		dc.drawText((dc.getWidth() - countEnd)/2 - 8 + countEnd, (scrnHeight - 71), Gfx.FONT_SYSTEM_MEDIUM, msgCount, Gfx.TEXT_JUSTIFY_CENTER);


		dc.drawBitmap(((dc.getWidth() - countEnd)/2) + countEnd, (scrnHeight - 68), bmpMsg);
		dc.drawText((dc.getWidth() - countEnd)/2 - 8 + countEnd, (scrnHeight - 71), Gfx.FONT_SYSTEM_MEDIUM, msgCount, Gfx.TEXT_JUSTIFY_CENTER);
    

    }
    function onHide() {
    }
    function onExitSleep() {
    }
    function onEnterSleep() {
    }

}