var Main;
(function (Main) {
    Main.TEST_MODE = true;
    Main.SENSOR_LABELS = [
        "Chamber Mid",
        "Chamber Top",
        "Chamber Heater",
        "Motor X",
        "Motor Y",
        "Motor Z",
        "Motor E"
    ];
    Main.SENSOR_COLORS = [
        "red",
        "green",
        "darkmagenta",
        "purple",
        "grey",
        "orange",
        "darkgreen"
    ];
    Main.frames = []; // List of Frame objects currently loaded
    Main.canvas = null;
    Main.ctx = null;
    Main.userZoomFactor = parseFloat(localStorage.zoomLevel);
    Main.sessionFilenames = []; // List of filenames available
    Main.loading = false;
    Main.sessionListContainer = null;
    let init = function () {
        if (isNaN(Main.userZoomFactor)) {
            Main.userZoomFactor = 1;
        }
        // Get DOM nodes and canvas context
        Main.canvas = document.getElementsByTagName("canvas")[0];
        Main.ctx = Main.canvas.getContext("2d");
        Main.sessionListContainer = document.getElementById("session-list");
        // Add mouse listener
        Main.canvas.addEventListener("wheel", function (e) {
            if (e.deltaY > 0) {
                Main.userZoomFactor + .1;
            }
            else {
                Main.userZoomFactor - .1;
            }
            localStorage.zoomLevel = Main.userZoomFactor;
            console.log(localStorage.zoomLevel);
            Drawer.draw();
        });
        // Init units
        SessionLoader.init();
        // Load session list
        SessionList.init();
        // Load last session
        if (typeof localStorage.lastSession != "undefined") {
            SessionLoader.load(localStorage.lastSession);
        }
    };
    addEventListener("DOMContentLoaded", init);
})(Main || (Main = {}));
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
    const yMargin = 30;
    const xMargin = 50;
    const labelEdgeOffset = 10;
    const xLabelYOffset = 10;
    let canvasWidth;
    let scaleY;
    let yMin = null;
    let yMax = null;
    let scaleX;
    let xMax;
    let startTimeUnix;
    function draw() {
        if (Main.frames.length == 0) {
            return;
        }
        xMax = Main.frames.length;
        startTimeUnix = Main.frames[0].timeUnix;
        // Calculate width of canvas based on time resolution, fixed scale factor and user zoom level
        scaleX = Main.userZoomFactor * baseZoomFactor;
        canvasWidth = Main.frames.length * scaleX;
        // Each plot has different frame count, therefore canvas element has different size	
        Main.canvas.width = canvasWidth;
        Main.canvas.height = canvasHeight;
        Main.canvas.style.width = canvasWidth + "";
        // Determine yRange
        let frame;
        for (frame of Main.frames) {
            for (let temp of frame.temps) {
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
        Main.ctx.strokeStyle = "#000";
        Main.ctx.beginPath();
        Main.ctx.font = "1em monospace";
        // Draw horizontal grid lines and axis labels
        let yRelative = 0;
        Main.ctx.textAlign = "right";
        let valueString;
        while (yRelative <= 1) {
            let yValue = yMin + ((yMax - yMin) * (1 - yRelative));
            let yPosition = (canvasHeight - yMargin) * yRelative;
            Main.ctx.moveTo(xMargin, yPosition);
            Main.ctx.lineTo(canvasWidth, yPosition);
            valueString = yValue.toFixed(1);
            // These offsets should be constants!
            let labelYOffset = 4;
            if (yRelative == 0) {
                labelYOffset = 10;
            }
            else if (yRelative == 1) {
                labelYOffset = -10;
            }
            Main.ctx.fillText(valueString, xMargin - labelEdgeOffset, yPosition + labelYOffset);
            yRelative += yGridInterval;
        }
        // Draw vertical grid lines and axis labels
        let xValue = 0;
        while (xValue <= xMax) {
            let xPosition = xMargin + xValue * scaleX;
            Main.ctx.moveTo(xPosition, 0);
            Main.ctx.lineTo(xPosition, canvasHeight - yMargin);
            let timeUnix = startTimeUnix + (xValue / frequencyHz);
            valueString = Util.createTimeLabel(timeUnix);
            if (xValue == 0) {
                Main.ctx.textAlign = "left";
            }
            else if (xValue == xMax) {
                Main.ctx.textAlign = "right";
            }
            else {
                Main.ctx.textAlign = "center";
            }
            Main.ctx.fillText(valueString, xPosition, canvasHeight - xLabelYOffset);
            xValue += xGridInterval;
        }
        Main.ctx.stroke();
        //return;
        for (let sensorIndex = 0; sensorIndex < Main.SENSOR_COLORS.length; sensorIndex++) {
            // Complete drawing of grid
            let color = Main.SENSOR_COLORS[sensorIndex];
            Main.ctx.strokeStyle = color;
            Main.ctx.beginPath();
            // Draw data
            let val = Main.frames[0].temps[sensorIndex];
            Main.ctx.moveTo(xMargin, canvasHeight - ((val - yMin) * scaleY) - yMargin);
            for (let frameIndex = 0; frameIndex < Main.frames.length; frameIndex++) {
                val = Main.frames[frameIndex].temps[sensorIndex];
                let xPos = (frameIndex / frequencyHz) * scaleX + xMargin;
                let yPos = canvasHeight - ((val - yMin) * scaleY) - yMargin;
                Main.ctx.lineTo(xPos, yPos);
                //if(isNaN(yPos)){
                //console.log(yPos);
                //}
            }
            Main.ctx.stroke();
        }
        // Complete drawing of grid
        Main.ctx.strokeStyle = 'black';
        Main.ctx.stroke();
    }
    Drawer.draw = draw;
})(Drawer || (Drawer = {}));
var Frame;
(function (Frame_1) {
    // Deserialize frame
    class Frame {
        constructor(rawFrame) {
            this.temps = [];
            let i = 0;
            let lastIndex = 0;
            while (lastIndex !== -1) {
                let index = rawFrame.indexOf('\t', lastIndex + 1);
                let valueRaw = rawFrame.substr(lastIndex, index - lastIndex);
                if (index == -1) {
                    break;
                }
                if (lastIndex == 0) {
                    this.timeUnix = parseInt(valueRaw);
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
    Frame_1.Frame = Frame;
    ;
})(Frame || (Frame = {}));
var SessionList;
(function (SessionList) {
    // Load list of available log files and initiate load of the last-loaded file
    function init() {
        // Invoke loadSession when clicking on link
        Main.sessionListContainer.addEventListener("click", function (e) {
            let a = e.target;
            localStorage.lastSession = a.getAttribute("href");
            e.preventDefault();
            SessionLoader.load(localStorage.lastSession);
        });
        // Load and display list of files
        let xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function () {
            if (this.readyState != 4)
                return;
            let parser = new DOMParser();
            let doc = parser.parseFromString(xhr.responseText, "text/html");
            let links = doc.querySelectorAll("td a");
            for (let link of links) {
                // Skip link to parent directory
                if (link.outerText == "Parent Directory") {
                    continue;
                }
                Main.sessionFilenames.push(link.getAttribute("href"));
                // Insert the link node into main window
                link.innerText = link.innerText.replaceAll("hc3d-tm-", "");
                link.innerText = link.innerText.replaceAll(".log", "");
                Main.sessionListContainer.appendChild(link);
                Main.sessionListContainer.appendChild(document.createElement("br"));
            }
        };
        // URL is set to Apache directory index containing log file
        let url;
        if (Main.TEST_MODE) {
            url = "testdata/index-of-mnt-data.html";
        }
        else {
            url = "mnt-data/?C=M;O=D";
        }
        xhr.open("GET", url, true);
        // Start the XHR request
        xhr.send();
    }
    SessionList.init = init;
})(SessionList || (SessionList = {}));
var SessionLoader;
(function (SessionLoader) {
    function init() {
        // Periodically obtain last line if the current open file is a live file hc3d-log.log
        setInterval(function () {
            if (Main.loading == false && typeof localStorage.currentSession != "undefined" && localStorage.currentSession == "hc3d-temp.log" && Main.frames.length > 0) {
                let xhr = new XMLHttpRequest();
                xhr.onreadystatechange = function () {
                    if (this.readyState != 4 || this.status != 200)
                        return;
                    let frame = new Frame.Frame(this.responseText);
                    Main.frames.push(frame);
                    Drawer.draw();
                };
                xhr.open("GET", "get_llc_values.php", true);
                xhr.send();
            }
        }, 1000);
    }
    SessionLoader.init = init;
    // Load session data by filename.  
    function load(filename) {
        Main.loading = true;
        Main.frames = [];
        let xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
            if (this.readyState != 4)
                return;
            let responseData = xhttp.responseText;
            let lastIndex = 0;
            while (lastIndex !== -1) {
                let index = responseData.indexOf('\n', lastIndex + 1);
                let line = responseData.substr(lastIndex, index - lastIndex);
                if (line.length > 0) {
                    let frame = new Frame.Frame(line);
                    Main.frames.push(frame);
                }
                if (lastIndex == responseData.length - 1) {
                    break;
                }
                lastIndex = index;
            }
            Main.loading = false;
            Drawer.draw();
        };
        let url;
        if (Main.TEST_MODE) {
            url = "testdata/" + filename;
        }
        else {
            url = "mnt-data/" + filename;
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
        let date = new Date(unixTime * 1000);
        // Hours part from the timestamp
        let hours = date.getHours();
        // Minutes part from the timestamp
        let minutes = "0" + date.getMinutes();
        // Seconds part from the timestamp
        //let seconds = "0" + date.getSeconds();
        // Will display time in 10:30:23 format
        let formattedTime = hours + ':' + minutes.substr(-2); // + ':' + seconds.substr(-2);
        return formattedTime;
    };
})(Util || (Util = {}));
//# sourceMappingURL=main.js.map