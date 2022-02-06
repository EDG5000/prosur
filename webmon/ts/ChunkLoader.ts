namespace ChunkLoader{
    let framesLoaded = 0;

    export function init(){
        setInterval(function(){
            //console.log(Main.Settings.pan + Const.CHUNK_RANGE[Main.Settings.zoom] - (Math.floor(new Date().getTime()/1000)-2));
            if((Main.Settings.pan + Const.CHUNK_RANGE[Main.Settings.zoom]) > (Math.floor(new Date().getTime()/1000)-2)){
                // Viewing last second; enable live view
                Main.Settings.pan = Math.floor(new Date().getTime()/1000) - Const.CHUNK_RANGE[Main.Settings.zoom];
                
                // Reload current right chunk (unless not initialized yet)
                if(Main.rightChunkTime != -1){
                    // TODO when precisely aligned with chunk, and other edge cases, such as at the right boundary of the right
                    delete Main.chunks[Main.Settings.zoom][Main.rightChunkTime + ""];
                    get(Main.rightChunkTime, Main.Settings.zoom);
                }

            }
        }, 500);
        resetCache();
    }

    function resetCache(){
        Main.chunks = [];
        for(let zoom = 0; zoom <= Const.MAX_ZOOM; zoom++){
            Main.chunks.push({}); 
        }
    }

    export function tick(){
        const zoom = Main.Settings.zoom;
        const leftChunkTime = Main.leftChunkTime;
        const rightChunkTime = Main.rightChunkTime;
        get(leftChunkTime, zoom, function(){
            ChunkLoader.get(rightChunkTime, zoom);
        });
    }

    // Fetch chunk from cache or backend 
    export function get(min: number, zoom: number, cb: () => void = null){
        if(typeof Main.chunks[zoom][min + ""] != "undefined"){
            // Cache hit, nothing to fetch
            if(cb != null){
                cb();
            }
            return;
        }

        // Mark chunk as empty before starting request, to avoid further requests for this chunk until the chunk result is obtained
        Main.chunks[zoom][min + ""] = null;

        // Configure request and set callback
        const modulus = Math.pow(2, zoom);
        let url = Const.URL_SCHEME + Const.HOST + ":" + Const.PORT + "/frames?mode=range&min=" + min + "&max=" + (min + Const.CHUNK_RANGE[Main.Settings.zoom]);
        if(modulus != 1){
            url += ("&modulus=" + modulus);
        }
        let xhr = new XMLHttpRequest();
        xhr.responseType = 'json';
        xhr.open("GET", url, true);
        xhr.onreadystatechange = function() {
            // Error checking
            if(xhr.readyState != Const.XHR.DONE){
                // Ignore, wait until state is at XHR.DONE
                return;
            }
            if(xhr.status == 404){
                // Request succeeded, but no data was found (empty chunk). Invoke the callback regardless.
                Main.chunks[zoom][min + ""] = null; // Mark chunk as confirmed empty
                if(cb != null){
                    cb();
                }
                return;
            }
            if(xhr.response == null){
                console.error("ChunkLoader: failed to download, response was null. Is the backend reachable?");
                return;
            }
            if(typeof xhr.response == "string"){
                console.error("ChunkLoader: Error from Prosurd: " + xhr.response);
                return;
            }
            if(typeof xhr.response.time == "undefined"){
                console.error("ChunkLoader: Response is missing the time property.");
                return;
            }
            if(xhr.response.time.length == 0){
                // If there is no data, 404 should be returned. An empty array is considered an error.
                console.error("ChunkLoader: Empty chunk");
                return;
            }

            // Check cache limit
            framesLoaded += xhr.response.time.length;
            if(framesLoaded > Const.CACHE_MAX_FRAMES){
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
            if(cb != null){
                cb();
            }
        };
        xhr.send();
    };

}