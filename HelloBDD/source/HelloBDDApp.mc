using Toybox.Application as App;

class HelloBDDApp extends App.AppBase {

	var wallboard = Application.getApp().getProperty("wallboard");

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new HelloBDDView() ];
    }
    
    // Update settings when changed
    function onSettingsChanged() {
    	wallboard = Application.getApp().getProperty("wallboard");
    }

}