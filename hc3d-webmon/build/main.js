var App;
(function (App) {
    App.TEST_MODE = true;
    App.SENSOR_LABELS = [
        "Time",
        "Chamber Mid",
        "Chamber Top",
        "Chamber Heater",
        "Motor X",
        "Motor Y",
        "Motor Z",
        "Motor E"
    ];
    App.SENSOR_COLORS = [
        "red",
        "green",
        "lightblue",
        "purple",
        "grey",
        "orange",
        "darkgreen",
        "navy"
    ];
    App.frames = []; // List of Frame objects currently loaded
    App.canvas = null;
    App.ctx = null;
    App.userZoomFactor = parseFloat(localStorage.zoomLevel);
    App.loading = false;
    App.sessionListContainer = null;
    var init = function () {
        if (isNaN(App.userZoomFactor)) {
            App.userZoomFactor = 1;
        }
        // Obtain handles and environment properties
        App.canvas = document.getElementsByTagName("canvas")[0];
        App.ctx = App.canvas.getContext("2d");
        App.sessionListContainer = document.getElementById("session-list");
        // Periodically obtain last line if the current open file is a live file hc3d-log.log
        setInterval(function () {
            if (App.loading == false && typeof localStorage.currentSession != "undefined" && localStorage.currentSession == "hc3d-temp.log" && App.frames.length > 0) {
                var xhr = new XMLHttpRequest();
                xhr.onreadystatechange = function () {
                    if (this.readyState != 4 || this.status != 200)
                        return;
                    var frame = new App.Frame(this.responseText);
                    App.frames.push(frame);
                    Drawer.draw();
                };
                xhr.open("GET", "get_llc_values.php", true);
                xhr.send();
            }
        }, 1000);
        // Add mouse listener
        App.canvas.addEventListener("wheel", onWheel);
    };
    var onWheel = function (e) {
        if (e.deltaY > 0) {
            App.userZoomFactor + .1;
        }
        else {
            App.userZoomFactor - .1;
        }
        localStorage.zoomLevel = App.userZoomFactor;
        console.log(localStorage.zoomLevel);
        Drawer.draw();
    };
    addEventListener("DOMContentLoaded", init);
})(App || (App = {}));
var Drawer;
(function (Drawer) {
    // Frequency of souce data. Could be derrived from timestamps alternatively.
    // TODO indicate gaps in the data?
    const frequencyHz = 1;
    const windowTimeSpanS = 60 * 60; // Display 1 hr of data in one windows' width
    const baseZoomFactor = windowTimeSpanS / window.innerWidth; // Frames per pixel? TODO
    const canvasHeight = window.innerHeight;
    const xGridInterval = 60; // Seconds
    const yGridInterval = 0.1; // Relative to graph height
    const yMargin = 10;
    const xMargin = 10;
    const labelEdgeOffset = 10;
    let canvasWidth;
    let scaleY;
    let yMin = 0;
    let yMax = 1;
    //let chartWidth: number;
    //let chartHeight: number;
    let scaleX;
    let xMax;
    // Draw window.frames using localStorage.zoomLevel
    function draw() {
        let frame;
        xMax = frames.length;
        // Calculate width of canvas based on time resolution, fixed scale factor and user zoom level
        scaleX = App.userZoomFactor * baseZoomFactor;
        canvasWidth = frames.length * scaleX;
        // Each plot has different frame count, therefore canvas element has different size	
        App.canvas.width = canvasWidth;
        App.canvas.height = canvasHeight;
        App.canvas.style.width = canvasWidth + "";
        // Determine yRange
        for (frame of App.frames) {
            for (var temp of frame.temps) {
                if (temp < yMin || yMin == null) {
                    yMin = temp;
                }
                if (temp > yMax || yMax == null) {
                    yMax = temp;
                }
            }
        }
        if (yMin == null || yMax == 0 || !Number.isFinite(yMin) || !Number.isFinite(yMax) || isNaN(yMin) || isNaN(yMax) || Math.abs(yMax - yMin) == 0) {
            // Unable to calculate range, set artifical range 1 below and 1 above current value, which should center the line if there is a line at all
            yMin -= 1;
            yMax += 1;
        }
        // Calculate drawing scale
        scaleY = (canvasHeight - yMargin) / (yMax - yMin);
        // Start drawing grid 
        App.ctx.beginPath();
        App.ctx.font = "1em monospace";
        // Draw horizontal grid lines and axis labels
        var yRelative = 0;
        App.ctx.textAlign = "right";
        while (yRelative <= 1) {
            var yValue = yMin + ((yMax - yMin) * (1 - yRelative));
            var yPosition = (canvasHeight - yMargin) * yRelative;
            App.ctx.moveTo(xMargin, yPosition);
            App.ctx.lineTo(canvasWidth, yPosition);
            var valueString = yValue.toFixed(1);
            // These offsets should be constants!
            var labelYOffset = 4;
            if (yRelative == 0) {
                labelYOffset = 10;
            }
            else if (yRelative == 1) {
                labelYOffset = -10;
            }
            App.ctx.fillText(valueString, xMargin - labelEdgeOffset, yPosition + labelYOffset); // TODO add margin as constant
            yRelative += yGridInterval;
        }
        // Draw vertical grid lines and axis labels
        var xValue = 0;
        while (xValue <= xMax) {
            var xPosition = xMargin + xValue * scaleX;
            App.ctx.moveTo(xPosition, 0);
            App.ctx.lineTo(xPosition, canvasHeight - yMargin);
            var valueString = Util.createTimeLabel(xValue);
            if (xValue == 0) {
                App.ctx.textAlign = "left";
            }
            else if (xValue == xMax) {
                App.ctx.textAlign = "right";
            }
            else {
                App.ctx.textAlign = "center";
            }
            App.ctx.fillText(valueString, xPosition, canvasHeight - 3); // TODO Add X label Y offset as constant
            xValue += xGridInterval;
        }
        // Complete drawing of grid
        App.ctx.strokeStyle = 'silver';
        App.ctx.stroke();
        App.ctx.beginPath();
        for (var sensorIndex = 0; sensorIndex < App.SENSOR_COLORS.length; sensorIndex++) {
            var color = App.SENSOR_COLORS[sensorIndex];
            App.ctx.strokeStyle = color;
            // Draw data
            var val = App.frames[0].temps[sensorIndex];
            App.ctx.moveTo(xMargin, canvasHeight - ((val - yMin) * scaleY) - yMargin);
            for (var i = 1; i < App.frames.length; i++) {
                //frame = frames[i];
                val = frame.temps[sensorIndex];
                var xPos = (i / frequencyHz) * scaleX + xMargin;
                var yPos = canvasHeight - ((val - yMin) * scaleY) - yMargin;
                App.ctx.lineTo(xPos, yPos);
                if (isNaN(yPos)) {
                    console.log(yPos);
                }
            }
        }
        // Complete drawing of grid
        App.ctx.strokeStyle = 'black';
        App.ctx.stroke();
        // Start drawing axis labels
        App.ctx.beginPath();
    }
    Drawer.draw = draw;
})(Drawer || (Drawer = {}));
var App;
(function (App) {
    // Deserialize frame
    class Frame {
        constructor(rawFrame) {
            this.temps = [];
            var i = 0;
            var lastIndex = 0;
            while (lastIndex !== -1) {
                var index = rawFrame.indexOf('\t', lastIndex + 1);
                var valueRaw = rawFrame.substr(lastIndex, index - lastIndex);
                if (index == -1) {
                    break;
                }
                if (index == 0) {
                    this.time = parseInt(valueRaw);
                }
                else {
                    this.temps[i - 1] = parseFloat(valueRaw);
                }
                if (lastIndex == rawFrame.length - 1) {
                    break;
                }
                lastIndex = index;
                i++;
            }
        }
    }
    App.Frame = Frame;
    ;
})(App || (App = {}));
var SessionList;
(function (SessionList) {
    // Load list of available log files and initiate load of the last-loaded file
    function load() {
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
            // Display list of files async
            if (this.readyState != 4)
                return;
            var parser = new DOMParser();
            let doc = parser.parseFromString(xhttp.responseText, "text/html");
            var links = doc.querySelectorAll("td a");
            for (let link of links) {
                // Skip link to parent directory
                if (link.outerText == "Parent Directory") {
                    continue;
                }
                App.sessionFilenames.push(link.getAttribute("href"));
                // Insert the link node into main window
                link.innerText = link.innerText.replaceAll("hc3d-tm-", "");
                link.innerText = link.innerText.replaceAll(".log", "");
                var newLink = App.sessionListContainer.appendChild(link);
                App.sessionListContainer.appendChild(document.createElement("br"));
                // Invoke loadSession when clicking on link
                newLink.addEventListener("click", function (e) {
                    localStorage.lastSession = this.getAttribute("href");
                    e.preventDefault();
                    SessionLoader.load(localStorage.lastSession);
                });
            }
            // Load last session
            if (typeof localStorage.lastSession != "undefined") {
                SessionLoader.load(localStorage.lastSession);
            }
        };
        var url;
        if (App.TEST_MODE) {
            url = "testdata/index-of-mnt-data.html";
        }
        else {
            url = "mnt-data/?C=M;O=D";
        }
        xhttp.open("GET", url, true);
        xhttp.send();
    }
    SessionList.load = load;
})(SessionList || (SessionList = {}));
var SessionLoader;
(function (SessionLoader) {
    // Load session data by filename.  
    function load(filename) {
        console.log("Loading session...");
        App.loading = true;
        App.frames = [];
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
            if (this.readyState != 4)
                return;
            console.log("Parsing data...");
            var responseData = xhttp.responseText;
            var lastIndex = 0;
            while (lastIndex !== -1) {
                var index = responseData.indexOf('\n', lastIndex + 1);
                var line = responseData.substr(lastIndex, index - lastIndex);
                var frame = new App.Frame(line);
                App.frames.push(frame);
                if (lastIndex == responseData.length - 1) {
                    break;
                }
                lastIndex = index;
            }
            App.loading = false;
            console.log("Session loaded. Frames: " + frames.length);
            Drawer.draw();
        };
        if (App.TEST_MODE) {
            var url = "testdata/" + filename;
        }
        else {
            var url = "mnt-data/" + filename;
        }
        xhttp.open("GET", url, true);
        xhttp.send();
    }
    SessionLoader.load = load;
    ;
})(SessionLoader || (SessionLoader = {}));
var Util;
(function (Util) {
    // Based on: https://stackoverflow.com/a/847196
    Util.createTimeLabel = function (unixTime) {
        // Create a new JavaScript Date object based on the timestamp
        // multiplied by 1000 so that the argument is in milliseconds, not seconds.
        var date = new Date(unixTime * 1000);
        // Hours part from the timestamp
        var hours = date.getHours();
        // Minutes part from the timestamp
        var minutes = "0" + date.getMinutes();
        // Seconds part from the timestamp
        var seconds = "0" + date.getSeconds();
        // Will display time in 10:30:23 format
        var formattedTime = hours + ':' + minutes.substr(-2); // + ':' + seconds.substr(-2);
        return formattedTime;
    };
})(Util || (Util = {}));
//# sourceMappingURL=main.js.map