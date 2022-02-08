namespace Timeline{
    let images: Array<HTMLImageElement> = [];

    let containerHeight: number;
    let containerWidth: number;
    let imageScaleFactor: number;
    let imageWidth: number;
    let imageHeight: number;
    const imageCount = 1 / Const.X_GRID_INTERVAL;
    let imageRange: number; // Image width expressed as time range

    export function init(){
        containerHeight = Main.timelineContainer.clientHeight;
        containerWidth = Main.timelineContainer.clientWidth;
        imageWidth = Math.round(containerWidth / imageCount);
        imageScaleFactor = imageWidth / Const.STILL_WIDTH;
        imageHeight = Const.STILL_HEIGHT * imageScaleFactor;
        imageRange =  Const.CHUNK_RANGE[Main.Settings.zoom]  / imageCount;

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
            let time = exactTime - (exactTime % Const.STILL_CAPTURE_INTERVAL);
            images[i].style.visibility = "hidden";
            images[i].src = "/file?mode=still&still_id=0&time=" + time;
            exactTime += imageRange;
        }
        const startTime = Main.Settings.pan;
    }
}