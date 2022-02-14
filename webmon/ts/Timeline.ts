namespace Timeline{
    let images: Array<HTMLImageElement> = [];

    let containerHeight: number;
    let containerWidth: number;
    let imageScaleFactor: number;
    let imageWidth: number;
    let imageHeight: number;
    const imageCount = 1 / Const.X_GRID_INTERVAL;
    let imageRange: number; // Image width expressed as time range

    let lastCacheBuster = new Date().getTime(); // Use cache buster parameter when requesting last image. Param only updated if last image is invalidated because of live-viewing

    export function init(){
        containerHeight = Main.timelineContainer.clientHeight;
        containerWidth = Main.timelineContainer.clientWidth;
        imageWidth = Math.round(containerWidth / imageCount);
        imageScaleFactor = imageWidth / Const.STILL_WIDTH;
        imageHeight = Const.STILL_HEIGHT * imageScaleFactor;
        imageRange =  Math.round(Const.CHUNK_RANGE[Main.Settings.zoom]  / imageCount);

        //imageCount = Math.ceil(containerWidth / imageWidth) + 1; // One more image is needed; when panning the images, the screen is to remain filled
        for(let i = 0; i < imageCount; i++){
            let img = document.createElement("img");
            img.onload = function(){
                img.style.visibility = "initial";
            }
            img.onerror = function(){
                img.style.visibility = "hidden";
            }
            img.width = imageWidth;
            img.height = imageHeight; // Optional
            images.push(img);
            Main.timelineContainer.appendChild(img);
        }
    }
          
    // Pan the images and update the src attributes
    export function tick(){

        let exactTime = Main.Settings.pan;
        for(let i = 0; i < imageCount; i++){
            // Closest matching 6th frame, as still are only taken on 6th frames
            const min = exactTime;
            exactTime += imageRange;
            const max = exactTime;
            //images[i].style.visibility = "hidden";
            let url = "/file?mode=still&still_id=0&min=" + min + "&max=" + max;
            if(i == imageCount-1){
                // Last image in the row. Add and optionally updatecache buster param
                if(Main.lastImageInvalidated){
                    Main.lastImageInvalidated = false;
                    // Update cache buster flag as last image was deemed invalidated (due to live-viewing of data)
                    lastCacheBuster = new Date().getTime();
                }
                url += "&cacheBuster=" + lastCacheBuster;
            }

            images[i].src = url;
        }
        const startTime = Main.Settings.pan;
    }
}