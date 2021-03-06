namespace ChunkLoader{
    let framesLoaded = 0;

    export function init(){
        setInterval(function(){
            // When live view is active and 
            if(Main.Settings.liveView && Main.rightChunkTime != -1){
                //console.log("Live view active");
                // Viewing last second; enable live view

                // Reload current right chunk (unless not initialized yet)
                if(Main.rightChunkTime != -1){
                    // TODO when precisely aligned with chunk, and other edge cases, such as at the right boundary of the right
                    
                    get(Main.rightChunkTime, Main.Settings.zoom);
                }

            }
        }, 1000);
        resetCache();
    }

    function resetCache(){
        Main.chunks = [];
        for(let zoom = 0; zoom <= Const.MAX_ZOOM; zoom++){
            Main.chunks.push({}); 
        }
    }

    // Fetch chunk from cache or backend 
    // When overrideCache is high, cache is ignored
    export function get(min: number, zoom: number, cb: () => void = null, overrideCache = false){
        const existsInCache = typeof Main.chunks[zoom][min + ""] != "undefined";
        if(existsInCache && !overrideCache){
            // Cache hit, nothing to fetch
            if(cb != null){
                cb();
            }
            return;
        }

        // Mark chunk as empty before starting request, to avoid further requests for this chunk until the chunk result is obtained
        // Unless cache override is active
        if(!overrideCache){
            Main.chunks[zoom][min + ""] = null;
        }
       

        // Configure request and set callback
        const modulus = Math.pow(2, zoom);
        let url = "/frames?mode=range&min=" + min + "&max=" + (min + Const.CHUNK_RANGE[Main.Settings.zoom]);
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

            let onError = function(){
                if(!overrideCache && typeof Main.chunks[zoom][min + ""] != "undefined"){
                    // If chunk was previously marked empty prior to iniaiting loading of the chunk,
                    // unmark it so it will not trigger a cache hit upon chunk reload
                    delete Main.chunks[zoom][min + ""];
                }
            };

            if(xhr.response == null){
                console.error("ChunkLoader: failed to download, response was null. Is the backend reachable?");
                onError();
                return;
            }
            if(typeof xhr.response == "string"){
                console.error("ChunkLoader: Error from Prosurd: " + xhr.response);
                onError();
                return;
            }
            if(typeof xhr.response.time == "undefined"){
                console.error("ChunkLoader: Response is missing the time property.");
                onError();
                return;
            }
            if(xhr.response.time.length == 0){
                // If there is no data, 404 should be returned. An empty array is considered an error.
                console.error("ChunkLoader: Empty chunk");
                onError();
                return;
            }

            // Check cache limit
            if(!existsInCache){
                // Increase cache size counter, but not when redownloading chunk that was already present in cache
                framesLoaded += xhr.response.time.length;
            }
            
            if(framesLoaded > Const.CACHE_MAX_FRAMES){
                framesLoaded = 0;
                // TODO how to handle cache?
                //console.log("Cache was invalidated due to exceeding maximum size of " + Const.CACHE_MAX_FRAMES);
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