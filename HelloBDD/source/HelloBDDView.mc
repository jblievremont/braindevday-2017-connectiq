using Toybox.Application as Application;
using Toybox.WatchUi as Ui;
using Toybox.Communications as Communications;
using Toybox.System as System;
using Toybox.Graphics as Graphics;
using Toybox.WatchUi as WatchUi;
using Toybox.StringUtil as StringUtil;

class HelloBDDView extends Ui.View {

    var wallboard = "";
    var redCount = -1;
    var redJobs = [];

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
      var redJobsUrl = Application.getApp().getProperty("burgrUrl") + "/api/projects/statuses";
      var burgrLogin = Application.getApp().getProperty("burgrLogin");
      var burgrPassword = Application.getApp().getProperty("burgrPassword");
      var burgrAuthBase64 = StringUtil.encodeBase64(burgrLogin + ":" + burgrPassword);
      wallboard = Application.getApp().getProperty("wallboard");
      System.println(redJobsUrl);
      Communications.makeWebRequest(
        redJobsUrl,
        { "wallboard" => wallboard },
        {
          :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
          , :headers => {
            "Authorization" => "Basic " + burgrAuthBase64
          }
        },
        method(:burgrCallback)
      );
    }

    function burgrCallback(responseCode, data) {
      System.println(responseCode);
      redJobs = [];
      if (responseCode == 200) {
        redCount = data.size();
        for (var jobIndex = 0; jobIndex < redCount; jobIndex++) {
          redJobs.add(data[jobIndex]["repo"]["name"]);
        }
      } else {
        redCount = -1;
      }
      WatchUi.requestUpdate();
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
        dc.drawText(
          dc.getWidth() / 2,
          0,
          Graphics.FONT_MEDIUM,
          wallboard,
          Graphics.TEXT_JUSTIFY_CENTER
        );

        if (redCount < 0) {
          // NOP
        } else if (redCount == 0) {
          dc.drawBitmap((dc.getWidth() - 144) / 2, 25, Ui.loadResource( Rez.Drawables.SuperGreen));
        } else {
          dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
          dc.drawText(5, 25, Graphics.FONT_LARGE, "" + redCount, Graphics.TEXT_JUSTIFY_LEFT);
          dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
          dc.drawText(30, 25, Graphics.FONT_MEDIUM, "booms", Graphics.TEXT_JUSTIFY_LEFT);

          if (50 + 25 * redCount < dc.getHeight()) {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_RED);
            for (var redIndex = 0; redIndex < redCount; redIndex ++) {
              dc.drawText(0, 50 + 35 * (redIndex), Graphics.FONT_MEDIUM, redJobs[redIndex], Graphics.TEXT_JUSTIFY_LEFT);
            }
          } else {
            dc.drawBitmap((dc.getWidth() - 144) / 2, 25, Ui.loadResource( Rez.Drawables.RedAlert));
          }
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
      // NOP
    }

}
