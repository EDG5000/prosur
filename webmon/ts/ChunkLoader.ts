namespace ChunkLoader{
    let framesLoaded = 0;

    export function init(){
        resetCache();
    }

    function resetCache(){
        Main.chunks = [];
        for(let zoom = 0; zoom < Const.MAX_ZOOM; zoom++){
            Main.chunks.push({}); 
        }
    }

    export function tick(){
        // Load left chunk
        const range = Const.CHUNK_RANGE[Main.Settings.zoom];
        const leftChunkTime = Math.floor(Main.Settings.pan / range) * range;
        const rightChunkTime = Math.round(Main.Settings.pan / range) * range;

        get(leftChunkTime, Main.Settings.zoom, function(leftChunk, zoom){
            ChunkLoader.get(rightChunkTime, Main.Settings.zoom, function(rightChunk, zoom){
                Plotter.draw(leftChunkTime, rightChunkTime, leftChunk, rightChunk, zoom);
            });
        });   
    }

    // Fetch chunk from cache or backend 
    export function get(min: number, zoom: number, cb: (chunk: any, zoom: number) => void){
        if(typeof Main.chunks[zoom][min + ""] != "undefined"){
            // Cache hit
            cb(Main.chunks[zoom][min + ""], zoom);
            return;
        }

        // Configure request and set callback
        const modulus = Math.pow(2, zoom);
        let url = "http://" + Const.HOST + ":" + Const.PORT + "/frames?mode=range&min=" + min + "&max=" + (min + Const.CHUNK_RANGE[Main.Settings.zoom]);
        if(modulus != 1){
            url += ("&modulus=" + modulus);
        }
        let xhr = new XMLHttpRequest();
        xhr.responseType = 'json';
        xhr.open("GET", url, true);
        xhr.onreadystatechange = function() {
            // Error checking
            if(xhr.readyState != Const.XHR_SUCCESS){
                console.error("ChunkLoader: readyState is " + this.readyState + ". Aborting.");
                return;
            }
            if(typeof xhr.response == "undefined" || xhr.response == null){
                console.error("ChunkLoader: Failure to obtain response JSON data. Check server response header and browser support for JSON response type support in XHR.");
                return;
            }
            if(typeof xhr.response == "string"){
                console.error("ChunkLoader: Error from Prosurd: " + xhr.response);
                return;
            }
            if(typeof xhr.response.frames == "undefined"){
                console.error("ChunkLoader: Response is missing the frames property.");
                return;
            }
            if(typeof xhr.response.parameters == "undefined"){
                console.error("ChunkLoader: Response is missing the parameters property.");
                return;
            }
            if(typeof xhr.response.frames.time == "undefined"){
                console.error("ChunkLoader: The time column is not present in the receive data. Cannot plot data.");
                return;
            }
            if(xhr.response.frames.time.length == 0){
                console.error("ChunkLoader: Empty chunk");
                return;
            }

            // Check cache limit
            framesLoaded += xhr.response.frames.time.length;
            if(framesLoaded > Const.CACHE_MAX_FRAMES){
                console.log("Cache was invalidated due to exceeding maximum size of " + Const.CACHE_MAX_FRAMES);
                resetCache();
                framesLoaded = 0;
                tick();
                return;
            }
            
            // Store chunk
            Main.chunks[Main.Settings.zoom][min + ""] = xhr.response.frames;

            // Callback
            if(cb != null){
                cb(xhr.response.frames, zoom);
            }
        };
        xhr.send();
    };

}



/*
    Checks if new chunks need to be loaded and loads them in Main.chunks
    Will clear all chunks and reload the currently needed chunks when Const.CHUNK_QUOTA is exceeded
    Will perform live-update by loading the last frame and appending it to the current chunk if possible (otherwise, a new chunk is allocated) 
*/

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

//namespace ChunkManager{


        // Scroll to end when opening current file
        /*if(job == Const.CURRENT_LOG_FILE){
            Main.HTMLElements.scroller.scrollLeft = Main.HTMLElements.scroller.scrollWidth - Main.HTMLElements.scroller.clientWidth;
        }*/

   /* 
    export function init(){
    // Periodically obtain last line if the current open file is a live file hc3d-log.log
	setInterval(refreshCurrentFile, 1000);
}


function refreshCurrentFile(){
    if(Main.loading == false && typeof localStorage.lastSession != "undefined" && localStorage.lastSession == Const.CURRENT_LOG_FILE && Main.Data.frames.length > 0){
        let xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function(){
            if(this.readyState != 4) return;
            let frame = new Frame.Frame(this.responseText);
            Main.Data.frames.push(frame);
            let fullyScrolled = Math.floor((Main.HTMLElements.scroller.scrollLeft + Main.HTMLElements.scroller.clientWidth) - Main.HTMLElements.scroller.scrollWidth) > -2;
            Drawer.draw();
            if(fullyScrolled){
                Main.HTMLElements.scroller.scrollLeft = Main.HTMLElements.scroller.scrollWidth - Main.HTMLElements.scroller.clientWidth;
            }
        };
        xhr.open("GET", Const.refreshUrl, true);
        xhr.send();
    }
}
*/
//}