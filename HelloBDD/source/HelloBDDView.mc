using Toybox.WatchUi as Ui;
using Toybox.Communications as Communications;
using Toybox.System as System;
using Toybox.Graphics as Graphics;
using Toybox.WatchUi as WatchUi;

class HelloBDDView extends Ui.View {

    var sonarCloudVersion = "";
    var wallboard = Application.getApp().getProperty("wallboard");
    

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
      System.println("onShow");
      Communications.makeWebRequest(
        "https://sonarcloud.io/api/system/status",
        {},
        { :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON },
        method(:statusGatorCallback)
      );
    }

    function statusGatorCallback(responseCode, data) {
      System.println("callback");
      if (responseCode == 200) {
        sonarCloudVersion = data["version"];
      } else {
        sonarCloudVersion = "Error";
      }
      System.println(sonarCloudVersion);
      WatchUi.requestUpdate();
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        dc.drawText(
          dc.getWidth() / 2,
          dc.getHeight() / 2 + 30,
          Graphics.FONT_MEDIUM,
          wallboard,
          Graphics.TEXT_JUSTIFY_CENTER
        );
      System.println("onUpdate");
      System.println(wallboard);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
      System.println("onHide");
    }

}
