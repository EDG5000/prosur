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
                return;
            }
            if(xhr.status == 404){
                // Request succeeded, but no data was found (empty chunk). Invoke the callback regardless.
                Main.chunks[Main.Settings.zoom][min + ""] = null; // Mark chunk as confirmed empty
                cb(null, zoom);
            }
            if(xhr.response == null){
                console.error("ChunkLoader: failed to download, response was null. Is the backend reachable?");
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
                Main.tick();
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