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
        // Mark job in job column
        JobList.markActiveJob(jobId);
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
    function markActiveJob(jobId) {
        // Mark the correct link as selected
        for (let linkIndex in JobList.addedLinks) {
            let link = JobList.addedLinks[linkIndex];
            let jobId = link.dataset.jobId;
            if (jobId == (jobId + "")) {
                link.style.border = "1px solid black";
            }
            else {
                link.style.border = "none";
            }
        }
    }
    JobList.markActiveJob = markActiveJob;
    // Load list of available log files and initiate load of the last-loaded file
    function init(cb) {
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
                link.dataset.jobId = job.job_id;
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
            cb();
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
        JobInfo.init();
        MouseControl.init();
        JobList.init(function () {
            // Start drawing loop
            draw();
        });
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
    let allColumns = [];
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
        const initialChunkOffset = Math.floor(((pan % chunkRange) / chunkRange) * Const.CHUNK_SIZE);
        // If there is data in any of the chunks, update legend, obtain user-selected column list and determine y-range
        if (leftChunk != null || rightChunk != null) {
            // Update legend based on columns present in the data
            // Create checkboxes for toggling the columns and attach a handler for when they are clicked
            if (Main.legend.innerHTML == "") {
                // Pick any non-null chunk
                const chunk = leftChunk != null ? leftChunk : rightChunk;
                let i = 0;
                for (let column in chunk) {
                    if (column == "time") {
                        continue;
                    }
                    allColumns.push(column);
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
                    i++;
                }
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
            if (leftChunk != null && typeof leftChunk.job_id != "undefined") {
                // Offset still within left chunk
                jobId = leftChunk.job_id[initialChunkOffset];
                if (jobId == null) {
                    jobId = -1;
                }
            }
            if (jobId != Main.jobId) {
                // Job ID has changed; persist it and trigger job load
                Main.jobId = jobId;
                JobInfo.load(jobId);
            }
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
                for (let plotIndex = 0; plotIndex < Const.CHUNK_SIZE; plotIndex++) {
                    let chunkOffset = initialChunkOffset + plotIndex;
                    let val = null;
                    //console.log(chunkOffset + " en " + chunkOffset % Const.CHUNK_SIZE);
                    if (leftChunk != null && chunkOffset < Const.CHUNK_SIZE) {
                        // Offset still within left chunk
                        val = leftChunk[column][chunkOffset];
                    }
                    else if (rightChunk != null && chunkOffset > Const.CHUNK_SIZE) {
                        // Offset beyond left chunk and within right chunk
                        val = rightChunk[column][chunkOffset % Const.CHUNK_SIZE];
                    }
                    if (val == null) {
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
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoibWFpbi5qcyIsInNvdXJjZVJvb3QiOiIuLi90cy8iLCJzb3VyY2VzIjpbIkNodW5rTG9hZGVyLnRzIiwiQ29uZmlnLnRzIiwiQ29uc3QudHMiLCJKb2JJbmZvLnRzIiwiSm9iTGlzdC50cyIsIkxvZ2dlci50cyIsIk1haW4udHMiLCJNb3VzZUNvbnRyb2wudHMiLCJQbG90dGVyLnRzIiwiVGltZWxpbmUudHMiLCJVdGlsLnRzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiJBQUFBLElBQVUsV0FBVyxDQW1IcEI7QUFuSEQsV0FBVSxXQUFXO0lBQ2pCLElBQUksWUFBWSxHQUFHLENBQUMsQ0FBQztJQUVyQixTQUFnQixJQUFJO1FBQ2hCLFdBQVcsQ0FBQztZQUNSLHFIQUFxSDtZQUNySCxJQUFHLENBQUMsSUFBSSxDQUFDLFFBQVEsQ0FBQyxHQUFHLEdBQUcsS0FBSyxDQUFDLFdBQVcsQ0FBQyxJQUFJLENBQUMsUUFBUSxDQUFDLElBQUksQ0FBQyxDQUFDLEdBQUcsQ0FBQyxJQUFJLENBQUMsS0FBSyxDQUFDLElBQUksSUFBSSxFQUFFLENBQUMsT0FBTyxFQUFFLEdBQUMsSUFBSSxDQUFDLEdBQUMsQ0FBQyxDQUFDLEVBQUM7Z0JBQ3ZHLHdDQUF3QztnQkFDeEMsSUFBSSxDQUFDLFFBQVEsQ0FBQyxHQUFHLEdBQUcsSUFBSSxDQUFDLEtBQUssQ0FBQyxJQUFJLElBQUksRUFBRSxDQUFDLE9BQU8sRUFBRSxHQUFDLElBQUksQ0FBQyxHQUFHLEtBQUssQ0FBQyxXQUFXLENBQUMsSUFBSSxDQUFDLFFBQVEsQ0FBQyxJQUFJLENBQUMsQ0FBQztnQkFFbEcsMERBQTBEO2dCQUMxRCxJQUFHLElBQUksQ0FBQyxjQUFjLElBQUksQ0FBQyxDQUFDLEVBQUM7b0JBQ3pCLDJHQUEyRztvQkFDM0csT0FBTyxJQUFJLENBQUMsTUFBTSxDQUFDLElBQUksQ0FBQyxRQUFRLENBQUMsSUFBSSxDQUFDLENBQUMsSUFBSSxDQUFDLGNBQWMsR0FBRyxFQUFFLENBQUMsQ0FBQztvQkFDakUs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