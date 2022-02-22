namespace Timeline{
    const imageCount = 1 / Const.X_GRID_INTERVAL;

    let images: Array<HTMLImageElement> = [];
    let containerHeight: number;
    let containerWidth: number;
    let imageScaleFactor: number;
    let imageWidth: number;
    let imageHeight: number;
    let imageRange: number; // Image width expressed as time range

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
            img.dataset.queuedUrl = ""; // For queueing a url to be loaded after the current load is complete (as a means of throttling)
            img.dataset.currentUrl = ""; // Storing currently assigned url. Browser will turn the relative url in absolute url in src attr., sabotaging our logic
            img.dataset.active = "false";

            let loadNextImage = function(){
                // If an image different than the currently loaded one is queued up, load it
                if(img.dataset.currentUrl != img.dataset.queuedUrl && img.dataset.queuedUrl != ""){
                    img.dataset.queuedUrl = ""; // Mark queue field as empty
                    img.dataset.currentUrl = img.dataset.nextUrl; // Mark url currently loaded
                    img.src = img.dataset.currentUrl; // Initiate load
                }else{
                    // Load complete and no image queued, mark as inactive
                    img.dataset.active = "false";
                }
            };
            img.onload = function(){
                img.style.visibility = "initial";
                loadNextImage();
            }
            img.onerror = function(){
                img.style.visibility = "hidden";
                loadNextImage();
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
            if(i == imageCount-1 && Main.liveView){
                // Update cache buster flag as last image was deemed invalidated (due to live-viewing of data)
                url += "&cacheBuster=" + new Date().getTime();
            }
            
            // If not currently loading an image, load the image directly
            if(images[i].dataset.active == "true"){
                images[i].dataset.queuedUrl = url; // Only set queue attribute, load image once current load completes
            }else{
                // Not currently loading an image. Directly initiate load (if URL has changed)
                if(images[i].dataset.currentUrl != url){
                    // Currently loaded url different from desired URL, directly load it
                    images[i].dataset.currentUrl = url; // Register URL currently being loaded
                    images[i].dataset.queuedUrl = ""; // No URL queued
                    images[i].dataset.active = "true"; // Mark as active
                    images[i].src = url; // Initiate load
                }
            }
        }
    }
}