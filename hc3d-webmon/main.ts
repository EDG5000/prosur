namespace App{

const SENSOR_LABELS = [
    "Time",
    "Chamber Mid",
    "Chamber Top",
    "Chamber Heater",
    "Motor X", 
    "Motor Y",
    "Motor Z",
    "Motor E"
];

const SENSOR_COLORS = [
    "red",
    "green",
    "lightblue",
    "purple",
    "grey",
    "orange",
    "darkgreen",
    "navy"
];

export let frames = []; // List of Frame objects currently loaded
export let canvas: HTMLCanvasElement = null;
export let ctx: CanvasRenderingContext2D = null;
export let userZoomFactor: number = parseFloat(localStorage.zoomLevel);

let sessionList = []; // List of filenames available
let loading = false;
let valueContainer = null;

// Deserialize frame
var Frame = function(rawFrame){
    this.temps = [];
    var i = 0;
	var lastIndex = 0;
	while(lastIndex !== -1){
		var index = rawFrame.indexOf('\t', lastIndex+1);
		var valueRaw = rawFrame.substr(lastIndex, index-lastIndex);
		if(index == -1){
			break;
		}
		this.temps[i] = parseFloat(valueRaw);
		if(lastIndex == rawFrame.length-1){
			break;
		}
		lastIndex = index;
		i++;
	}
};

// Load session data by filename.  
var loadSession = function(session){
	console.log("Loading session...");
	loading = true;
	frames = [];

    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if(this.readyState != 4 || this.status != 200) return;
        console.log("Parsing data...");
        var responseData = xhttp.responseText;
        var lastIndex = 0;
        while(lastIndex !== -1){
            var index = responseData.indexOf('\n', lastIndex+1);
            var line = responseData.substr(lastIndex, index-lastIndex);
            var frame = new Frame(line);
            frames.push(frame);
            if(lastIndex == responseData.length-1){
            	break;
            }
            lastIndex = index;
        }
        loading = false;
        console.log("Session loaded. Frames: " + frames.length);
        draw();
    };
    xhttp.open("GET", "mnt-data/" + session, true);
    xhttp.send();
};

var init = function(){

    if(isNaN(userZoomFactor)){
        userZoomFactor = 1;
    }

    // Obtain handles and environment properties
    ctx = document.getElementsByTagName("canvas")[0].getContext("2d");
    valueContainer = document.getElementById("value-container");

    // Load list of available log files and initiate load of the last-loaded file
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function(){
        // Display list of files async
        if(this.readyState != 4 || this.status != 200) return;

        var parser = new DOMParser();
        let doc = parser.parseFromString(xhttp.responseText, "text/html");
        var links = doc.querySelectorAll("td a");

        for(let link of links as any){
            // Skip link to parent directory
            if(link.outerText == "Parent Directory"){
                continue;
            }
            sessionList.push(link.getAttribute("href"));

            // Insert the link node into main window
            link.innerText = link.innerText.replaceAll("hc3d-tm-", "");
            link.innerText = link.innerText.replaceAll(".log", "");
            var newLink = valueContainer.appendChild(link);
            valueContainer.appendChild(document.createElement("br"));
            // Invoke loadSession when clicking on link
            newLink.addEventListener("click", function(e){
				localStorage.lastSession = this.getAttribute("href");
				e.preventDefault();
				loadSession(localStorage.lastSession); 
            });
        }
        // Load last session
        if(typeof localStorage.lastSession != "undefined"){
            loadSession(localStorage.lastSession);
        }
        
    };
    xhttp.open("GET", "mnt-data/?C=M;O=D", true);
    xhttp.send();

	// Periodically obtain last line if the current open file is a live file hc3d-log.log
	setInterval(function(){
		if(loading == false && typeof localStorage.currentSession != "undefined" && localStorage.currentSession == "hc3d-temp.log" && frames.length > 0){
			var xhr = new XMLHttpRequest();
			xhr.onreadystatechange = function(){
				if(this.readyState != 4 || this.status != 200) return;
				var frame = new Frame(this.responseText);
				frames.push(frame);
				draw();
			};
			xhttp.open("GET", "get_llc_values.php", true);
    		xhttp.send();
		} 
	}, 1000);	
};

var onWheel = function(e){
	if(e.deltaY > 0){
		userZoomFactor + .1;
	}else{
		userZoomFactor - .1;
	}
    localStorage.zoomLevel = userZoomFactor;
	console.log(localStorage.zoomLevel);
	draw();
};

addEventListener("DOMContentLoaded", init);
addEventListener("wheel", onWheel);

}
