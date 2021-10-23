namespace App{

export const TEST_MODE = true;
export const SENSOR_LABELS = [
    "Time",
    "Chamber Mid",
    "Chamber Top",
    "Chamber Heater",
    "Motor X", 
    "Motor Y",
    "Motor Z",
    "Motor E"
];
export const SENSOR_COLORS = [
    "red",
    "green",
    "lightblue",
    "purple",
    "grey",
    "orange",
    "darkgreen",
    "navy"
];

export let frames: Array<Frame> = []; // List of Frame objects currently loaded
export let canvas: HTMLCanvasElement = null;
export let ctx: CanvasRenderingContext2D = null;
export let userZoomFactor: number = parseFloat(localStorage.zoomLevel);
export let sessionFilenames: Array<string>; // List of filenames available
export let loading = false;
export let sessionListContainer = null;

var init = function(){
    if(isNaN(userZoomFactor)){
        userZoomFactor = 1;
    }

    // Obtain handles and environment properties
    canvas = document.getElementsByTagName("canvas")[0];
    ctx = canvas.getContext("2d");
    sessionListContainer = document.getElementById("session-list");
 
	// Periodically obtain last line if the current open file is a live file hc3d-log.log
	setInterval(function(){
		if(loading == false && typeof localStorage.currentSession != "undefined" && localStorage.currentSession == "hc3d-temp.log" && frames.length > 0){
			var xhr = new XMLHttpRequest();
			xhr.onreadystatechange = function(){
				if(this.readyState != 4 || this.status != 200) return;
				var frame = new Frame(this.responseText);
				frames.push(frame);
				Drawer.draw();
			};
			xhr.open("GET", "get_llc_values.php", true);
    		xhr.send();
		} 
    }, 1000);	
    
    // Add mouse listener
    canvas.addEventListener("wheel", onWheel);
};

var onWheel = function(e){
	if(e.deltaY > 0){
		userZoomFactor + .1;
	}else{
		userZoomFactor - .1;
	}
    localStorage.zoomLevel = userZoomFactor;
	console.log(localStorage.zoomLevel);
	Drawer.draw();
};

addEventListener("DOMContentLoaded", init);


}
