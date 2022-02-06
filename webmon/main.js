var ChunkLoader;
(function (ChunkLoader) {
    let framesLoaded = 0;
    function init() {
        setInterval(function () {
            //console.log(Main.Settings.pan + Const.CHUNK_RANGE[Main.Settings.zoom] - (Math.floor(new Date().getTime()/1000)-2));
            if ((Main.Settings.pan + Const.CHUNK_RANGE[Main.Settings.zoom]) > (Math.floor(new Date().getTime() / 1000) - 2)) {
                // Viewing last second; enable live view
                Main.Settings.pan = Math.floor(new Date().getTime() / 1000) - Const.CHUNK_RANGE[Main.Settings.zoom];
                // Reload current right chunk (unless not initialized yet)
                if (Main.rightChunkTime != -1) {
                    // TODO when precisely aligned with chunk, and other edge cases, such as at the right boundary of the right
                    delete Main.chunks[Main.Settings.zoom][Main.rightChunkTime + ""];
                    get(Main.rightChunkTime, Main.Settings.zoom);
                }
            }
        }, 500);
        resetCache();
    }
    ChunkLoader.init = init;
    function resetCache() {
        Main.chunks = [];
        for (let zoom = 0; zoom <= Const.MAX_ZOOM; zoom++) {
            Main.chunks.push({});
        }
    }
    function tick() {
        const zoom = Main.Settings.zoom;
        const leftChunkTime = Main.leftChunkTime;
        const rightChunkTime = Main.rightChunkTime;
        get(leftChunkTime, zoom, function () {
            ChunkLoader.get(rightChunkTime, zoom);
        });
    }
    ChunkLoader.tick = tick;
    // Fetch chunk from cache or backend 
    function get(min, zoom, cb = null) {
        if (typeof Main.chunks[zoom][min + ""] != "undefined") {
            // Cache hit, nothing to fetch
            if (cb != null) {
                cb();
            }
            return;
        }
        // Mark chunk as empty before starting request, to avoid further requests for this chunk until the chunk result is obtained
        Main.chunks[zoom][min + ""] = null;
        // Configure request and set callback
        const modulus = Math.pow(2, zoom);
        let url = Const.URL_SCHEME + Const.HOST + ":" + Const.PORT + "/frames?mode=range&min=" + min + "&max=" + (min + Const.CHUNK_RANGE[Main.Settings.zoom]);
        if (modulus != 1) {
            url += ("&modulus=" + modulus);
        }
        let xhr = new XMLHttpRequest();
        xhr.responseType = 'json';
        xhr.open("GET", url, true);
        xhr.onreadystatechange = function () {
            // Error checking
            if (xhr.readyState != Const.XHR.DONE) {
                // Ignore, wait until state is at XHR.DONE
                return;
            }
            if (xhr.status == 404) {
                // Request succeeded, but no data was found (empty chunk). Invoke the callback regardless.
                Main.chunks[zoom][min + ""] = null; // Mark chunk as confirmed empty
                if (cb != null) {
                    cb();
                }
                return;
            }
            if (xhr.response == null) {
                console.error("ChunkLoader: failed to download, response was null. Is the backend reachable?");
                return;
            }
            if (typeof xhr.response == "string") {
                console.error("ChunkLoader: Error from Prosurd: " + xhr.response);
                return;
            }
            if (typeof xhr.response.time == "undefined") {
                console.error("ChunkLoader: Response is missing the time property.");
                return;
            }
            if (xhr.response.time.length == 0) {
                // If there is no data, 404 should be returned. An empty array is considered an error.
                console.error("ChunkLoader: Empty chunk");
                return;
            }
            // Check cache limit
            framesLoaded += xhr.response.time.length;
            if (framesLoaded > Const.CACHE_MAX_FRAMES) {
                framesLoaded = 0;
                // TODO how to handle cache?
                console.log("Cache was invalidated due to exceeding maximum size of " + Const.CACHE_MAX_FRAMES);
                resetCache();
            }
            // Store chunk
            Main.chunks[zoom][min + ""] = xhr.response;
            // Invalidate the canvas to have it redrawn as new data might change what is drawn
            Main.canvasInvalidated = true;
            // Callback
            if (cb != null) {
                cb();
            }
        };
        xhr.send();
    }
    ChunkLoader.get = get;
    ;
})(ChunkLoader || (ChunkLoader = {}));
var Config;
(function (Config) {
    Config.testMode = false;
})(Config || (Config = {}));
var Const;
(function (Const) {
    Const.URL_SCHEME = "http://";
    Const.HOST = "localhost";
    Const.PORT = 8080;
    Const.SENSOR_COLORS = [
        "#e6194B",
        "#3cb44b",
        "#7d90d6",
        "#f58231",
        "#db7af8",
        "#42d4f4",
        "#f032e6",
        "#469990",
        "#dcbeff",
        "#9A6324",
        "#fffac8",
        "#aaffc3",
        "#ffd8b1",
        "#a9a9a9",
        "#e6194B",
        "#3cb44b",
        "#7d90d6",
        "#f58231",
        "#db7af8",
        "#42d4f4",
        "#f032e6",
        "#469990",
        "#dcbeff",
        "#9A6324",
        "#fffac8",
        "#aaffc3",
        "#808000",
        "#ffd8b1",
        "#a9a9a9",
    ];
    Const.XHR = {
        DONE: 4,
        LOADING: 3,
        HEADERS_RECEIVED: 2,
        OPENED: 1,
        UNSENT: 0
    };
    //export const ZOOM_AFFECTOR = 0.05; Perhaps still needed to set mouse wheel sensitivity
    Const.SIDEBAR_WIDTH = 400; // px; needs to match with values in CSS
    Const.FREQ_HZ = 1; // Assumed frequency of souce data. (timestamps ignored)
    Const.WINDOW_TIME_SPAN_S = 60 * 60; // Display 1 hr of data in one windows' width
    Const.BASE_ZOOM_FACTOR = Const.WINDOW_TIME_SPAN_S / window.innerWidth; // Pixels per frame (pixels per frequencyHz seconds)
    Const.X_GRID_INTERVAL = 0.2; // Relative to graph width
    Const.Y_GRID_INTERVAL = 0.1; // Relative to graph height
    Const.Y_MARGIN = 40;
    Const.X_MARGIN = 50;
    Const.Y_LABEL_X_OFFSET = 10;
    Const.X_LABEL_Y_OFFSET = 20;
    Const.SCROLL_BAR_SIZE = 50; // Needs to be set to browser scroll bar size or larger
    Const.MAX_ZOOM = 13; // 2^13 = ~24hr
    Const.CACHE_MAX_FRAMES = 100000; // ~100 bytes per frame
    Const.CHUNK_RANGE = []; // Delta time per chunk, per zoom level. With modulus of 1, this equals the plot width in pixels.
    Const.CHUNK_SIZE = window.innerWidth - Const.X_MARGIN - Const.SIDEBAR_WIDTH; // Amount of frames in chunk
    Const.STILL_CAPTURE_INTERVAL = 6;
    Const.STILL_WIDTH = 1280; // Dimensions of images taken on frame
    Const.STILL_HEIGHT = 960;
    function init() {
        // Frame count depends on modulus and chunk size, calculated at init 
        for (let zoom = 0; zoom <= Const.MAX_ZOOM; zoom++) {
            // Using an object for this, as the first element can have non-zero value.
            //console.log(zoom);
            Const.CHUNK_RANGE.push(Const.CHUNK_SIZE * Math.pow(2, zoom));
        }
        //console.log(" consolas");
    }
    Const.init = init;
})(Const || (Const = {}));
var JobInfo;
(function (JobInfo) {
    let table;
    function init() {
        // Persist scroll position of the panel (rate limited)
        let frameRequest;
        Main.parameterListContainer.addEventListener("scroll", function (e) {
            if (frameRequest != -1) {
                cancelAnimationFrame(frameRequest);
            }
            frameRequest = requestAnimationFrame(function () {
                frameRequest = -1;
                Main.Settings.parameterListScrollTop = Main.parameterListContainer.scrollTop;
                localStorage.parameterListScrollTop = Main.Settings.parameterListScrollTop;
            });
        });
    }
    JobInfo.init = init;
    function load(jobId) {
        Main.parameterListContainer.innerHTML = "";
        if (jobId == -1) {
            // Only clearing the job panel
            return;
        }
        let url = Const.URL_SCHEME + Const.HOST + ":" + Const.PORT + "/job?job_id=" + jobId;
        let xhr = new XMLHttpRequest();
        xhr.responseType = 'json';
        xhr.open("GET", url, true);
        xhr.onreadystatechange = function () {
            // Error checking
            if (xhr.readyState != Const.XHR.DONE) {
                return;
            }
            if (xhr.response == null) {
                console.error("JobInfo: failed to download, response was null. Is the backend reachable?");
                return;
            }
            if (typeof xhr.response == "undefined") {
                console.error("JobInfo: failed to download, response was undefined. Is the backend reachable?");
                return;
            }
            if (xhr.response.length == 0) {
                console.error("JobInfo: Parameter object length is 0");
                return;
            }
            // Construct table
            table = document.createElement("table");
            addRow("Job ID", jobId + "");
            const downloadUrl = Const.URL_SCHEME + Const.HOST + ":" + Const.PORT + "/file?mode=job&job_id=" + jobId;
            addRow("File", "<a href=\"" + downloadUrl + "\">Download</a>");
            for (let key in xhr.response) {
                let value = xhr.response[key];
                addRow(key, value);
            }
            // Add table to container
            Main.parameterListContainer.appendChild(table);
            // Restore scroll position
            Main.parameterListContainer.scrollTop = Main.Settings.parameterListScrollTop;
        };
        xhr.send();
    }
    JobInfo.load = load;
    function addRow(key, value) {
        let row = document.createElement("tr");
        // Param name
        let keyCell = document.createElement("td");
        keyCell.innerHTML = key;
        row.appendChild(keyCell);
        // Param value
        let valueCell = document.createElement("td");
        valueCell.innerHTML = value;
        row.appendChild(valueCell);
        // Add row
        table.appendChild(row);
    }
})(JobInfo || (JobInfo = {}));
var JobList;
(function (JobList) {
    /*
    onClickSession: loadSession:
    jobId == -1 ? chunkLoader.tick() : loadSession(jobId)
    
    loadSession(jobId):
    mode=job&job_id=${jobId}
    
    onDrag: chunkLoader.tick()
    
    onZoom: chunkLoader.tick()
    
    chunkLoader.tick():
    // Is zoomlevel already logorithmic?
    ZOOM_MULTIPLIER = 150
    modulus = 1.1^zoomLevel || modulus = zoomLevel * ZOOM_MULTIPLIER
    
    leftChunk = Math.floor(startX / chunkSize[modulus]) * chunkSize[modulus]
    rightChunk = Math.round(startX / chunkSize[modulus]) * chunkSize[modulus]
    
    if(typeof cache[modulus][leftChunk] == "undefined"){
    cache[modulus][leftChunk] = download(mode=range&min = leftChunk & max = leftChunk+chunkSize[modulus] & modulus = modulus)
    }
    
    if(undefined){
    cache[modulus][leftChunk] = download(mode=range&min = rightChunk & max = rightChunk+chunkSize[modulus] & modulus = modulus)
    }
    
    
    drawer.tick():
    for(let x = minX; x < maxX; i++){
    chunk = Math.round(x / chunkSize[modulus])
    frame = cache[modulus][chunk][x];
    render(frame)
    }
    */
    // Load list of available log files and initiate load of the last-loaded file
    function init() {
        // Mark the correct link as selected
        /*for(let linkIndex in SessionList.addedLinks){
            let link = SessionList.addedLinks[linkIndex];
            let linkFilename = link.href.substring(link.href.lastIndexOf('/')+1);
            if(linkFilename == filename){
                link.style.border = "1px solid black";
            }else{
                link.style.border = "none";
            }
        }*/
        // Pan the plotter and load job data when clicking on a job
        Main.jobListContainer.addEventListener("click", function (e) {
            e.preventDefault();
            let link = e.target;
            const time = parseInt(link.dataset.time);
            if (time != Main.Settings.pan) {
                Main.Settings.pan = time;
                //console.log(Main.Settings.pan);
                Main.canvasInvalidated = true;
            }
        });
        // Persist scroll position of the panel (rate limited)
        let frameRequest;
        Main.jobListContainer.addEventListener("scroll", function (e) {
            if (frameRequest != -1) {
                cancelAnimationFrame(frameRequest);
            }
            frameRequest = requestAnimationFrame(function () {
                frameRequest = -1;
                Main.Settings.jobListScrollTop = Main.jobListContainer.scrollTop;
                localStorage.jobListScrollTop = Main.Settings.jobListScrollTop;
            });
        });
        // Load and display list of files
        let xhr = new XMLHttpRequest();
        xhr.responseType = 'json';
        xhr.onreadystatechange = function () {
            if (xhr.readyState != Const.XHR.DONE) {
                return;
            }
            if (xhr.response == null) {
                console.error("JobList: Failed to download, response was null. Is the backend reachable?");
                return;
            }
            JobList.addedLinks = [];
            for (let job of xhr.response) {
                const link = document.createElement("a");
                // Link is only used to allow user to navigate to the url, perhaps for downloading data to disk
                link.href = "http://" + Const.HOST + ":" + Const.PORT + "/frames?mode=job&job_id=" + job.job_id;
                // Cap values beyond ~2032; some test data has timestamps all the way in the upcoming dyson-sphere epoch; within the int64_t allowed limit, but not within JavaScript's 32-bit floating point Numbers.
                if (job.time > 1957071184) {
                    job.time = 1957071184;
                }
                link.dataset.time = job.time;
                const dateTimeString = Util.createTimeLabel(job.time);
                const jobName = job.job_file_name.replace("0:/gcodes/", "").replace(".gcode", "");
                link.innerText = jobName + "(" + dateTimeString + ")";
                //link.innerText = job.time + "";
                JobList.addedLinks.push(link);
                Main.jobListContainer.appendChild(link);
                Main.jobListContainer.appendChild(document.createElement("br"));
            }
            // Restore scroll position
            Main.jobListContainer.scrollTop = Main.Settings.jobListScrollTop;
        };
        // URL is set to Apache directory index containing log file
        let url;
        url = Const.URL_SCHEME + Const.HOST + ":" + Const.PORT + "/jobs";
        xhr.open("GET", url, true);
        // Start the XHR request
        xhr.send();
    }
    JobList.init = init;
})(JobList || (JobList = {}));
var Logger;
(function (Logger) {
    let lastTime = new Date().getTime();
    function i(msg) {
        let time = new Date().getTime();
        console.log("[" + (time - lastTime) + "] " + msg);
        lastTime = time;
    }
    Logger.i = i;
})(Logger || (Logger = {}));
var Main;
(function (Main) {
    // Elements
    Main.canvas = null;
    // Settings stored in local storage
    let Settings;
    (function (Settings) {
        Settings.selectedColumns = typeof localStorage.selectedColumns == "undefined" ? {} : JSON.parse(localStorage.selectedColumns);
        Settings.zoom = isNaN(localStorage.zoom) ? 1 : parseFloat(localStorage.zoom);
        Settings.pan = isNaN(localStorage.pan) ? Math.floor(new Date().getTime() / 1000) : parseFloat(localStorage.pan);
        Settings.jobListScrollTop = isNaN(localStorage.jobListScrollTop) ? 0 : parseFloat(localStorage.jobListScrollTop);
        Settings.parameterListScrollTop = isNaN(localStorage.parameterListScrollTop) ? 0 : parseFloat(localStorage.parameterListScrollTop);
    })(Settings = Main.Settings || (Main.Settings = {}));
    // Derrived from Settings before or during drawing each frame
    Main.leftChunkTime = -1; // Updated prior
    Main.rightChunkTime = -1; // Updated prior
    Main.jobId = -1; // Updated during drawing
    // Chunk holder (chunky)
    Main.chunks = null;
    Main.canvasInvalidated = true;
    let init = function () {
        // Get elements
        Main.jobListContainer = document.getElementById("job-list");
        Main.mouseValueContainer = document.getElementById("mouse-value");
        Main.parameterListContainer = document.getElementById("parameter-list");
        Main.timelineContainer = document.getElementById("timeline");
        Main.legend = document.getElementById("legend");
        Main.canvas = document.getElementsByTagName("canvas")[0];
        // Init
        Const.init();
        Plotter.init();
        ChunkLoader.init();
        Timeline.init();
        JobList.init();
        JobInfo.init();
        MouseControl.init();
        draw();
    };
    function draw() {
        if (Main.canvasInvalidated) {
            Main.canvasInvalidated = false;
            const range = Const.CHUNK_RANGE[Main.Settings.zoom];
            Main.leftChunkTime = Math.floor(Main.Settings.pan / range) * range;
            Main.rightChunkTime = Main.leftChunkTime + range;
            ChunkLoader.tick();
            Timeline.tick();
            Plotter.draw();
            localStorage.pan = Main.Settings.pan;
            //console.log("Persisting: " + localStorage.pan);
            localStorage.zoom = Main.Settings.zoom;
        }
        requestAnimationFrame(draw);
    }
    Main.draw = draw;
    addEventListener("DOMContentLoaded", init);
})(Main || (Main = {}));
var MouseControl;
(function (MouseControl) {
    let label;
    // Mouse panning
    let isDown = false;
    let startX;
    function init() {
        label = document.getElementById("zoom-level");
        updateLabel();
        // Add mouse listener
        Main.canvas.addEventListener("wheel", function (e) {
            const liveView = Main.Settings.pan + Const.CHUNK_RANGE[Main.Settings.zoom] > (Math.floor(new Date().getTime() / 1000) - 1);
            // Every event, mutate zoom level by 1.
            if (e.deltaY < 0 && Main.Settings.zoom < Const.MAX_ZOOM) {
                Main.Settings.zoom += 1;
            }
            else if (e.deltaY > 0 && Main.Settings.zoom > 0) {
                Main.Settings.zoom -= 1;
            }
            updateLabel();
            if (liveView) {
                // Ensure panning to live data as before the zoom changed to ensure auto-refresh stays active
                Main.Settings.pan = Math.floor(new Date().getTime() / 1000) - Const.CHUNK_RANGE[Main.Settings.zoom];
            }
            Main.canvasInvalidated = true;
        });
        Main.canvas.addEventListener("mousedown", e => {
            if (e.button != 0) {
                // Ignore if not left button
                return;
            }
            isDown = true;
            startX = e.pageX;
        });
        addEventListener("mouseout", (e) => {
            if (e.toElement == null) {
                // We moved out of the browser window, stop tracking the mouse, otherwise, keep tracking it
                isDown = false;
            }
        });
        addEventListener("mouseup", (e) => {
            isDown = false;
        });
        addEventListener("mousemove", e => {
            // Update value label
            Plotter.onMouseMove(e.offsetX, e.offsetY);
            if (!isDown)
                return;
            e.preventDefault();
            // Mouse movement in pixels
            const walkPixels = (e.pageX - startX);
            // Update startX for next event
            startX = e.pageX;
            const plotWidth = (Main.canvas.width - Const.X_MARGIN);
            const walkTime = (walkPixels / plotWidth) * Const.CHUNK_RANGE[Main.Settings.zoom];
            Main.Settings.pan -= Math.round(walkTime);
            // Limit maximum pan to current time
            if (Main.Settings.pan + Const.CHUNK_RANGE[Main.Settings.zoom] > Math.floor(new Date().getTime() / 1000)) {
                Main.Settings.pan = Math.floor(new Date().getTime() / 1000) - Const.CHUNK_RANGE[Main.Settings.zoom];
            }
            Main.canvasInvalidated = true;
        });
    }
    MouseControl.init = init;
    function updateLabel() {
        label.innerText = "" + (Math.round(Main.Settings.zoom * 1000) / 1000);
    }
    MouseControl.updateLabel = updateLabel;
})(MouseControl || (MouseControl = {}));
var Plotter;
(function (Plotter) {
    // Main.canvas and context
    Plotter.ctx = null;
    function init() {
        // Get DOM nodes and Main.canvas context
        Plotter.ctx = Main.canvas.getContext("2d");
        Main.mouseValueContainer.innerText = (0).toFixed(2);
        addEventListener("resize", function () {
            if (Main.leftChunkTime == -1) {
                // Only redraw upon resize after first frame is drawn
                return;
            }
            requestAnimationFrame(function () {
                draw();
            });
        });
    }
    Plotter.init = init;
    let yMin = 0;
    let yMax = 0;
    function onMouseMove(x, y) {
        let yValue = (Math.round(100 * ((yMax - yMin) * (1 - (y / (Main.canvas.height - Const.Y_MARGIN))) + yMin)) / 100).toFixed(2);
        Main.mouseValueContainer.innerText = yValue;
    }
    Plotter.onMouseMove = onMouseMove;
    function draw() {
        Main.canvas.width = Main.canvas.clientWidth;
        Main.canvas.height = Main.canvas.clientHeight;
        const leftChunkTime = Main.leftChunkTime;
        const rightChunkTime = Main.rightChunkTime;
        const zoom = Main.Settings.zoom;
        const leftChunk = typeof Main.chunks[zoom][leftChunkTime + ""] != "undefined" ? Main.chunks[zoom][leftChunkTime + ""] : null;
        const rightChunk = typeof Main.chunks[zoom][rightChunkTime + ""] != "undefined" ? Main.chunks[zoom][rightChunkTime + ""] : null;
        const chunkRange = Const.CHUNK_RANGE[zoom];
        const pan = Main.Settings.pan;
        const columns = [];
        const allColumns = [];
        const initialChunkOffset = Math.floor(((pan % chunkRange) / chunkRange) * Const.CHUNK_SIZE);
        // If there is data in any of the chunks, update legend, obtain user-selected column list and determine y-range
        if (leftChunk != null || rightChunk != null) {
            // Pick any non-null chunk
            const chunk = leftChunk != null ? leftChunk : rightChunk;
            // Obtain numerical columns
            for (let column in chunk) {
                if (typeof chunk[column][0] != "number") {
                    // We are here to plot numbers and numbers only. Understood?
                    continue;
                }
                allColumns.push(column);
            }
            // Update legend based on columns present in the data
            // Create checkboxes for toggling the columns and attach a handler for when they are clicked
            Main.legend.innerText = "";
            for (let i = 0; i < allColumns.length; i++) {
                let column = allColumns[i];
                let color = typeof Const.SENSOR_COLORS[i] != "undefined" ? Const.SENSOR_COLORS[i] : "white";
                // Create checkbox to toggle column
                const radio = document.createElement("input");
                // Columns are checked off unless a user setting with value "true" is present
                radio.checked = typeof Main.Settings.selectedColumns[column] != "undefined" && Main.Settings.selectedColumns[column];
                radio.type = "checkbox";
                radio.onclick = function (e) {
                    // Store choice in memory and flush to local storage
                    Main.Settings.selectedColumns[column] = radio.checked;
                    localStorage.selectedColumns = JSON.stringify(Main.Settings.selectedColumns);
                    Main.canvasInvalidated = true;
                };
                radio.id = column;
                radio.value = column;
                const label = document.createElement("label");
                label.htmlFor = column;
                label.style.color = color;
                label.innerText = column.toUpperCase();
                Main.legend.appendChild(radio);
                Main.legend.appendChild(label);
                Main.legend.appendChild(document.createElement("br"));
            }
            // List the user-selected columns if they are also present in the data
            for (let column of allColumns) {
                if (typeof Main.Settings.selectedColumns[column] != "undefined" && Main.Settings.selectedColumns[column]) {
                    columns.push(column);
                }
            }
            // Determine y-range
            yMin = 0;
            yMax = 0;
            for (let column of columns) {
                let chunks = [];
                if (leftChunk != null) {
                    chunks.push(leftChunk);
                }
                if (rightChunk != null) {
                    chunks.push(rightChunk);
                }
                for (let chunk of chunks) {
                    // Fetch value from the correct chunk
                    for (let val of chunk[column]) {
                        // Update min and max as appropriate
                        if (val < yMin || yMin == null) {
                            yMin = val;
                        }
                        if (val > yMax || yMax == null) {
                            yMax = val;
                        }
                    }
                }
            }
        }
        // Apply fallback y-range if needed (in the case of no data or other edge cases)
        if (yMin == null || yMax == 0 || !Number.isFinite(yMin) || !Number.isFinite(yMax) || isNaN(yMin) || isNaN(yMax) || Math.abs(yMax - yMin) == 0) {
            // Unable to calculate range, set artifical range 1 below and 1 above current value, which should center the line if there is a line at all
            yMin = 1;
            yMax = 1;
        }
        // Calculate drawing scale
        const scaleY = (Main.canvas.height - Const.Y_MARGIN) / (yMax - yMin);
        // Start drawing grid 
        Plotter.ctx.strokeStyle = "#909090"; // Grid and axis color
        Plotter.ctx.fillStyle = "white"; // Text color
        Plotter.ctx.beginPath();
        Plotter.ctx.font = "1em monospace";
        // Draw horizontal grid lines and y axis labels
        let yRelative = 0;
        Plotter.ctx.textAlign = "right";
        let valueString;
        while (yRelative <= 1) {
            let yValue = yMin + ((yMax - yMin) * (1 - yRelative));
            let yPosition = (Main.canvas.height - Const.Y_MARGIN) * yRelative;
            Plotter.ctx.moveTo(Const.X_MARGIN, yPosition);
            Plotter.ctx.lineTo(Main.canvas.width, yPosition);
            valueString = yValue.toFixed(1);
            // These offsets should be constants!
            let ylabelYOffset = 4;
            if (yRelative == 0) {
                ylabelYOffset = 10;
            }
            else if (yRelative == 1) {
                ylabelYOffset = -10;
            }
            Plotter.ctx.fillText(valueString, Const.X_MARGIN - Const.Y_LABEL_X_OFFSET, yPosition + ylabelYOffset);
            yRelative += Const.Y_GRID_INTERVAL;
        }
        // Draw vertical grid lines and x axis labels
        let xRelative = 0;
        while (xRelative <= 1) {
            const xPosition = Const.X_MARGIN + xRelative * (Main.canvas.width - Const.X_MARGIN);
            Plotter.ctx.moveTo(xPosition, 0);
            Plotter.ctx.lineTo(xPosition, Main.canvas.height - Const.Y_MARGIN);
            let timeUnix = Main.Settings.pan + Const.CHUNK_RANGE[zoom] * xRelative;
            valueString = Util.createTimeLabel(timeUnix);
            if (xRelative == 0) {
                Plotter.ctx.textAlign = "left";
            }
            else if (xRelative == 1) { // The rounding here is a bit hacky.
                Plotter.ctx.textAlign = "right";
            }
            else {
                Plotter.ctx.textAlign = "center";
            }
            Plotter.ctx.fillText(valueString, xPosition, Main.canvas.height - Const.X_LABEL_Y_OFFSET);
            xRelative += Const.X_GRID_INTERVAL;
        }
        Plotter.ctx.stroke();
        // Plot the data if at least one of the chunks are non-null
        if (leftChunk != null || rightChunk != null) {
            // Load new job data if jobId changed. Clear job panel if no job in first frame
            let jobId = -1;
            if (leftChunk != null && typeof leftChunk.job_id != "undefined" && initialChunkOffset < leftChunk.job_id.length) {
                // Offset still within left chunk
                jobId = leftChunk.job_id[initialChunkOffset];
            }
            else if (rightChunk != null && typeof rightChunk != "undefined" && initialChunkOffset > Const.CHUNK_SIZE && initialChunkOffset % Const.CHUNK_SIZE < rightChunk.job_id.length) {
                // Offset beyond left chunk and within right chunk
                jobId = rightChunk.job_id[initialChunkOffset * Const.CHUNK_SIZE];
            }
            if (jobId != Main.jobId) {
                // Job ID has changed; persist it and trigger job load
                Main.jobId = jobId;
                JobInfo.load(jobId);
            }
            let test = 0;
            // Draw data for each column
            for (let colno = 0; colno < columns.length; colno++) {
                // Get index of column in full column list in order to pick the color
                let color;
                let column = columns[colno];
                for (let allcolno = 0; allcolno < allColumns.length; allcolno++) {
                    if (allColumns[allcolno] == column) {
                        color = Const.SENSOR_COLORS[allcolno];
                        break;
                    }
                }
                // Get colname, set color, start path
                Plotter.ctx.strokeStyle = color;
                Plotter.ctx.beginPath();
                let startLine = true;
                let test = 0;
                for (let plotIndex = 0; plotIndex < Const.CHUNK_SIZE; plotIndex++) {
                    let chunkOffset = initialChunkOffset + plotIndex;
                    let val;
                    //console.log(chunkOffset + " en " + chunkOffset % Const.CHUNK_SIZE);
                    if (leftChunk != null && chunkOffset < leftChunk.time.length) {
                        // Offset still within left chunk
                        val = leftChunk[column][chunkOffset];
                    }
                    else if (rightChunk != null && chunkOffset > Const.CHUNK_SIZE && (chunkOffset % Const.CHUNK_SIZE) < rightChunk.time.length) {
                        // Offset beyond left chunk and within right chunk
                        val = rightChunk[column][chunkOffset % Const.CHUNK_SIZE];
                    }
                    else {
                        // No data for this plot index. Prevent next line (if any) from connecting with the last drawn data.
                        startLine = true;
                        continue;
                    }
                    let x = Const.X_MARGIN + Math.round(((plotIndex / Const.CHUNK_SIZE) * (Main.canvas.width - Const.X_MARGIN)));
                    let y = Main.canvas.height - Math.round(((val - yMin) * scaleY)) - Const.Y_MARGIN;
                    if (startLine) {
                        //console.log("moveTo " + x + ", " + " " + y);
                        Plotter.ctx.moveTo(x, y);
                        startLine = false;
                    }
                    else {
                        //console.log("lineTo " + x + ", " + " " + y);
                        Plotter.ctx.lineTo(x, y);
                        test++;
                    }
                }
                Plotter.ctx.stroke();
            }
            // Complete drawing of grid
            Plotter.ctx.stroke();
        }
    }
    Plotter.draw = draw;
})(Plotter || (Plotter = {}));
var Timeline;
(function (Timeline) {
    let images = [];
    let containerHeight;
    let containerWidth;
    let imageScaleFactor;
    let imageWidth;
    let imageHeight;
    const imageCount = 1 / Const.X_GRID_INTERVAL;
    let imageRange; // Image width expressed as time range
    function init() {
        containerHeight = Main.timelineContainer.clientHeight;
        containerWidth = Main.timelineContainer.clientWidth;
        imageWidth = Math.round(containerWidth / imageCount);
        imageScaleFactor = imageWidth / Const.STILL_WIDTH;
        imageHeight = Const.STILL_HEIGHT * imageScaleFactor;
        imageRange = Const.CHUNK_RANGE[Main.Settings.zoom] / imageCount;
        //imageCount = Math.ceil(containerWidth / imageWidth) + 1; // One more image is needed; when panning the images, the screen is to remain filled
        for (let i = 0; i < imageCount; i++) {
            let img = document.createElement("img");
            img.onload = function () {
                img.style.visibility = "initial";
            };
            img.onerror = function () {
                img.style.visibility = "hidden";
            };
            img.width = imageWidth;
            img.height = imageHeight; // Optional
            images.push(img);
            Main.timelineContainer.appendChild(img);
        }
    }
    Timeline.init = init;
    // Pan the images and update the src attributes
    function tick() {
        let exactTime = Main.Settings.pan;
        for (let i = 0; i < imageCount; i++) {
            // Closest matching 6th frame, as still are only taken on 6th frames
            let time = exactTime - (exactTime % Const.STILL_CAPTURE_INTERVAL);
            images[i].style.visibility = "hidden";
            images[i].src = Const.URL_SCHEME + Const.HOST + ":" + Const.PORT + "/file?mode=still&still_id=0&time=" + time;
            exactTime += imageRange;
        }
        const startTime = Main.Settings.pan;
    }
    Timeline.tick = tick;
})(Timeline || (Timeline = {}));
var Util;
(function (Util) {
    // Based on: https://stackoverflow.com/a/847196
    Util.createTimeLabel = function (unixTime) {
        // Method A (well-mannered, ill-advised)
        //return new Date(unixTime * 1000).toLocaleString();
        // Method B (intelligent)
        return new Date(unixTime * 1000).toJSON().replace("T", " ").slice(0, 16);
        // Method C (artisanal, against recommendation)
        /*let date = new Date(unixTime * 1000);
        let year = date.getFullYear();
        let month = ("0" + (date.getMonth()+1)).substr(-1);
        let day = "0" + date.getDate();
        let hours = "0" + date.getHours();
        let minutes = "0" + date.getMinutes();
        let seconds = "0" + date.getSeconds();
        let formattedTime = year + "-" + month + "-" + day + " " + hours.substr(-2) + ':' + minutes.substr(-2) + '.' + seconds.substr(-2);
        return formattedTime;*/
    };
})(Util || (Util = {}));
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoibWFpbi5qcyIsInNvdXJjZVJvb3QiOiIuLi90cy8iLCJzb3VyY2VzIjpbIkNodW5rTG9hZGVyLnRzIiwiQ29uZmlnLnRzIiwiQ29uc3QudHMiLCJKb2JJbmZvLnRzIiwiSm9iTGlzdC50cyIsIkxvZ2dlci50cyIsIk1haW4udHMiLCJNb3VzZUNvbnRyb2wudHMiLCJQbG90dGVyLnRzIiwiVGltZWxpbmUudHMiLCJVdGlsLnRzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiJBQUFBLElBQVUsV0FBVyxDQW1IcEI7QUFuSEQsV0FBVSxXQUFXO0lBQ2pCLElBQUksWUFBWSxHQUFHLENBQUMsQ0FBQztJQUVyQixTQUFnQixJQUFJO1FBQ2hCLFdBQVcsQ0FBQztZQUNSLHFIQUFxSDtZQUNySCxJQUFHLENBQUMsSUFBSSxDQUFDLFFBQVEsQ0FBQyxHQUFHLEdBQUcsS0FBSyxDQUFDLFdBQVcsQ0FBQyxJQUFJLENBQUMsUUFBUSxDQUFDLElBQUksQ0FBQyxDQUFDLEdBQUcsQ0FBQyxJQUFJLENBQUMsS0FBSyxDQUFDLElBQUksSUFBSSxFQUFFLENBQUMsT0FBTyxFQUFFLEdBQUMsSUFBSSxDQUFDLEdBQUMsQ0FBQyxDQUFDLEVBQUM7Z0JBQ3ZHLHdDQUF3QztnQkFDeEMsSUFBSSxDQUFDLFFBQVEsQ0FBQyxHQUFHLEdBQUcsSUFBSSxDQUFDLEtBQUssQ0FBQyxJQUFJLElBQUksRUFBRSxDQUFDLE9BQU8sRUFBRSxHQUFDLElBQUksQ0FBQyxHQUFHLEtBQUssQ0FBQyxXQUFXLENBQUMsSUFBSSxDQUFDLFFBQVEsQ0FBQyxJQUFJLENBQUMsQ0FBQztnQkFFbEcsMERBQTBEO2dCQUMxRCxJQUFHLElBQUksQ0FBQyxjQUFjLElBQUksQ0FBQyxDQUFDLEVBQUM7b0JBQ3pCLDJHQUEyRztvQkFDM0csT0FBTyxJQUFJLENBQUMsTUFBTSxDQUFDLElBQUksQ0FBQyxRQUFRLENBQUMsSUFBSSxDQUFDLENBQUMsSUFBSSxDQUFDLGNBQWMsR0FBRyxFQUFFLENBQUMsQ0FBQztvQkFDakUsR0FBRyxDQUFDLElBQUksQ0FBQyxjQUFjLEVBQUUsSUFBSSxDQUFDLFFBQVEsQ0FBQyxJQUFJLENBQUMsQ0FBQztpQkFDaEQ7YUFFSjtRQUNMLENBQUMsRUFBRSxHQUFHLENBQUMsQ0FBQztRQUNSLFVBQVUsRUFBRSxDQUFDO0lBQ2pCLENBQUM7SUFqQmUsZ0JBQUksT0FpQm5CLENBQUE7SUFFRCxTQUFTLFVBQVU7UUFDZixJQUFJLENBQUMsTUFBTSxHQUFHLEVBQUUsQ0FBQztRQUNqQixLQUFJLElBQUksSUFBSSxHQUFHLENBQUMsRUFBRSxJQUFJLElBQUksS0FBSyxDQUFDLFFBQVEsRUFBRSxJQUFJLEVBQUUsRUFBQztZQUM3QyxJQUFJLENBQUMsTUFBTSxDQUFDLElBQUksQ0FBQyxFQUFFLENBQUMsQ0FBQztTQUN4QjtJQUNMLENBQUM7SUFFRCxTQUFnQixJQUFJO1FBQ2hCLE1BQU0sSUFBSSxHQUFHLElBQUksQ0FBQyxRQUFRLENBQUMsSUFBSSxDQUFDO1FBQ2hDLE1BQU0sYUFBYSxHQUFHLElBQUksQ0FBQyxhQUFhLENBQUM7UUFDekMsTUFBTSxjQUFjLEdBQUcsSUFBSSxDQUFDLGNBQWMsQ0FBQztRQUMzQyxHQUFHLENBQUMsYUFBYSxFQUFFLElBQUksRUFBRTtZQUNyQixXQUFXLENBQUMsR0FBRyxDQUFDLGNBQWMsRUFBRSxJQUFJLENBQUMsQ0FBQztRQUMxQyxDQUFDLENBQUMsQ0FBQztJQUNQLENBQUM7SUFQZSxnQkFBSSxPQU9uQixDQUFBO0lBRUQscUNBQXFDO0lBQ3JDLFNBQWdCLEdBQUcsQ0FBQyxHQUFXLEVBQUUsSUFBWSxFQUFFLEtBQWlCLElBQUk7UUFDaEUsSUFBRyxPQUFPLElBQUksQ0FBQyxNQUFNLENBQUMsSUFBSSxDQUFDLENBQUMsR0FBRyxHQUFHLEVBQUUsQ0FBQyxJQUFJLFdBQVcsRUFBQztZQUNqRCw4QkFBOEI7WUFDOUIsSUFBRyxFQUFFLElBQUksSUFBSSxFQUFDO2dCQUNWLEVBQUUsRUFBRSxDQUFDO2FBQ1I7WUFDRCxPQUFPO1NBQ1Y7UUFFRCwySEFBMkg7UUFDM0gsSUFBSSxDQUFDLE1BQU0sQ0FBQyxJQUFJLENBQUMsQ0FBQyxHQUFHLEdBQUcsRUFBRSxDQUFDLEdBQUcsSUFBSSxDQUFDO1FBRW5DLHFDQUFxQztRQUNyQyxNQUFNLE9BQU8sR0FBRyxJQUFJLENBQUMsR0FBRyxDQUFDLENBQUMsRUFBRSxJQUFJLENBQUMsQ0FBQztRQUNsQyxJQUFJLEdBQUcsR0FBRyxLQUFLLENBQUMsVUFBVSxHQUFHLEtBQUssQ0FBQyxJQUFJLEdBQUcsR0FBRyxHQUFHLEtBQUssQ0FBQyxJQUFJLEdBQUcseUJBQXlCLEdBQUcsR0FBRyxHQUFHLE9BQU8sR0FBRyxDQUFDLEdBQUcsR0FBRyxLQUFLLENBQUMsV0FBVyxDQUFDLElBQUksQ0FBQyxRQUFRLENBQUMsSUFBSSxDQUFDLENBQUMsQ0FBQztRQUN2SixJQUFHLE9BQU8sSUFBSSxDQUFDLEVBQUM7WUFDWixHQUFHLElBQUksQ0FBQyxXQUFXLEdBQUcsT0FBTyxDQUFDLENBQUM7U0FDbEM7UUFDRCxJQUFJLEdBQUcsR0FBRyxJQUFJLGNBQWMsRUFBRSxDQUFDO1FBQy9CLEdBQUcsQ0FBQyxZQUFZLEdBQUcsTUFBTSxDQUFDO1FBQzFCLEdBQUcsQ0FBQyxJQUFJLENBQUMsS0FBSyxFQUFFLEdBQUcsRUFBRSxJQUFJLENBQUMsQ0FBQztRQUMzQixHQUFHLENBQUMsa0JBQWtCLEdBQUc7WUFDckIsaUJBQWlCO1lBQ2pCLElBQUcsR0FBRyxDQUFDLFVBQVUsSUFBSSxLQUFLLENBQUMsR0FBRyxDQUFDLElBQUksRUFBQztnQkFDaEMsMENBQTBDO2dCQUMxQyxPQUFPO2FBQ1Y7WUFDRCxJQUFHLEdBQUcsQ0FBQyxNQUFNLElBQUksR0FBRyxFQUFDO2dCQUNqQiwwRkFBMEY7Z0JBQzFGLElBQUksQ0FBQyxNQUFNLENBQUMsSUFBSSxDQUFDLENBQUMsR0FBRyxHQUFHLEVBQUUsQ0FBQyxHQUFHLElBQUksQ0FBQyxDQUFDLGdDQUFnQztnQkFDcEUsSUFBRyxFQUFFLElBQUksSUFBSSxFQUFDO29CQUNWLEVBQUUsRUFBRSxDQUFDO2lCQUNSO2dCQUNELE9BQU87YUFDVjtZQUNELElBQUcsR0FBRyxDQUFDLFFBQVEsSUFBSSxJQUFJLEVBQUM7Z0JBQ3BCLE9BQU8sQ0FBQyxLQUFLLENBQUMsK0VBQStFLENBQUMsQ0FBQztnQkFDL0YsT0FBTzthQUNWO1lBQ0QsSUFBRyxPQUFPLEdBQUcsQ0FBQyxRQUFRLElBQUksUUFBUSxFQUFDO2dCQUMvQixPQUFPLENBQUMsS0FBSyxDQUFDLG1DQUFtQyxHQUFHLEdBQUcsQ0FBQyxRQUFRLENBQUMsQ0FBQztnQkFDbEUsT0FBTzthQUNWO1lBQ0QsSUFBRyxPQUFPLEdBQUcsQ0FBQyxRQUFRLENBQUMsSUFBSSxJQUFJLFdBQVcsRUFBQztnQkFDdkMsT0FBTyxDQUFDLEtBQUssQ0FBQyxxREFBcUQsQ0FBQyxDQUFDO2dCQUNyRSxPQUFPO2FBQ1Y7WUFDRCxJQUFHLEdBQUcsQ0FBQyxRQUFRLENBQUMsSUFBSSxDQUFDLE1BQU0sSUFBSSxDQUFDLEVBQUM7Z0JBQzdCLHNGQUFzRjtnQkFDdEYsT0FBTyxDQUFDLEtBQUssQ0FBQywwQkFBMEIsQ0FBQyxDQUFDO2dCQUMxQyxPQUFPO2FBQ1Y7WUFFRCxvQkFBb0I7WUFDcEIsWUFBWSxJQUFJLEdBQUcsQ0FBQyxRQUFRLENBQUMsSUFBSSxDQUFDLE1BQU0sQ0FBQztZQUN6QyxJQUFHLFlBQVksR0FBRyxLQUFLLENBQUMsZ0JBQWdCLEVBQUM7Z0JBQ3JDLFlBQVksR0FBRyxDQUFDLENBQUM7Z0JBQ2pCLDRCQUE0QjtnQkFDNUIsT0FBTyxDQUFDLEdBQUcsQ0FBQyx5REFBeUQsR0FBRyxLQUFLLENBQUMsZ0JBQWdCLENBQUMsQ0FBQztnQkFDaEcsVUFBVSxFQUFFLENBQUM7YUFDaEI7WUFFRCxjQUFjO1lBQ2QsSUFBSSxDQUFDLE1BQU0sQ0FBQyxJQUFJLENBQUMsQ0FBQyxHQUFHLEdBQUcsRUFBRSxDQUFDLEdBQUcsR0FBRyxDQUFDLFFBQVEsQ0FBQztZQUUzQyxrRkFBa0Y7WUFDbEYsSUFBSSxDQUFDLGlCQUFpQixHQUFHLElBQUksQ0FBQztZQUU5QixXQUFXO1lBQ1gsSUFBRyxFQUFFLElBQUksSUFBSSxFQUFDO2dCQUNWLEVBQUUsRUFBRSxDQUFDO2FBQ1I7UUFDTCxDQUFDLENBQUM7UUFDRixHQUFHLENBQUMsSUFBSSxFQUFFLENBQUM7SUFDZixDQUFDO0lBMUVlLGVBQUcsTUEwRWxCLENBQUE7SUFBQSxDQUFDO0FBRU4sQ0FBQyxFQW5IUyxXQUFXLEtBQVgsV0FBVyxRQW1IcEI7QUNuSEQsSUFBVSxNQUFNLENBRWY7QUFGRCxXQUFVLE1BQU07SUFDRCxlQUFRLEdBQUcsS0FBSyxDQUFDO0FBQ2hDLENBQUMsRUFGUyxNQUFNLEtBQU4sTUFBTSxRQUVmO0FDRkQsSUFBVSxLQUFLLENBNEVkO0FBNUVELFdBQVUsS0FBSztJQUVFLGdCQUFVLEdBQUcsU0FBUyxDQUFDO0lBQ3ZCLFVBQUksR0FBRyxXQUFXLENBQUM7SUFDbkIsVUFBSSxHQUFHLElBQUksQ0FBQztJQUVaLG1CQUFhLEdBQUc7UUFDekIsU0FBUztRQUNULFNBQVM7UUFDVCxTQUFTO1FBQ1QsU0FBUztRQUNULFNBQVM7UUFDVCxTQUFTO1FBQ1QsU0FBUztRQUNULFNBQVM7UUFDVCxTQUFTO1FBQ1QsU0FBUztRQUNULFNBQVM7UUFDVCxTQUFTO1FBQ1QsU0FBUztRQUNULFNBQVM7UUFDVCxTQUFTO1FBQ1QsU0FBUztRQUNULFNBQVM7UUFDVCxTQUFTO1FBQ1QsU0FBUztRQUNULFNBQVM7UUFDVCxTQUFTO1FBQ1QsU0FBUztRQUNULFNBQVM7UUFDVCxTQUFTO1FBQ1QsU0FBUztRQUNULFNBQVM7UUFDVCxTQUFTO1FBQ1QsU0FBUztRQUNULFNBQVM7S0FDWixDQUFDO0lBRVcsU0FBRyxHQUFHO1FBQ2YsSUFBSSxFQUFFLENBQUM7UUFDUCxPQUFPLEVBQUUsQ0FBQztRQUNWLGdCQUFnQixFQUFFLENBQUM7UUFDbkIsTUFBTSxFQUFFLENBQUM7UUFDVCxNQUFNLEVBQUUsQ0FBQztLQUVaLENBQUM7SUFFRix3RkFBd0Y7SUFDM0UsbUJBQWEsR0FBRyxHQUFHLENBQUMsQ0FBQyx3Q0FBd0M7SUFDN0QsYUFBTyxHQUFHLENBQUMsQ0FBQyxDQUFDLHdEQUF3RDtJQUNyRSx3QkFBa0IsR0FBRyxFQUFFLEdBQUcsRUFBRSxDQUFDLENBQUMsNkNBQTZDO0lBQzNFLHNCQUFnQixHQUFHLE1BQUEsa0JBQWtCLEdBQUcsTUFBTSxDQUFDLFVBQVUsQ0FBQyxDQUFDLG9EQUFvRDtJQUMvRyxxQkFBZSxHQUFHLEdBQUcsQ0FBQyxDQUFDLDBCQUEwQjtJQUNqRCxxQkFBZSxHQUFHLEdBQUcsQ0FBQyxDQUFDLDJCQUEyQjtJQUNsRCxjQUFRLEdBQUcsRUFBRSxDQUFDO0lBQ2QsY0FBUSxHQUFHLEVBQUUsQ0FBQztJQUNkLHNCQUFnQixHQUFHLEVBQUUsQ0FBQztJQUN0QixzQkFBZ0IsR0FBRyxFQUFFLENBQUM7SUFDdEIscUJBQWUsR0FBRyxFQUFFLENBQUMsQ0FBQyx1REFBdUQ7SUFDN0UsY0FBUSxHQUFHLEVBQUUsQ0FBQyxDQUFDLGVBQWU7SUFDOUIsc0JBQWdCLEdBQUcsTUFBTSxDQUFBLENBQUMsdUJBQXVCO0lBQ25ELGlCQUFXLEdBQUcsRUFBRSxDQUFDLENBQUMsaUdBQWlHO0lBQ2pILGdCQUFVLEdBQUcsTUFBTSxDQUFDLFVBQVUsR0FBRyxLQUFLLENBQUMsUUFBUSxHQUFHLEtBQUssQ0FBQyxhQUFhLENBQUMsQ0FBQyw0QkFBNEI7SUFDbkcsNEJBQXNCLEdBQUcsQ0FBQyxDQUFDO0lBQzNCLGlCQUFXLEdBQUcsSUFBSSxDQUFDLENBQUMsc0NBQXNDO0lBQzFELGtCQUFZLEdBQUcsR0FBRyxDQUFDO0lBRWhDLFNBQWdCLElBQUk7UUFDaEIscUVBQXFFO1FBQ3JFLEtBQUksSUFBSSxJQUFJLEdBQUcsQ0FBQyxFQUFFLElBQUksSUFBSSxLQUFLLENBQUMsUUFBUSxFQUFFLElBQUksRUFBRSxFQUFDO1lBQzdDLDBFQUEwRTtZQUMxRSxvQkFBb0I7WUFDcEIsTUFBQSxXQUFXLENBQUMsSUFBSSxDQUFDLE1BQUEsVUFBVSxHQUFHLElBQUksQ0FBQyxHQUFHLENBQUMsQ0FBQyxFQUFFLElBQUksQ0FBQyxDQUFDLENBQUM7U0FDcEQ7UUFDRCwyQkFBMkI7SUFDL0IsQ0FBQztJQVJlLFVBQUksT0FRbkIsQ0FBQTtBQUNMLENBQUMsRUE1RVMsS0FBSyxLQUFMLEtBQUssUUE0RWQ7QUM1RUQsSUFBVSxPQUFPLENBcUZoQjtBQXJGRCxXQUFVLE9BQU87SUFFYixJQUFJLEtBQXVCLENBQUM7SUFFNUIsU0FBZ0IsSUFBSTtRQUNoQixzREFBc0Q7UUFDdEQsSUFBSSxZQUFvQixDQUFDO1FBQ3pCLElBQUksQ0FBQyxzQkFBc0IsQ0FBQyxnQkFBZ0IsQ0FBQyxRQUFRLEVBQUUsVUFBUyxDQUFRO1lBQ3BFLElBQUcsWUFBWSxJQUFJLENBQUMsQ0FBQyxFQUFDO2dCQUNsQixvQkFBb0IsQ0FBQyxZQUFZLENBQUMsQ0FBQzthQUN0QztZQUNELFlBQVksR0FBRyxxQkFBcUIsQ0FBQztnQkFDakMsWUFBWSxHQUFHLENBQUMsQ0FBQyxDQUFDO2dCQUNsQixJQUFJLENBQUMsUUFBUSxDQUFDLHNCQUFzQixHQUFHLElBQUksQ0FBQyxzQkFBc0IsQ0FBQyxTQUFTLENBQUM7Z0JBQzdFLFlBQVksQ0FBQyxzQkFBc0IsR0FBRyxJQUFJLENBQUMsUUFBUSxDQUFDLHNCQUFzQixDQUFDO1lBQy9FLENBQUMsQ0FBQyxDQUFDO1FBRVAsQ0FBQyxDQUFDLENBQUM7SUFDUCxDQUFDO0lBZGUsWUFBSSxPQWNuQixDQUFBO0lBRUQsU0FBZ0IsSUFBSSxDQUFDLEtBQWE7UUFDOUIsSUFBSSxDQUFDLHNCQUFzQixDQUFDLFNBQVMsR0FBRyxFQUFFLENBQUM7UUFDM0MsSUFBRyxLQUFLLElBQUksQ0FBQyxDQUFDLEVBQUM7WUFDWCw4QkFBOEI7WUFDOUIsT0FBTztTQUNWO1FBQ0QsSUFBSSxHQUFHLEdBQUcsS0FBSyxDQUFDLFVBQVUsR0FBRyxLQUFLLENBQUMsSUFBSSxHQUFHLEdBQUcsR0FBRyxLQUFLLENBQUMsSUFBSSxHQUFHLGNBQWMsR0FBRyxLQUFLLENBQUM7UUFFcEYsSUFBSSxHQUFHLEdBQUcsSUFBSSxjQUFjLEVBQUUsQ0FBQztRQUMvQixHQUFHLENBQUMsWUFBWSxHQUFHLE1BQU0sQ0FBQztRQUMxQixHQUFHLENBQUMsSUFBSSxDQUFDLEtBQUssRUFBRSxHQUFHLEVBQUUsSUFBSSxDQUFDLENBQUM7UUFDM0IsR0FBRyxDQUFDLGtCQUFrQixHQUFHO1lBQ3JCLGlCQUFpQjtZQUNqQixJQUFHLEdBQUcsQ0FBQyxVQUFVLElBQUksS0FBSyxDQUFDLEdBQUcsQ0FBQyxJQUFJLEVBQUM7Z0JBQ2hDLE9BQU87YUFDVjtZQUNELElBQUcsR0FBRyxDQUFDLFFBQVEsSUFBSSxJQUFJLEVBQUM7Z0JBQ3BCLE9BQU8sQ0FBQyxLQUFLLENBQUMsMkVBQTJFLENBQUMsQ0FBQztnQkFDM0YsT0FBTzthQUNWO1lBQ0QsSUFBRyxPQUFPLEdBQUcsQ0FBQyxRQUFRLElBQUksV0FBVyxFQUFDO2dCQUNsQyxPQUFPLENBQUMsS0FBSyxDQUFDLGdGQUFnRixDQUFDLENBQUM7Z0JBQ2hHLE9BQU87YUFDVjtZQUNELElBQUcsR0FBRyxDQUFDLFFBQVEsQ0FBQyxNQUFNLElBQUksQ0FBQyxFQUFDO2dCQUN4QixPQUFPLENBQUMsS0FBSyxDQUFDLHVDQUF1QyxDQUFDLENBQUM7Z0JBQ3ZELE9BQU87YUFDVjtZQUVELGtCQUFrQjtZQUNsQixLQUFLLEdBQUcsUUFBUSxDQUFDLGFBQWEsQ0FBQyxPQUFPLENBQUMsQ0FBQztZQUN4QyxNQUFNLENBQUMsUUFBUSxFQUFFLEtBQUssR0FBRyxFQUFFLENBQUMsQ0FBQztZQUM3QixNQUFNLFdBQVcsR0FBRyxLQUFLLENBQUMsVUFBVSxHQUFHLEtBQUssQ0FBQyxJQUFJLEdBQUcsR0FBRyxHQUFHLEtBQUssQ0FBQyxJQUFJLEdBQUcsd0JBQXdCLEdBQUcsS0FBSyxDQUFDO1lBQ3hHLE1BQU0sQ0FBQyxNQUFNLEVBQUUsWUFBWSxHQUFHLFdBQVcsR0FBRyxpQkFBaUIsQ0FBQyxDQUFDO1lBQy9ELEtBQUksSUFBSSxHQUFHLElBQUksR0FBRyxDQUFDLFFBQVEsRUFBQztnQkFDeEIsSUFBSSxLQUFLLEdBQUcsR0FBRyxDQUFDLFFBQVEsQ0FBQyxHQUFHLENBQUMsQ0FBQztnQkFDOUIsTUFBTSxDQUFDLEdBQUcsRUFBRSxLQUFLLENBQUMsQ0FBQzthQUN0QjtZQUdELHlCQUF5QjtZQUN6QixJQUFJLENBQUMsc0JBQXNCLENBQUMsV0FBVyxDQUFDLEtBQUssQ0FBQyxDQUFDO1lBRS9DLDBCQUEwQjtZQUMxQixJQUFJLENBQUMsc0JBQXNCLENBQUMsU0FBUyxHQUFHLElBQUksQ0FBQyxRQUFRLENBQUMsc0JBQXNCLENBQUM7UUFDakYsQ0FBQyxDQUFDO1FBQ0YsR0FBRyxDQUFDLElBQUksRUFBRSxDQUFDO0lBQ2YsQ0FBQztJQS9DZSxZQUFJLE9BK0NuQixDQUFBO0lBRUQsU0FBUyxNQUFNLENBQUMsR0FBVyxFQUFFLEtBQWE7UUFDdEMsSUFBSSxHQUFHLEdBQUcsUUFBUSxDQUFDLGFBQWEsQ0FBQyxJQUFJLENBQUMsQ0FBQztRQUV2QyxhQUFhO1FBQ2IsSUFBSSxPQUFPLEdBQUcsUUFBUSxDQUFDLGFBQWEsQ0FBQyxJQUFJLENBQUMsQ0FBQztRQUMzQyxPQUFPLENBQUMsU0FBUyxHQUFHLEdBQUcsQ0FBQztRQUN4QixHQUFHLENBQUMsV0FBVyxDQUFDLE9BQU8sQ0FBQyxDQUFDO1FBRXpCLGNBQWM7UUFDZCxJQUFJLFNBQVMsR0FBRyxRQUFRLENBQUMsYUFBYSxDQUFDLElBQUksQ0FBQyxDQUFDO1FBQzdDLFNBQVMsQ0FBQyxTQUFTLEdBQUcsS0FBSyxDQUFDO1FBQzVCLEdBQUcsQ0FBQyxXQUFXLENBQUMsU0FBUyxDQUFDLENBQUM7UUFFM0IsVUFBVTtRQUNWLEtBQUssQ0FBQyxXQUFXLENBQUMsR0FBRyxDQUFDLENBQUM7SUFDM0IsQ0FBQztBQUNMLENBQUMsRUFyRlMsT0FBTyxLQUFQLE9BQU8sUUFxRmhCO0FDckZELElBQVUsT0FBTyxDQThIaEI7QUE5SEQsV0FBVSxPQUFPO0lBRWpCOzs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7O01Ba0NFO0lBSUYsNkVBQTZFO0lBQzdFLFNBQWdCLElBQUk7UUFFaEIsb0NBQW9DO1FBQ3BDOzs7Ozs7OztXQVFHO1FBRUgsMkRBQTJEO1FBQzNELElBQUksQ0FBQyxnQkFBZ0IsQ0FBQyxnQkFBZ0IsQ0FBQyxPQUFPLEVBQUUsVUFBUyxDQUFRO1lBQzdELENBQUMsQ0FBQyxjQUFjLEVBQUUsQ0FBQztZQUNuQixJQUFJLElBQUksR0FBMEMsQ0FBQyxDQUFDLE1BQU0sQ0FBQztZQUMzRCxNQUFNLElBQUksR0FBRyxRQUFRLENBQUMsSUFBSSxDQUFDLE9BQU8sQ0FBQyxJQUFJLENBQUMsQ0FBQztZQUN6QyxJQUFHLElBQUksSUFBSSxJQUFJLENBQUMsUUFBUSxDQUFDLEdBQUcsRUFBQztnQkFDekIsSUFBSSxDQUFDLFFBQVEsQ0FBQyxHQUFHLEdBQUcsSUFBSSxDQUFDO2dCQUN6QixpQ0FBaUM7Z0JBQ2pDLElBQUksQ0FBQyxpQkFBaUIsR0FBRyxJQUFJLENBQUM7YUFDakM7UUFDTCxDQUFDLENBQUMsQ0FBQztRQUVILHNEQUFzRDtRQUN0RCxJQUFJLFlBQW9CLENBQUM7UUFDekIsSUFBSSxDQUFDLGdCQUFnQixDQUFDLGdCQUFnQixDQUFDLFFBQVEsRUFBRSxVQUFTLENBQVE7WUFDOUQsSUFBRyxZQUFZLElBQUksQ0FBQyxDQUFDLEVBQUM7Z0JBQ2xCLG9CQUFvQixDQUFDLFlBQVksQ0FBQyxDQUFDO2FBQ3RDO1lBQ0QsWUFBWSxHQUFHLHFCQUFxQixDQUFDO2dCQUNqQyxZQUFZLEdBQUcsQ0FBQyxDQUFDLENBQUM7Z0JBQ2xCLElBQUksQ0FBQyxRQUFRLENBQUMsZ0JBQWdCLEdBQUcsSUFBSSxDQUFDLGdCQUFnQixDQUFDLFNBQVMsQ0FBQztnQkFDakUsWUFBWSxDQUFDLGdCQUFnQixHQUFHLElBQUksQ0FBQyxRQUFRLENBQUMsZ0JBQWdCLENBQUM7WUFDbkUsQ0FBQyxDQUFDLENBQUM7UUFFUCxDQUFDLENBQUMsQ0FBQztRQUVILGlDQUFpQztRQUNqQyxJQUFJLEdBQUcsR0FBRyxJQUFJLGNBQWMsRUFBRSxDQUFDO1FBQy9CLEdBQUcsQ0FBQyxZQUFZLEdBQUcsTUFBTSxDQUFDO1FBQzFCLEdBQUcsQ0FBQyxrQkFBa0IsR0FBRztZQUNyQixJQUFHLEdBQUcsQ0FBQyxVQUFVLElBQUksS0FBSyxDQUFDLEdBQUcsQ0FBQyxJQUFJLEVBQUM7Z0JBQ2hDLE9BQU87YUFDVjtZQUNELElBQUcsR0FBRyxDQUFDLFFBQVEsSUFBSSxJQUFJLEVBQUM7Z0JBQ3BCLE9BQU8sQ0FBQyxLQUFLLENBQUMsMkVBQTJFLENBQUMsQ0FBQztnQkFDM0YsT0FBTzthQUNWO1lBQ0QsUUFBQSxVQUFVLEdBQUcsRUFBRSxDQUFDO1lBQ2hCLEtBQUksSUFBSSxHQUFHLElBQUksR0FBRyxDQUFDLFFBQVEsRUFBQztnQkFDeEIsTUFBTSxJQUFJLEdBQUcsUUFBUSxDQUFDLGFBQWEsQ0FBQyxHQUFHLENBQUMsQ0FBQztnQkFFekMsK0ZBQStGO2dCQUMvRixJQUFJLENBQUMsSUFBSSxHQUFHLFNBQVMsR0FBRyxLQUFLLENBQUMsSUFBSSxHQUFHLEdBQUcsR0FBRyxLQUFLLENBQUMsSUFBSSxHQUFHLDBCQUEwQixHQUFHLEdBQUcsQ0FBQyxNQUFNLENBQUM7Z0JBRWhHLHNNQUFzTTtnQkFDdE0sSUFBRyxHQUFHLENBQUMsSUFBSSxHQUFHLFVBQVUsRUFBQztvQkFDckIsR0FBRyxDQUFDLElBQUksR0FBRyxVQUFVLENBQUM7aUJBQ3pCO2dCQUVELElBQUksQ0FBQyxPQUFPLENBQUMsSUFBSSxHQUFHLEdBQUcsQ0FBQyxJQUFJLENBQUM7Z0JBQzdCLE1BQU0sY0FBYyxHQUFHLElBQUksQ0FBQyxlQUFlLENBQUMsR0FBRyxDQUFDLElBQUksQ0FBQyxDQUFDO2dCQUN0RCxNQUFNLE9BQU8sR0FBRyxHQUFHLENBQUMsYUFBYSxDQUFDLE9BQU8sQ0FBQyxZQUFZLEVBQUUsRUFBRSxDQUFDLENBQUMsT0FBTyxDQUFDLFFBQVEsRUFBRSxFQUFFLENBQUMsQ0FBQztnQkFDbEYsSUFBSSxDQUFDLFNBQVMsR0FBRyxPQUFPLEdBQUcsR0FBRyxHQUFHLGNBQWMsR0FBRyxHQUFHLENBQUM7Z0JBQ3RELGlDQUFpQztnQkFDakMsUUFBQSxVQUFVLENBQUMsSUFBSSxDQUFDLElBQUksQ0FBQyxDQUFDO2dCQUN0QixJQUFJLENBQUMsZ0JBQWdCLENBQUMsV0FBVyxDQUFDLElBQUksQ0FBQyxDQUFDO2dCQUN4QyxJQUFJLENBQUMsZ0JBQWdCLENBQUMsV0FBVyxDQUFDLFFBQVEsQ0FBQyxhQUFhLENBQUMsSUFBSSxDQUFDLENBQUMsQ0FBQzthQUNuRTtZQUVELDBCQUEwQjtZQUMxQixJQUFJLENBQUMsZ0JBQWdCLENBQUMsU0FBUyxHQUFHLElBQUksQ0FBQyxRQUFRLENBQUMsZ0JBQWdCLENBQUM7UUFDckUsQ0FBQyxDQUFDO1FBRUYsMkRBQTJEO1FBQzNELElBQUksR0FBVyxDQUFDO1FBQ2hCLEdBQUcsR0FBRyxLQUFLLENBQUMsVUFBVSxHQUFHLEtBQUssQ0FBQyxJQUFJLEdBQUMsR0FBRyxHQUFHLEtBQUssQ0FBQyxJQUFJLEdBQUcsT0FBTyxDQUFDO1FBQy9ELEdBQUcsQ0FBQyxJQUFJLENBQUMsS0FBSyxFQUFFLEdBQUcsRUFBRSxJQUFJLENBQUMsQ0FBQztRQUUzQix3QkFBd0I7UUFDeEIsR0FBRyxDQUFDLElBQUksRUFBRSxDQUFDO0lBQ2YsQ0FBQztJQW5GZSxZQUFJLE9BbUZuQixDQUFBO0FBRUQsQ0FBQyxFQTlIUyxPQUFPLEtBQVAsT0FBTyxRQThIaEI7QUM5SEQsSUFBVSxNQUFNLENBVWY7QUFWRCxXQUFVLE1BQU07SUFFaEIsSUFBSSxRQUFRLEdBQUcsSUFBSSxJQUFJLEVBQUUsQ0FBQyxPQUFPLEVBQUUsQ0FBQztJQUVwQyxTQUFnQixDQUFDLENBQUMsR0FBVztRQUN6QixJQUFJLElBQUksR0FBRyxJQUFJLElBQUksRUFBRSxDQUFDLE9BQU8sRUFBRSxDQUFDO1FBQ2hDLE9BQU8sQ0FBQyxHQUFHLENBQUMsR0FBRyxHQUFHLENBQUMsSUFBSSxHQUFDLFFBQVEsQ0FBQyxHQUFHLElBQUksR0FBRyxHQUFHLENBQUMsQ0FBQztRQUNoRCxRQUFRLEdBQUcsSUFBSSxDQUFDO0lBQ3BCLENBQUM7SUFKZSxRQUFDLElBSWhCLENBQUE7QUFFRCxDQUFDLEVBVlMsTUFBTSxLQUFOLE1BQU0sUUFVZjtBQ1ZELElBQVUsSUFBSSxDQXVFYjtBQXZFRCxXQUFVLElBQUk7SUFFVixXQUFXO0lBQ0EsV0FBTSxHQUFzQixJQUFJLENBQUM7SUFPNUMsbUNBQW1DO0lBQ25DLElBQWlCLFFBQVEsQ0FNeEI7SUFORCxXQUFpQixRQUFRO1FBQ1Ysd0JBQWUsR0FBRyxPQUFPLFlBQVksQ0FBQyxlQUFlLElBQUksV0FBVyxDQUFDLENBQUMsQ0FBQyxFQUFFLENBQUMsQ0FBQyxDQUFDLElBQUksQ0FBQyxLQUFLLENBQUMsWUFBWSxDQUFDLGVBQWUsQ0FBQyxDQUFDO1FBQ3JILGFBQUksR0FBRyxLQUFLLENBQUMsWUFBWSxDQUFDLElBQUksQ0FBQyxDQUFDLENBQUMsQ0FBQyxDQUFDLENBQUMsQ0FBQyxDQUFDLFVBQVUsQ0FBQyxZQUFZLENBQUMsSUFBSSxDQUFDLENBQUM7UUFDcEUsWUFBRyxHQUFHLEtBQUssQ0FBQyxZQUFZLENBQUMsR0FBRyxDQUFDLENBQUMsQ0FBQyxDQUFDLElBQUksQ0FBQyxLQUFLLENBQUMsSUFBSSxJQUFJLEVBQUUsQ0FBQyxPQUFPLEVBQUUsR0FBQyxJQUFJLENBQUMsQ0FBQyxDQUFDLENBQUMsVUFBVSxDQUFDLFlBQVksQ0FBQyxHQUFHLENBQUMsQ0FBQztRQUNyRyx5QkFBZ0IsR0FBSSxLQUFLLENBQUMsWUFBWSxDQUFDLGdCQUFnQixDQUFDLENBQUMsQ0FBQyxDQUFDLENBQUMsQ0FBQyxDQUFDLENBQUMsVUFBVSxDQUFDLFlBQVksQ0FBQyxnQkFBZ0IsQ0FBQyxDQUFDO1FBQ3pHLCtCQUFzQixHQUFJLEtBQUssQ0FBQyxZQUFZLENBQUMsc0JBQXNCLENBQUMsQ0FBQyxDQUFDLENBQUMsQ0FBQyxDQUFDLENBQUMsQ0FBQyxVQUFVLENBQUMsWUFBWSxDQUFDLHNCQUFzQixDQUFDLENBQUM7SUFDMUksQ0FBQyxFQU5nQixRQUFRLEdBQVIsYUFBUSxLQUFSLGFBQVEsUUFNeEI7SUFFRCw2REFBNkQ7SUFDbEQsa0JBQWEsR0FBRyxDQUFDLENBQUMsQ0FBQyxDQUFDLGdCQUFnQjtJQUNwQyxtQkFBYyxHQUFHLENBQUMsQ0FBQyxDQUFDLENBQUMsZ0JBQWdCO0lBQ3JDLFVBQUssR0FBRyxDQUFDLENBQUMsQ0FBQyxDQUFDLHlCQUF5QjtJQUVoRCx3QkFBd0I7SUFDYixXQUFNLEdBQVUsSUFBSSxDQUFDO0lBRXJCLHNCQUFpQixHQUFHLElBQUksQ0FBQztJQUVwQyxJQUFJLElBQUksR0FBRztRQUNQLGVBQWU7UUFDZixLQUFBLGdCQUFnQixHQUFHLFFBQVEsQ0FBQyxjQUFjLENBQUMsVUFBVSxDQUFDLENBQUM7UUFDdkQsS0FBQSxtQkFBbUIsR0FBRyxRQUFRLENBQUMsY0FBYyxDQUFDLGFBQWEsQ0FBQyxDQUFDO1FBQzdELEtBQUEsc0JBQXNCLEdBQUcsUUFBUSxDQUFDLGNBQWMsQ0FBQyxnQkFBZ0IsQ0FBQyxDQUFDO1FBQ25FLEtBQUEsaUJBQWlCLEdBQUcsUUFBUSxDQUFDLGNBQWMsQ0FBQyxVQUFVLENBQUMsQ0FBQztRQUN4RCxLQUFBLE1BQU0sR0FBRyxRQUFRLENBQUMsY0FBYyxDQUFDLFFBQVEsQ0FBQyxDQUFDO1FBQzNDLEtBQUEsTUFBTSxHQUFHLFFBQVEsQ0FBQyxvQkFBb0IsQ0FBQyxRQUFRLENBQUMsQ0FBQyxDQUFDLENBQUMsQ0FBQztRQUVwRCxPQUFPO1FBQ1AsS0FBSyxDQUFDLElBQUksRUFBRSxDQUFDO1FBQ2IsT0FBTyxDQUFDLElBQUksRUFBRSxDQUFDO1FBQ2YsV0FBVyxDQUFDLElBQUksRUFBRSxDQUFDO1FBQ25CLFFBQVEsQ0FBQyxJQUFJLEVBQUUsQ0FBQztRQUNoQixPQUFPLENBQUMsSUFBSSxFQUFFLENBQUM7UUFDZixPQUFPLENBQUMsSUFBSSxFQUFFLENBQUM7UUFDZixZQUFZLENBQUMsSUFBSSxFQUFFLENBQUM7UUFFcEIsSUFBSSxFQUFFLENBQUM7SUFDWCxDQUFDLENBQUM7SUFFRixTQUFnQixJQUFJO1FBRWhCLElBQUcsS0FBQSxpQkFBaUIsRUFBQztZQUNqQixLQUFBLGlCQUFpQixHQUFHLEtBQUssQ0FBQztZQUMxQixNQUFNLEtBQUssR0FBRyxLQUFLLENBQUMsV0FBVyxDQUFDLElBQUksQ0FBQyxRQUFRLENBQUMsSUFBSSxDQUFDLENBQUM7WUFDcEQsS0FBQSxhQUFhLEdBQUcsSUFBSSxDQUFDLEtBQUssQ0FBQyxJQUFJLENBQUMsUUFBUSxDQUFDLEdBQUcsR0FBRyxLQUFLLENBQUMsR0FBRyxLQUFLLENBQUM7WUFDOUQsS0FBQSxjQUFjLEdBQUcsS0FBQSxhQUFhLEdBQUcsS0FBSyxDQUFDO1lBRXZDLFdBQVcsQ0FBQyxJQUFJLEVBQUUsQ0FBQztZQUNuQixRQUFRLENBQUMsSUFBSSxFQUFFLENBQUM7WUFDaEIsT0FBTyxDQUFDLElBQUksRUFBRSxDQUFDO1lBQ2YsWUFBWSxDQUFDLEdBQUcsR0FBRyxJQUFJLENBQUMsUUFBUSxDQUFDLEdBQUcsQ0FBQztZQUNyQyxpREFBaUQ7WUFDakQsWUFBWSxDQUFDLElBQUksR0FBRyxJQUFJLENBQUMsUUFBUSxDQUFDLElBQUksQ0FBQztTQUUxQztRQUVELHFCQUFxQixDQUFDLElBQUksQ0FBQyxDQUFDO0lBQ2hDLENBQUM7SUFsQmUsU0FBSSxPQWtCbkIsQ0FBQTtJQUVELGdCQUFnQixDQUFDLGtCQUFrQixFQUFFLElBQUksQ0FBQyxDQUFDO0FBQy9DLENBQUMsRUF2RVMsSUFBSSxLQUFKLElBQUksUUF1RWI7QUN2RUQsSUFBVSxZQUFZLENBaUZyQjtBQWpGRCxXQUFVLFlBQVk7SUFFdEIsSUFBSSxLQUFrQixDQUFDO0lBRXZCLGdCQUFnQjtJQUNoQixJQUFJLE1BQU0sR0FBRyxLQUFLLENBQUM7SUFDbkIsSUFBSSxNQUFjLENBQUM7SUFFbkIsU0FBZ0IsSUFBSTtRQUNoQixLQUFLLEdBQUcsUUFBUSxDQUFDLGNBQWMsQ0FBQyxZQUFZLENBQUMsQ0FBQztRQUU5QyxXQUFXLEVBQUUsQ0FBQztRQUVkLHFCQUFxQjtRQUNyQixJQUFJLENBQUMsTUFBTSxDQUFDLGdCQUFnQixDQUFDLE9BQU8sRUFBRSxVQUFTLENBQU07WUFDakQsTUFBTSxRQUFRLEdBQUcsSUFBSSxDQUFDLFFBQVEsQ0FBQyxHQUFHLEdBQUcsS0FBSyxDQUFDLFdBQVcsQ0FBQyxJQUFJLENBQUMsUUFBUSxDQUFDLElBQUksQ0FBQyxHQUFHLENBQUMsSUFBSSxDQUFDLEtBQUssQ0FBQyxJQUFJLElBQUksRUFBRSxDQUFDLE9BQU8sRUFBRSxHQUFDLElBQUksQ0FBQyxHQUFDLENBQUMsQ0FBQyxDQUFDO1lBRXZILHVDQUF1QztZQUN2QyxJQUFHLENBQUMsQ0FBQyxNQUFNLEdBQUcsQ0FBQyxJQUFJLElBQUksQ0FBQyxRQUFRLENBQUMsSUFBSSxHQUFHLEtBQUssQ0FBQyxRQUFRLEVBQUM7Z0JBQ25ELElBQUksQ0FBQyxRQUFRLENBQUMsSUFBSSxJQUFJLENBQUMsQ0FBQzthQUMzQjtpQkFBSyxJQUFHLENBQUMsQ0FBQyxNQUFNLEdBQUcsQ0FBQyxJQUFJLElBQUksQ0FBQyxRQUFRLENBQUMsSUFBSSxHQUFHLENBQUMsRUFBQztnQkFDNUMsSUFBSSxDQUFDLFFBQVEsQ0FBQyxJQUFJLElBQUksQ0FBQyxDQUFDO2FBQzNCO1lBQ0QsV0FBVyxFQUFFLENBQUM7WUFFZCxJQUFHLFFBQVEsRUFBQztnQkFDUiw2RkFBNkY7Z0JBQzdGLElBQUksQ0FBQyxRQUFRLENBQUMsR0FBRyxHQUFHLElBQUksQ0FBQyxLQUFLLENBQUMsSUFBSSxJQUFJLEVBQUUsQ0FBQyxPQUFPLEVBQUUsR0FBQyxJQUFJLENBQUMsR0FBRyxLQUFLLENBQUMsV0FBVyxDQUFDLElBQUksQ0FBQyxRQUFRLENBQUMsSUFBSSxDQUFDLENBQUM7YUFDckc7WUFFRCxJQUFJLENBQUMsaUJBQWlCLEdBQUcsSUFBSSxDQUFDO1FBQ2xDLENBQUMsQ0FBQyxDQUFDO1FBRUgsSUFBSSxDQUFDLE1BQU0sQ0FBQyxnQkFBZ0IsQ0FBQyxXQUFXLEVBQUUsQ0FBQyxDQUFDLEVBQUU7WUFDMUMsSUFBRyxDQUFDLENBQUMsTUFBTSxJQUFJLENBQUMsRUFBQztnQkFDYiw0QkFBNEI7Z0JBQzVCLE9BQU87YUFDVjtZQUNELE1BQU0sR0FBRyxJQUFJLENBQUM7WUFDZCxNQUFNLEdBQUcsQ0FBQyxDQUFDLEtBQUssQ0FBQztRQUNyQixDQUFDLENBQUMsQ0FBQztRQUVILGdCQUFnQixDQUFDLFVBQVUsRUFBRSxDQUFDLENBQU0sRUFBRSxFQUFFO1lBQ3BDLElBQUcsQ0FBQyxDQUFDLFNBQVMsSUFBSSxJQUFJLEVBQUM7Z0JBQ25CLDJGQUEyRjtnQkFDM0YsTUFBTSxHQUFHLEtBQUssQ0FBQzthQUNsQjtRQUNMLENBQUMsQ0FBQyxDQUFDO1FBRUgsZ0JBQWdCLENBQUMsU0FBUyxFQUFFLENBQUMsQ0FBQyxFQUFFLEVBQUU7WUFDOUIsTUFBTSxHQUFHLEtBQUssQ0FBQztRQUNuQixDQUFDLENBQUMsQ0FBQztRQUVILGdCQUFnQixDQUFDLFdBQVcsRUFBRSxDQUFDLENBQUMsRUFBRTtZQUM5QixxQkFBcUI7WUFDckIsT0FBTyxDQUFDLFdBQVcsQ0FBQyxDQUFDLENBQUMsT0FBTyxFQUFFLENBQUMsQ0FBQyxPQUFPLENBQUMsQ0FBQztZQUUxQyxJQUFJLENBQUMsTUFBTTtnQkFBRSxPQUFPO1lBQ3BCLENBQUMsQ0FBQyxjQUFjLEVBQUUsQ0FBQztZQUNuQiwyQkFBMkI7WUFDM0IsTUFBTSxVQUFVLEdBQUcsQ0FBQyxDQUFDLENBQUMsS0FBSyxHQUFHLE1BQU0sQ0FBQyxDQUFDO1lBRXRDLCtCQUErQjtZQUMvQixNQUFNLEdBQUcsQ0FBQyxDQUFDLEtBQUssQ0FBQztZQUNqQixNQUFNLFNBQVMsR0FBRyxDQUFDLElBQUksQ0FBQyxNQUFNLENBQUMsS0FBSyxHQUFHLEtBQUssQ0FBQyxRQUFRLENBQUMsQ0FBQztZQUN2RCxNQUFNLFFBQVEsR0FBRyxDQUFDLFVBQVUsR0FBRyxTQUFTLENBQUMsR0FBRyxLQUFLLENBQUMsV0FBVyxDQUFDLElBQUksQ0FBQyxRQUFRLENBQUMsSUFBSSxDQUFDLENBQUM7WUFDbEYsSUFBSSxDQUFDLFFBQVEsQ0FBQyxHQUFHLElBQUksSUFBSSxDQUFDLEtBQUssQ0FBQyxRQUFRLENBQUMsQ0FBQztZQUUxQyxvQ0FBb0M7WUFDcEMsSUFBRyxJQUFJLENBQUMsUUFBUSxDQUFDLEdBQUcsR0FBRyxLQUFLLENBQUMsV0FBVyxDQUFDLElBQUksQ0FBQyxRQUFRLENBQUMsSUFBSSxDQUFDLEdBQUcsSUFBSSxDQUFDLEtBQUssQ0FBQyxJQUFJLElBQUksRUFBRSxDQUFDLE9BQU8sRUFBRSxHQUFDLElBQUksQ0FBQyxFQUFDO2dCQUNqRyxJQUFJLENBQUMsUUFBUSxDQUFDLEdBQUcsR0FBRyxJQUFJLENBQUMsS0FBSyxDQUFDLElBQUksSUFBSSxFQUFFLENBQUMsT0FBTyxFQUFFLEdBQUMsSUFBSSxDQUFDLEdBQUcsS0FBSyxDQUFDLFdBQVcsQ0FBQyxJQUFJLENBQUMsUUFBUSxDQUFDLElBQUksQ0FBQyxDQUFDO2FBQ3JHO1lBRUQsSUFBSSxDQUFDLGlCQUFpQixHQUFHLElBQUksQ0FBQztRQUNsQyxDQUFDLENBQUMsQ0FBQztJQUNQLENBQUM7SUFuRWUsaUJBQUksT0FtRW5CLENBQUE7SUFFRCxTQUFnQixXQUFXO1FBQ3ZCLEtBQUssQ0FBQyxTQUFTLEdBQUcsRUFBRSxHQUFHLENBQUMsSUFBSSxDQUFDLEtBQUssQ0FBQyxJQUFJLENBQUMsUUFBUSxDQUFDLElBQUksR0FBRyxJQUFJLENBQUMsR0FBRyxJQUFJLENBQUMsQ0FBQztJQUMxRSxDQUFDO0lBRmUsd0JBQVcsY0FFMUIsQ0FBQTtBQUVELENBQUMsRUFqRlMsWUFBWSxLQUFaLFlBQVksUUFpRnJCO0FDakZELElBQVUsT0FBTyxDQXdQaEI7QUF4UEQsV0FBVSxPQUFPO0lBQ2hCLDBCQUEwQjtJQUNmLFdBQUcsR0FBNkIsSUFBSSxDQUFDO0lBRWhELFNBQWdCLElBQUk7UUFDbkIsd0NBQXdDO1FBQ3hDLFFBQUEsR0FBRyxHQUFHLElBQUksQ0FBQyxNQUFNLENBQUMsVUFBVSxDQUFDLElBQUksQ0FBQyxDQUFDO1FBQ25DLElBQUksQ0FBQyxtQkFBbUIsQ0FBQyxTQUFTLEdBQUcsQ0FBQyxDQUFDLENBQUMsQ0FBQyxPQUFPLENBQUMsQ0FBQyxDQUFDLENBQUM7UUFFcEQsZ0JBQWdCLENBQUMsUUFBUSxFQUFFO1lBQzFCLElBQUcsSUFBSSxDQUFDLGFBQWEsSUFBSSxDQUFDLENBQUMsRUFBQztnQkFDM0IscURBQXFEO2dCQUNyRCxPQUFPO2FBQ1A7WUFDRCxxQkFBcUIsQ0FBQztnQkFDckIsSUFBSSxFQUFFLENBQUM7WUFDUixDQUFDLENBQUMsQ0FBQztRQUNKLENBQUMsQ0FBQyxDQUFDO0lBQ0osQ0FBQztJQWRlLFlBQUksT0FjbkIsQ0FBQTtJQUVELElBQUksSUFBSSxHQUFHLENBQUMsQ0FBQztJQUNiLElBQUksSUFBSSxHQUFHLENBQUMsQ0FBQztJQUViLFNBQWdCLFdBQVcsQ0FBQyxDQUFTLEVBQUUsQ0FBUztRQUMvQyxJQUFJLE1BQU0sR0FBRyxDQUFDLElBQUksQ0FBQyxLQUFLLENBQUMsR0FBRyxHQUFHLENBQUMsQ0FBQyxJQUFJLEdBQUcsSUFBSSxDQUFDLEdBQUcsQ0FBQyxDQUFDLEdBQUMsQ0FBQyxDQUFDLEdBQUcsQ0FBQyxJQUFJLENBQUMsTUFBTSxDQUFDLE1BQU0sR0FBQyxLQUFLLENBQUMsUUFBUSxDQUFDLENBQUMsQ0FBQyxHQUFHLElBQUksQ0FBQyxDQUFDLEdBQUMsR0FBRyxDQUFDLENBQUMsT0FBTyxDQUFDLENBQUMsQ0FBQyxDQUFDO1FBQ3ZILElBQUksQ0FBQyxtQkFBbUIsQ0FBQyxTQUFTLEdBQUcsTUFBTSxDQUFDO0lBQzdDLENBQUM7SUFIZSxtQkFBVyxjQUcxQixDQUFBO0lBRUQsU0FBZ0IsSUFBSTtRQUNuQixJQUFJLENBQUMsTUFBTSxDQUFDLEtBQUssR0FBRyxJQUFJLENBQUMsTUFBTSxDQUFDLFdBQVcsQ0FBQztRQUM1QyxJQUFJLENBQUMsTUFBTSxDQUFDLE1BQU0sR0FBRyxJQUFJLENBQUMsTUFBTSxDQUFDLFlBQVksQ0FBQztRQUM5QyxNQUFNLGFBQWEsR0FBRyxJQUFJLENBQUMsYUFBYSxDQUFDO1FBQ3pDLE1BQU0sY0FBYyxHQUFHLElBQUksQ0FBQyxjQUFjLENBQUM7UUFDM0MsTUFBTSxJQUFJLEdBQUcsSUFBSSxDQUFDLFFBQVEsQ0FBQyxJQUFJLENBQUM7UUFDaEMsTUFBTSxTQUFTLEdBQUcsT0FBTyxJQUFJLENBQUMsTUFBTSxDQUFDLElBQUksQ0FBQyxDQUFDLGFBQWEsR0FBRyxFQUFFLENBQUMsSUFBSSxXQUFXLENBQUMsQ0FBQyxDQUFDLElBQUksQ0FBQyxNQUFNLENBQUMsSUFBSSxDQUFDLENBQUMsYUFBYSxHQUFHLEVBQUUsQ0FBQyxDQUFDLENBQUMsQ0FBQyxJQUFJLENBQUM7UUFDN0gsTUFBTSxVQUFVLEdBQUcsT0FBTyxJQUFJLENBQUMsTUFBTSxDQUFDLElBQUksQ0FBQyxDQUFDLGNBQWMsR0FBRyxFQUFFLENBQUMsSUFBSSxXQUFXLENBQUMsQ0FBQyxDQUFDLElBQUksQ0FBQyxNQUFNLENBQUMsSUFBSSxDQUFDLENBQUMsY0FBYyxHQUFHLEVBQUUsQ0FBQyxDQUFDLENBQUMsQ0FBQyxJQUFJLENBQUM7UUFDaEksTUFBTSxVQUFVLEdBQUcsS0FBSyxDQUFDLFdBQVcsQ0FBQyxJQUFJLENBQUMsQ0FBQztRQUMzQyxNQUFNLEdBQUcsR0FBRyxJQUFJLENBQUMsUUFBUSxDQUFDLEdBQUcsQ0FBQztRQUM5QixNQUFNLE9BQU8sR0FBa0IsRUFBRSxDQUFDO1FBQ2xDLE1BQU0sVUFBVSxHQUFrQixFQUFFLENBQUM7UUFDckMsTUFBTSxrQkFBa0IsR0FBRyxJQUFJLENBQUMsS0FBSyxDQUFDLENBQUMsQ0FBQyxHQUFHLEdBQUcsVUFBVSxDQUFDLEdBQUcsVUFBVSxDQUFDLEdBQUcsS0FBSyxDQUFDLFVBQVUsQ0FBQyxDQUFDO1FBRTVGLCtHQUErRztRQUMvRyxJQUFHLFNBQVMsSUFBSSxJQUFJLElBQUksVUFBVSxJQUFJLElBQUksRUFBQztZQUMxQywwQkFBMEI7WUFDMUIsTUFBTSxLQUFLLEdBQUcsU0FBUyxJQUFJLElBQUksQ0FBQyxDQUFDLENBQUMsU0FBUyxDQUFDLENBQUMsQ0FBQyxVQUFVLENBQUM7WUFFekQsMkJBQTJCO1lBQzNCLEtBQUksSUFBSSxNQUFNLElBQUksS0FBSyxFQUFDO2dCQUN2QixJQUFHLE9BQU8sS0FBSyxDQUFDLE1BQU0sQ0FBQyxDQUFDLENBQUMsQ0FBQyxJQUFJLFFBQVEsRUFBQztvQkFDdEMsNERBQTREO29CQUM1RCxTQUFTO2lCQUNUO2dCQUNELFVBQVUsQ0FBQyxJQUFJLENBQUMsTUFBTSxDQUFDLENBQUM7YUFDeEI7WUFFRCxxREFBcUQ7WUFDckQsNEZBQTRGO1lBQzVGLElBQUksQ0FBQyxNQUFNLENBQUMsU0FBUyxHQUFHLEVBQUUsQ0FBQztZQUMzQixLQUFJLElBQUksQ0FBQyxHQUFHLENBQUMsRUFBRSxDQUFDLEdBQUcsVUFBVSxDQUFDLE1BQU0sRUFBRSxDQUFDLEVBQUUsRUFBQztnQkFDekMsSUFBSSxNQUFNLEdBQUcsVUFBVSxDQUFDLENBQUMsQ0FBQyxDQUFDO2dCQUMzQixJQUFJLEtBQUssR0FBRyxPQUFPLEtBQUssQ0FBQyxhQUFhLENBQUMsQ0FBQyxDQUFDLElBQUksV0FBVyxDQUFDLENBQUMsQ0FBQyxLQUFLLENBQUMsYUFBYSxDQUFDLENBQUMsQ0FBQyxDQUFDLENBQUMsQ0FBQyxPQUFPLENBQUM7Z0JBQzVGLG1DQUFtQztnQkFDbkMsTUFBTSxLQUFLLEdBQUcsUUFBUSxDQUFDLGFBQWEsQ0FBQyxPQUFPLENBQUMsQ0FBQztnQkFDOUMsNkVBQTZFO2dCQUM3RSxLQUFLLENBQUMsT0FBTyxHQUFHLE9BQU8sSUFBSSxDQUFDLFFBQVEsQ0FBQyxlQUFlLENBQUMsTUFBTSxDQUFDLElBQUksV0FBVyxJQUFJLElBQUksQ0FBQyxRQUFRLENBQUMsZUFBZSxDQUFDLE1BQU0sQ0FBQyxDQUFDO2dCQUNySCxLQUFLLENBQUMsSUFBSSxHQUFHLFVBQVUsQ0FBQztnQkFDeEIsS0FBSyxDQUFDLE9BQU8sR0FBRyxVQUFTLENBQUM7b0JBQ3pCLG9EQUFvRDtvQkFDcEQsSUFBSSxDQUFDLFFBQVEsQ0FBQyxlQUFlLENBQUMsTUFBTSxDQUFDLEdBQUcsS0FBSyxDQUFDLE9BQU8sQ0FBQztvQkFDdEQsWUFBWSxDQUFDLGVBQWUsR0FBRyxJQUFJLENBQUMsU0FBUyxDQUFDLElBQUksQ0FBQyxRQUFRLENBQUMsZUFBZSxDQUFDLENBQUM7b0JBQzdFLElBQUksQ0FBQyxpQkFBaUIsR0FBRyxJQUFJLENBQUM7Z0JBQy9CLENBQUMsQ0FBQztnQkFDRixLQUFLLENBQUMsRUFBRSxHQUFHLE1BQU0sQ0FBQztnQkFDbEIsS0FBSyxDQUFDLEtBQUssR0FBRyxNQUFNLENBQUM7Z0JBQ3JCLE1BQU0sS0FBSyxHQUFxQixRQUFRLENBQUMsYUFBYSxDQUFDLE9BQU8sQ0FBQyxDQUFDO2dCQUNoRSxLQUFLLENBQUMsT0FBTyxHQUFHLE1BQU0sQ0FBQztnQkFDdkIsS0FBSyxDQUFDLEtBQUssQ0FBQyxLQUFLLEdBQUcsS0FBSyxDQUFDO2dCQUMxQixLQUFLLENBQUMsU0FBUyxHQUFHLE1BQU0sQ0FBQyxXQUFXLEVBQUUsQ0FBQztnQkFDdkMsSUFBSSxDQUFDLE1BQU0sQ0FBQyxXQUFXLENBQUMsS0FBSyxDQUFDLENBQUM7Z0JBQy9CLElBQUksQ0FBQyxNQUFNLENBQUMsV0FBVyxDQUFDLEtBQUssQ0FBQyxDQUFDO2dCQUMvQixJQUFJLENBQUMsTUFBTSxDQUFDLFdBQVcsQ0FBQyxRQUFRLENBQUMsYUFBYSxDQUFDLElBQUksQ0FBQyxDQUFDLENBQUM7YUFDdEQ7WUFFRCxzRUFBc0U7WUFDdEUsS0FBSSxJQUFJLE1BQU0sSUFBSSxVQUFVLEVBQUM7Z0JBQzVCLElBQUcsT0FBTyxJQUFJLENBQUMsUUFBUSxDQUFDLGVBQWUsQ0FBQyxNQUFNLENBQUMsSUFBSSxXQUFXLElBQUksSUFBSSxDQUFDLFFBQVEsQ0FBQyxlQUFlLENBQUMsTUFBTSxDQUFDLEVBQUM7b0JBQ3ZHLE9BQU8sQ0FBQyxJQUFJLENBQUMsTUFBTSxDQUFDLENBQUM7aUJBQ3JCO2FBQ0Q7WUFFRCxvQkFBb0I7WUFDcEIsSUFBSSxHQUFHLENBQUMsQ0FBQztZQUNULElBQUksR0FBRyxDQUFDLENBQUM7WUFDVCxLQUFJLElBQUksTUFBTSxJQUFJLE9BQU8sRUFBQztnQkFDekIsSUFBSSxNQUFNLEdBQUcsRUFBRSxDQUFDO2dCQUNoQixJQUFHLFNBQVMsSUFBSSxJQUFJLEVBQUM7b0JBQ3BCLE1BQU0sQ0FBQyxJQUFJLENBQUMsU0FBUyxDQUFDLENBQUM7aUJBQ3ZCO2dCQUNELElBQUcsVUFBVSxJQUFJLElBQUksRUFBQztvQkFDckIsTUFBTSxDQUFDLElBQUksQ0FBQyxVQUFVLENBQUMsQ0FBQztpQkFDeEI7Z0JBQ0QsS0FBSSxJQUFJLEtBQUssSUFBSSxNQUFNLEVBQUM7b0JBQ3ZCLHFDQUFxQztvQkFDckMsS0FBSSxJQUFJLEdBQUcsSUFBSSxLQUFLLENBQUMsTUFBTSxDQUFDLEVBQUM7d0JBQzVCLG9DQUFvQzt3QkFDcEMsSUFBRyxHQUFHLEdBQUcsSUFBSSxJQUFJLElBQUksSUFBSSxJQUFJLEVBQUM7NEJBQzdCLElBQUksR0FBRyxHQUFHLENBQUM7eUJBQ1g7d0JBQ0QsSUFBRyxHQUFHLEdBQUcsSUFBSSxJQUFJLElBQUksSUFBSSxJQUFJLEVBQUM7NEJBQzdCLElBQUksR0FBRyxHQUFHLENBQUM7eUJBQ1g7cUJBQ0Q7aUJBQ0Q7YUFDRDtTQUNEO1FBRUQsZ0ZBQWdGO1FBQ2hGLElBQUcsSUFBSSxJQUFJLElBQUksSUFBSSxJQUFJLElBQUksQ0FBQyxJQUFJLENBQUMsTUFBTSxDQUFDLFFBQVEsQ0FBQyxJQUFJLENBQUMsSUFBSSxDQUFDLE1BQU0sQ0FBQyxRQUFRLENBQUMsSUFBSSxDQUFDLElBQUksS0FBSyxDQUFDLElBQUksQ0FBQyxJQUFJLEtBQUssQ0FBQyxJQUFJLENBQUMsSUFBSSxJQUFJLENBQUMsR0FBRyxDQUFDLElBQUksR0FBQyxJQUFJLENBQUMsSUFBSSxDQUFDLEVBQUM7WUFDMUksMklBQTJJO1lBQzNJLElBQUksR0FBRyxDQUFDLENBQUM7WUFDVCxJQUFJLEdBQUcsQ0FBQyxDQUFDO1NBQ1Q7UUFFRCwwQkFBMEI7UUFDMUIsTUFBTSxNQUFNLEdBQUcsQ0FBQyxJQUFJLENBQUMsTUFBTSxDQUFDLE1BQU0sR0FBRyxLQUFLLENBQUMsUUFBUSxDQUFDLEdBQUcsQ0FBQyxJQUFJLEdBQUMsSUFBSSxDQUFDLENBQUM7UUFFbkUsc0JBQXNCO1FBQ3RCLFFBQUEsR0FBRyxDQUFDLFdBQVcsR0FBRyxTQUFTLENBQUMsQ0FBQyxzQkFBc0I7UUFDbkQsUUFBQSxHQUFHLENBQUMsU0FBUyxHQUFHLE9BQU8sQ0FBQyxDQUFDLGFBQWE7UUFDdEMsUUFBQSxHQUFHLENBQUMsU0FBUyxFQUFFLENBQUM7UUFDaEIsUUFBQSxHQUFHLENBQUMsSUFBSSxHQUFHLGVBQWUsQ0FBQztRQUUzQiwrQ0FBK0M7UUFDL0MsSUFBSSxTQUFTLEdBQUcsQ0FBQyxDQUFDO1FBQ2xCLFFBQUEsR0FBRyxDQUFDLFNBQVMsR0FBRyxPQUFPLENBQUM7UUFDeEIsSUFBSSxXQUFtQixDQUFDO1FBQ3hCLE9BQU0sU0FBUyxJQUFJLENBQUMsRUFBQztZQUNwQixJQUFJLE1BQU0sR0FBRyxJQUFJLEdBQUcsQ0FBQyxDQUFDLElBQUksR0FBQyxJQUFJLENBQUMsR0FBRyxDQUFDLENBQUMsR0FBQyxTQUFTLENBQUMsQ0FBQyxDQUFDO1lBQ2xELElBQUksU0FBUyxHQUFHLENBQUMsSUFBSSxDQUFDLE1BQU0sQ0FBQyxNQUFNLEdBQUMsS0FBSyxDQUFDLFFBQVEsQ0FBQyxHQUFHLFNBQVMsQ0FBQztZQUNoRSxRQUFBLEdBQUcsQ0FBQyxNQUFNLENBQUMsS0FBSyxDQUFDLFFBQVEsRUFBRSxTQUFTLENBQUMsQ0FBQztZQUN0QyxRQUFBLEdBQUcsQ0FBQyxNQUFNLENBQUMsSUFBSSxDQUFDLE1BQU0sQ0FBQyxLQUFLLEVBQUUsU0FBUyxDQUFDLENBQUM7WUFDekMsV0FBVyxHQUFHLE1BQU0sQ0FBQyxPQUFPLENBQUMsQ0FBQyxDQUFDLENBQUM7WUFDaEMscUNBQXFDO1lBQ3JDLElBQUksYUFBYSxHQUFHLENBQUMsQ0FBQztZQUN0QixJQUFHLFNBQVMsSUFBSSxDQUFDLEVBQUM7Z0JBQ2pCLGFBQWEsR0FBRyxFQUFFLENBQUM7YUFDbkI7aUJBQUssSUFBRyxTQUFTLElBQUksQ0FBQyxFQUFDO2dCQUN2QixhQUFhLEdBQUcsQ0FBQyxFQUFFLENBQUM7YUFDcEI7WUFDRCxRQUFBLEdBQUcsQ0FBQyxRQUFRLENBQUMsV0FBVyxFQUFFLEtBQUssQ0FBQyxRQUFRLEdBQUcsS0FBSyxDQUFDLGdCQUFnQixFQUFFLFNBQVMsR0FBRyxhQUFhLENBQUMsQ0FBQztZQUM5RixTQUFTLElBQUksS0FBSyxDQUFDLGVBQWUsQ0FBQztTQUNuQztRQUVELDZDQUE2QztRQUM3QyxJQUFJLFNBQVMsR0FBRyxDQUFDLENBQUM7UUFDbEIsT0FBTSxTQUFTLElBQUksQ0FBQyxFQUFDO1lBQ3BCLE1BQU0sU0FBUyxHQUFHLEtBQUssQ0FBQyxRQUFRLEdBQUcsU0FBUyxHQUFHLENBQUMsSUFBSSxDQUFDLE1BQU0sQ0FBQyxLQUFLLEdBQUcsS0FBSyxDQUFDLFFBQVEsQ0FBQyxDQUFDO1lBQ3BGLFFBQUEsR0FBRyxDQUFDLE1BQU0sQ0FBQyxTQUFTLEVBQUUsQ0FBQyxDQUFDLENBQUM7WUFDekIsUUFBQSxHQUFHLENBQUMsTUFBTSxDQUFDLFNBQVMsRUFBRSxJQUFJLENBQUMsTUFBTSxDQUFDLE1BQU0sR0FBRyxLQUFLLENBQUMsUUFBUSxDQUFDLENBQUM7WUFDM0QsSUFBSSxRQUFRLEdBQUcsSUFBSSxDQUFDLFFBQVEsQ0FBQyxHQUFHLEdBQUcsS0FBSyxDQUFDLFdBQVcsQ0FBQyxJQUFJLENBQUMsR0FBRyxTQUFTLENBQUM7WUFDdkUsV0FBVyxHQUFHLElBQUksQ0FBQyxlQUFlLENBQUMsUUFBUSxDQUFDLENBQUM7WUFDN0MsSUFBRyxTQUFTLElBQUksQ0FBQyxFQUFDO2dCQUNqQixRQUFBLEdBQUcsQ0FBQyxTQUFTLEdBQUcsTUFBTSxDQUFDO2FBQ3ZCO2lCQUFLLElBQUcsU0FBUyxJQUFJLENBQUMsRUFBQyxFQUFFLG9DQUFvQztnQkFDN0QsUUFBQSxHQUFHLENBQUMsU0FBUyxHQUFHLE9BQU8sQ0FBQzthQUN4QjtpQkFBSTtnQkFDSixRQUFBLEdBQUcsQ0FBQyxTQUFTLEdBQUcsUUFBUSxDQUFDO2FBQ3pCO1lBQ0QsUUFBQSxHQUFHLENBQUMsUUFBUSxDQUFDLFdBQVcsRUFBRSxTQUFTLEVBQUUsSUFBSSxDQUFDLE1BQU0sQ0FBQyxNQUFNLEdBQUcsS0FBSyxDQUFDLGdCQUFnQixDQUFDLENBQUM7WUFDbEYsU0FBUyxJQUFLLEtBQUssQ0FBQyxlQUFlLENBQUM7U0FDcEM7UUFDRCxRQUFBLEdBQUcsQ0FBQyxNQUFNLEVBQUUsQ0FBQztRQUViLDJEQUEyRDtRQUMzRCxJQUFHLFNBQVMsSUFBSSxJQUFJLElBQUksVUFBVSxJQUFJLElBQUksRUFBQztZQUMxQywrRUFBK0U7WUFDL0UsSUFBSSxLQUFLLEdBQUcsQ0FBQyxDQUFDLENBQUM7WUFDZixJQUFHLFNBQVMsSUFBSSxJQUFJLElBQUksT0FBTyxTQUFTLENBQUMsTUFBTSxJQUFJLFdBQVcsSUFBSSxrQkFBa0IsR0FBRyxTQUFTLENBQUMsTUFBTSxDQUFDLE1BQU0sRUFBQztnQkFDOUcsaUNBQWlDO2dCQUNqQyxLQUFLLEdBQUcsU0FBUyxDQUFDLE1BQU0sQ0FBQyxrQkFBa0IsQ0FBQyxDQUFDO2FBQzdDO2lCQUFLLElBQUcsVUFBVSxJQUFJLElBQUksSUFBSSxPQUFPLFVBQVUsSUFBSSxXQUFXLElBQUksa0JBQWtCLEdBQUcsS0FBSyxDQUFDLFVBQVUsSUFBSSxrQkFBa0IsR0FBRyxLQUFLLENBQUMsVUFBVSxHQUFHLFVBQVUsQ0FBQyxNQUFNLENBQUMsTUFBTSxFQUFDO2dCQUM1SyxrREFBa0Q7Z0JBQ2xELEtBQUssR0FBRyxVQUFVLENBQUMsTUFBTSxDQUFDLGtCQUFrQixHQUFHLEtBQUssQ0FBQyxVQUFVLENBQUMsQ0FBQzthQUNqRTtZQUVELElBQUcsS0FBSyxJQUFJLElBQUksQ0FBQyxLQUFLLEVBQUM7Z0JBQ3RCLHNEQUFzRDtnQkFDdEQsSUFBSSxDQUFDLEtBQUssR0FBRyxLQUFLLENBQUM7Z0JBQ25CLE9BQU8sQ0FBQyxJQUFJLENBQUMsS0FBSyxDQUFDLENBQUM7YUFDcEI7WUFFRCxJQUFJLElBQUksR0FBRyxDQUFDLENBQUM7WUFDYiw0QkFBNEI7WUFDNUIsS0FBSSxJQUFJLEtBQUssR0FBRyxDQUFDLEVBQUUsS0FBSyxHQUFHLE9BQU8sQ0FBQyxNQUFNLEVBQUUsS0FBSyxFQUFFLEVBQUM7Z0JBQ2xELHFFQUFxRTtnQkFDckUsSUFBSSxLQUFhLENBQUM7Z0JBQ2xCLElBQUksTUFBTSxHQUFHLE9BQU8sQ0FBQyxLQUFLLENBQUMsQ0FBQztnQkFDNUIsS0FBSSxJQUFJLFFBQVEsR0FBRyxDQUFDLEVBQUUsUUFBUSxHQUFHLFVBQVUsQ0FBQyxNQUFNLEVBQUUsUUFBUSxFQUFFLEVBQUM7b0JBQzlELElBQUcsVUFBVSxDQUFDLFFBQVEsQ0FBQyxJQUFJLE1BQU0sRUFBQzt3QkFDakMsS0FBSyxHQUFHLEtBQUssQ0FBQyxhQUFhLENBQUMsUUFBUSxDQUFDLENBQUM7d0JBQ3RDLE1BQU07cUJBQ047aUJBQ0Q7Z0JBQ0QscUNBQXFDO2dCQUNyQyxRQUFBLEdBQUcsQ0FBQyxXQUFXLEdBQUcsS0FBSyxDQUFDO2dCQUN4QixRQUFBLEdBQUcsQ0FBQyxTQUFTLEVBQUUsQ0FBQztnQkFFaEIsSUFBSSxTQUFTLEdBQUcsSUFBSSxDQUFDO2dCQUNyQixJQUFJLElBQUksR0FBRyxDQUFDLENBQUM7Z0JBQ2IsS0FBSSxJQUFJLFNBQVMsR0FBRyxDQUFDLEVBQUUsU0FBUyxHQUFHLEtBQUssQ0FBQyxVQUFVLEVBQUUsU0FBUyxFQUFFLEVBQUM7b0JBQ2hFLElBQUksV0FBVyxHQUFHLGtCQUFrQixHQUFHLFNBQVMsQ0FBQztvQkFDakQsSUFBSSxHQUFXLENBQUM7b0JBQ2hCLHFFQUFxRTtvQkFDckUsSUFBRyxTQUFTLElBQUksSUFBSSxJQUFJLFdBQVcsR0FBRyxTQUFTLENBQUMsSUFBSSxDQUFDLE1BQU0sRUFBQzt3QkFDM0QsaUNBQWlDO3dCQUNqQyxHQUFHLEdBQUcsU0FBUyxDQUFDLE1BQU0sQ0FBQyxDQUFDLFdBQVcsQ0FBQyxDQUFDO3FCQUNyQzt5QkFBSyxJQUFHLFVBQVUsSUFBSSxJQUFJLElBQUksV0FBVyxHQUFHLEtBQUssQ0FBQyxVQUFVLElBQUksQ0FBQyxXQUFXLEdBQUcsS0FBSyxDQUFDLFVBQVUsQ0FBQyxHQUFHLFVBQVUsQ0FBQyxJQUFJLENBQUMsTUFBTSxFQUFDO3dCQUMxSCxrREFBa0Q7d0JBQ2xELEdBQUcsR0FBRyxVQUFVLENBQUMsTUFBTSxDQUFDLENBQUMsV0FBVyxHQUFHLEtBQUssQ0FBQyxVQUFVLENBQUMsQ0FBQztxQkFDekQ7eUJBQUk7d0JBQ0osb0dBQW9HO3dCQUNwRyxTQUFTLEdBQUcsSUFBSSxDQUFDO3dCQUNqQixTQUFTO3FCQUNUO29CQUVELElBQUksQ0FBQyxHQUFHLEtBQUssQ0FBQyxRQUFRLEdBQUcsSUFBSSxDQUFDLEtBQUssQ0FBQyxDQUFDLENBQUMsU0FBUyxHQUFDLEtBQUssQ0FBQyxVQUFVLENBQUMsR0FBRyxDQUFDLElBQUksQ0FBQyxNQUFNLENBQUMsS0FBSyxHQUFHLEtBQUssQ0FBQyxRQUFRLENBQUMsQ0FBQyxDQUFDLENBQUM7b0JBQzNHLElBQUksQ0FBQyxHQUFHLElBQUksQ0FBQyxNQUFNLENBQUMsTUFBTSxHQUFHLElBQUksQ0FBQyxLQUFLLENBQUMsQ0FBQyxDQUFDLEdBQUcsR0FBQyxJQUFJLENBQUMsR0FBRyxNQUFNLENBQUMsQ0FBQyxHQUFHLEtBQUssQ0FBQyxRQUFRLENBQUM7b0JBRWhGLElBQUcsU0FBUyxFQUFDO3dCQUNaLDhDQUE4Qzt3QkFDOUMsUUFBQSxHQUFHLENBQUMsTUFBTSxDQUFDLENBQUMsRUFBRSxDQUFDLENBQUMsQ0FBQzt3QkFDakIsU0FBUyxHQUFHLEtBQUssQ0FBQztxQkFDbEI7eUJBQUk7d0JBQ0osOENBQThDO3dCQUM5QyxRQUFBLEdBQUcsQ0FBQyxNQUFNLENBQUMsQ0FBQyxFQUFFLENBQUMsQ0FBQyxDQUFDO3dCQUNqQixJQUFJLEVBQUUsQ0FBQztxQkFDUDtpQkFDRDtnQkFFRCxRQUFBLEdBQUcsQ0FBQyxNQUFNLEVBQUUsQ0FBQzthQUNiO1lBRUQsMkJBQTJCO1lBQzNCLFFBQUEsR0FBRyxDQUFDLE1BQU0sRUFBRSxDQUFDO1NBQ2I7SUFDRixDQUFDO0lBMU5lLFlBQUksT0EwTm5CLENBQUE7QUFFRixDQUFDLEVBeFBTLE9BQU8sS0FBUCxPQUFPLFFBd1BoQjtBQ3hQRCxJQUFVLFFBQVEsQ0FnRGpCO0FBaERELFdBQVUsUUFBUTtJQUNkLElBQUksTUFBTSxHQUE0QixFQUFFLENBQUM7SUFFekMsSUFBSSxlQUF1QixDQUFDO0lBQzVCLElBQUksY0FBc0IsQ0FBQztJQUMzQixJQUFJLGdCQUF3QixDQUFDO0lBQzdCLElBQUksVUFBa0IsQ0FBQztJQUN2QixJQUFJLFdBQW1CLENBQUM7SUFDeEIsTUFBTSxVQUFVLEdBQUcsQ0FBQyxHQUFHLEtBQUssQ0FBQyxlQUFlLENBQUM7SUFDN0MsSUFBSSxVQUFrQixDQUFDLENBQUMsc0NBQXNDO0lBRTlELFNBQWdCLElBQUk7UUFDaEIsZUFBZSxHQUFHLElBQUksQ0FBQyxpQkFBaUIsQ0FBQyxZQUFZLENBQUM7UUFDdEQsY0FBYyxHQUFHLElBQUksQ0FBQyxpQkFBaUIsQ0FBQyxXQUFXLENBQUM7UUFDcEQsVUFBVSxHQUFHLElBQUksQ0FBQyxLQUFLLENBQUMsY0FBYyxHQUFHLFVBQVUsQ0FBQyxDQUFDO1FBQ3JELGdCQUFnQixHQUFHLFVBQVUsR0FBRyxLQUFLLENBQUMsV0FBVyxDQUFDO1FBQ2xELFdBQVcsR0FBRyxLQUFLLENBQUMsWUFBWSxHQUFHLGdCQUFnQixDQUFDO1FBQ3BELFVBQVUsR0FBSSxLQUFLLENBQUMsV0FBVyxDQUFDLElBQUksQ0FBQyxRQUFRLENBQUMsSUFBSSxDQUFDLEdBQUksVUFBVSxDQUFDO1FBRWxFLCtJQUErSTtRQUMvSSxLQUFJLElBQUksQ0FBQyxHQUFHLENBQUMsRUFBRSxDQUFDLEdBQUcsVUFBVSxFQUFFLENBQUMsRUFBRSxFQUFDO1lBQy9CLElBQUksR0FBRyxHQUFHLFFBQVEsQ0FBQyxhQUFhLENBQUMsS0FBSyxDQUFDLENBQUM7WUFDeEMsR0FBRyxDQUFDLE1BQU0sR0FBRztnQkFDVCxHQUFHLENBQUMsS0FBSyxDQUFDLFVBQVUsR0FBRyxTQUFTLENBQUM7WUFDckMsQ0FBQyxDQUFBO1lBQ0QsR0FBRyxDQUFDLE9BQU8sR0FBRztnQkFDVixHQUFHLENBQUMsS0FBSyxDQUFDLFVBQVUsR0FBRyxRQUFRLENBQUM7WUFDcEMsQ0FBQyxDQUFBO1lBQ0QsR0FBRyxDQUFDLEtBQUssR0FBRyxVQUFVLENBQUM7WUFDdkIsR0FBRyxDQUFDLE1BQU0sR0FBRyxXQUFXLENBQUMsQ0FBQyxXQUFXO1lBQ3JDLE1BQU0sQ0FBQyxJQUFJLENBQUMsR0FBRyxDQUFDLENBQUM7WUFDakIsSUFBSSxDQUFDLGlCQUFpQixDQUFDLFdBQVcsQ0FBQyxHQUFHLENBQUMsQ0FBQztTQUMzQztJQUNMLENBQUM7SUF0QmUsYUFBSSxPQXNCbkIsQ0FBQTtJQUVELCtDQUErQztJQUMvQyxTQUFnQixJQUFJO1FBRWhCLElBQUksU0FBUyxHQUFHLElBQUksQ0FBQyxRQUFRLENBQUMsR0FBRyxDQUFDO1FBQ2xDLEtBQUksSUFBSSxDQUFDLEdBQUcsQ0FBQyxFQUFFLENBQUMsR0FBRyxVQUFVLEVBQUUsQ0FBQyxFQUFFLEVBQUM7WUFDL0Isb0VBQW9FO1lBQ3BFLElBQUksSUFBSSxHQUFHLFNBQVMsR0FBRyxDQUFDLFNBQVMsR0FBRyxLQUFLLENBQUMsc0JBQXNCLENBQUMsQ0FBQztZQUNsRSxNQUFNLENBQUMsQ0FBQyxDQUFDLENBQUMsS0FBSyxDQUFDLFVBQVUsR0FBRyxRQUFRLENBQUM7WUFDdEMsTUFBTSxDQUFDLENBQUMsQ0FBQyxDQUFDLEdBQUcsR0FBRyxLQUFLLENBQUMsVUFBVSxHQUFHLEtBQUssQ0FBQyxJQUFJLEdBQUcsR0FBRyxHQUFHLEtBQUssQ0FBQyxJQUFJLEdBQUcsbUNBQW1DLEdBQUcsSUFBSSxDQUFDO1lBQzlHLFNBQVMsSUFBSSxVQUFVLENBQUM7U0FDM0I7UUFDRCxNQUFNLFNBQVMsR0FBRyxJQUFJLENBQUMsUUFBUSxDQUFDLEdBQUcsQ0FBQztJQUN4QyxDQUFDO0lBWGUsYUFBSSxPQVduQixDQUFBO0FBQ0wsQ0FBQyxFQWhEUyxRQUFRLEtBQVIsUUFBUSxRQWdEakI7QUNoREQsSUFBVSxJQUFJLENBc0JiO0FBdEJELFdBQVUsSUFBSTtJQUVkLCtDQUErQztJQUNwQyxvQkFBZSxHQUFHLFVBQVMsUUFBZ0I7UUFDbEQsd0NBQXdDO1FBQ3hDLG9EQUFvRDtRQUVwRCx5QkFBeUI7UUFDekIsT0FBTyxJQUFJLElBQUksQ0FBQyxRQUFRLEdBQUcsSUFBSSxDQUFDLENBQUMsTUFBTSxFQUFFLENBQUMsT0FBTyxDQUFDLEdBQUcsRUFBRSxHQUFHLENBQUMsQ0FBQyxLQUFLLENBQUMsQ0FBQyxFQUFFLEVBQUUsQ0FBQyxDQUFDO1FBRXpFLCtDQUErQztRQUMvQzs7Ozs7Ozs7K0JBUXVCO0lBQzNCLENBQUMsQ0FBQTtBQUVELENBQUMsRUF0QlMsSUFBSSxLQUFKLElBQUksUUFzQmIifQ==