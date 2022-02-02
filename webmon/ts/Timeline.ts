namespace Timeline{
    let images: Array<HTMLImageElement> = [];

    let containerHeight: number;
    let containerWidth: number;
    let imageScaleFactor: number;
    let imageWidth: number;
    let imageCount: number;

    export function init(){
        containerHeight = Main.timelineContainer.clientHeight;
        containerWidth = Main.timelineContainer.clientWidth;
        imageScaleFactor = containerHeight / Const.STILL_HEIGHT;
        imageWidth = Math.round(Const.STILL_WIDTH * imageScaleFactor);
        imageCount = Math.round(containerWidth / imageWidth);

        for(let i = 0; i < imageCount; i++){
            let img = document.createElement("img");
            img.height = containerHeight;
            images.push(img);
            Main.timelineContainer.appendChild(img);
        }
    }

    // Pan the images and update the src attributes
    export function tick(){
        return;

        // Determine offset of first image. Which is between 0 and IMAGE_WIDTH
        const offset = Math.round(Main.Settings.pan % imageWidth);

        for(let i = 0; i < imageCount; i++){
            const relativeLeftEdge = 1/(i+1) + (1 / (offset / containerWidth));
            const timeOffset = relativeLeftEdge * Const.CHUNK_RANGE[Main.Settings.zoom];
            let time = Math.round(Main.Settings.pan + timeOffset);
            // Find closest matching 6th frame, as still are only taken on 6th frames
            while(time % Const.STILL_CAPTURE_INTERVAL != 0){
                time++;
            }
            images[i].src = Const.URL_SCHEME + Const.HOST + ":" + Const.PORT + "/file?mode=still&still_id=0&time=" + time;
        }
        const startTime = Main.Settings.pan;

    }
}