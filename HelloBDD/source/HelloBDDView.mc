using Toybox.Application as Application;
using Toybox.WatchUi as Ui;
using Toybox.Communications as Communications;
using Toybox.System as System;
using Toybox.Graphics as Graphics;
using Toybox.WatchUi as WatchUi;
using Toybox.StringUtil as StringUtil;

class HelloBDDView extends Ui.View {

    var redCount = "-";

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
      var burgrLogin = Application.getApp().getProperty("burgrLogin");
      var burgrPassword = Application.getApp().getProperty("burgrPassword");
      var burgrAuthBase64 = StringUtil.encodeBase64(burgrLogin + ":" + burgrPassword);
      var wallboard = Application.getApp().getProperty("wallboard");
      Communications.makeWebRequest(
        Application.getApp().getProperty("burgrUrl") + "/api/projects/statuses",
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
      if (responseCode == 200) {
        System.println(data);
        redCount = "" + data.size();
      } else {
        redCount = "Error";
      }
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
          redCount,
          Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
      // NOP
    }

}
