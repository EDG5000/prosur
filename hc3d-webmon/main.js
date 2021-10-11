// Obtain handles and environment properties
var App;
(function (App) {
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
    let yMin;
    let yMax;
    //let chartWidth: number;
    //let chartHeight: number;
    let scaleX;
    let xMax;
    // Draw window.frames using localStorage.zoomLevel
    App.draw = function () {
        xMax = App.frames.length;
        // Calculate width of canvas based on time resolution, fixed scale factor and user zoom level
        scaleX = App.userZoomFactor * baseZoomFactor;
        canvasWidth = App.frames.length * scaleX;
        // Determine yRange
        for (var val of App.frames) {
            if (val < yMin || yMin == null) {
                yMin = val;
            }
            if (val > yMax || yMax == null) {
                yMax = val;
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
        // Draw horizontal grid and axis labels
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
        // Draw vertical grid and axis labels
        var xValue = 0;
        while (xValue <= xMax) {
            var xPosition = xMargin + xValue * scaleX;
            App.ctx.moveTo(xPosition, 0);
            App.ctx.lineTo(xPosition, canvasHeight - yMargin);
            var valueString = xValue.toFixed(1);
            if (xValue == 0) {
                App.ctx.textAlign = "left";
            }
            else if (xValue == xMax) {
                App.ctx.textAlign = "right";
            }
            else {
                App.ctx.textAlign = "center";
            }
            App.ctx.fillText(valueString, xPosition, canvasHeight - 3); // TODO Add X label Y offset as constantr
            xValue += xGridInterval;
        }
        // Complete drawing of grid
        App.ctx.strokeStyle = 'silver';
        App.ctx.stroke();
        App.ctx.beginPath();
        // Draw data
        var val = App.frames[0];
        App.ctx.moveTo(xMargin, canvasHeight - ((val - yMin) * scaleY) - yMargin);
        for (var i = 1; i < App.frames.length; i++) {
            val = App.frames[i];
            //val = 0;
            var xPos = (i / frequencyHz) * scaleX + xMargin;
            var yPos = canvasHeight - ((val - yMin) * scaleY) - yMargin;
            App.ctx.lineTo(xPos, yPos);
        }
        // Complete drawing of grid
        App.ctx.strokeStyle = 'black';
        App.ctx.stroke();
        // Start drawing axis labels
        App.ctx.beginPath();
    };
})(App || (App = {}));
var App;
(function (App) {
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
    App.frames = []; // List of Frame objects currently loaded
    App.canvas = null;
    App.ctx = null;
    App.userZoomFactor = parseFloat(localStorage.zoomLevel);
    let sessionList = []; // List of filenames available
    let loading = false;
    let valueContainer = null;
    // Deserialize frame
    var Frame = function (rawFrame) {
        this.temps = [];
        var i = 0;
        var lastIndex = 0;
        while (lastIndex !== -1) {
            var index = rawFrame.indexOf('\t', lastIndex + 1);
            var valueRaw = rawFrame.substr(lastIndex, index - lastIndex);
            if (index == -1) {
                break;
            }
            this.temps[i] = parseFloat(valueRaw);
            if (lastIndex == rawFrame.length - 1) {
                break;
            }
            lastIndex = index;
            i++;
        }
    };
    // Load session data by filename.  
    var loadSession = function (session) {
        console.log("Loading session...");
        loading = true;
        App.frames = [];
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
            if (this.readyState != 4 || this.status != 200)
                return;
            console.log("Parsing data...");
            var responseData = xhttp.responseText;
            var lastIndex = 0;
            while (lastIndex !== -1) {
                var index = responseData.indexOf('\n', lastIndex + 1);
                var line = responseData.substr(lastIndex, index - lastIndex);
                var frame = new Frame(line);
                App.frames.push(frame);
                if (lastIndex == responseData.length - 1) {
                    break;
                }
                lastIndex = index;
            }
            loading = false;
            console.log("Session loaded. Frames: " + App.frames.length);
            App.draw();
        };
        xhttp.open("GET", "mnt-data/" + session, true);
        xhttp.send();
    };
    var init = function () {
        if (isNaN(App.userZoomFactor)) {
            App.userZoomFactor = 1;
        }
        // Obtain handles and environment properties
        App.ctx = document.getElementsByTagName("canvas")[0].getContext("2d");
        valueContainer = document.getElementById("value-container");
        // Load list of available log files and initiate load of the last-loaded file
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
            // Display list of files async
            if (this.readyState != 4 || this.status != 200)
                return;
            var parser = new DOMParser();
            let doc = parser.parseFromString(xhttp.responseText, "text/html");
            var links = doc.querySelectorAll("td a");
            for (let link of links) {
                // Skip link to parent directory
                if (link.outerText == "Parent Directory") {
                    continue;
                }
                sessionList.push(link.getAttribute("href"));
                // Insert the link node into main window
                link.innerText = link.innerText.replaceAll("hc3d-tm-", "");
                link.innerText = link.innerText.replaceAll(".log", "");
                var newLink = valueContainer.appendChild(link);
                valueContainer.appendChild(document.createElement("br"));
                // Invoke loadSession when clicking on link
                newLink.addEventListener("click", function (e) {
                    localStorage.lastSession = this.getAttribute("href");
                    e.preventDefault();
                    loadSession(localStorage.lastSession);
                });
            }
            // Load last session
            if (typeof localStorage.lastSession != "undefined") {
                loadSession(localStorage.lastSession);
            }
        };
        xhttp.open("GET", "mnt-data/?C=M;O=D", true);
        xhttp.send();
        // Periodically obtain last line if the current open file is a live file hc3d-log.log
        setInterval(function () {
            if (loading == false && typeof localStorage.currentSession != "undefined" && localStorage.currentSession == "hc3d-temp.log" && App.frames.length > 0) {
                var xhr = new XMLHttpRequest();
                xhr.onreadystatechange = function () {
                    if (this.readyState != 4 || this.status != 200)
                        return;
                    var frame = new Frame(this.responseText);
                    App.frames.push(frame);
                    App.draw();
                };
                xhttp.open("GET", "get_llc_values.php", true);
                xhttp.send();
            }
        }, 1000);
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
        App.draw();
    };
    addEventListener("DOMContentLoaded", init);
    addEventListener("wheel", onWheel);
})(App || (App = {}));
